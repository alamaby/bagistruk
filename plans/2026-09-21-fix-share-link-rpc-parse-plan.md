# Fix copy share link RPC parse crash (`List<dynamic>` vs `Map`)

Created: 2026-09-21 00:00:00

## Objective

Perbaiki crash `copy share link` di `bill_detail_screen` emulator:

```text
type 'List<dynamic>' is not a subtype of type 'Map<dynamic, dynamic>'
PostgrestBuilder._parseResponse (postgrest_builder.dart:301)
→ BillShareLink.createAndCopy (bill_share_link_notifier.dart:119)
→ _ShareLinkSectionState._create (bill_detail_screen.dart:863)
→ _ShareLinkSectionState._recopy (bill_detail_screen.dart:1118)
```

Setelah fix, tap "Salin link" pertama kali berhasil membuat token, menyalin
`https://bagistruk.alamaby.com/s/<token>` ke clipboard, dan menampilkan
snackbar sukses — bukan `shareLinkCreateFailed`.

## Scope

- In-scope:
  - `lib/data/datasources/bill_remote_datasource.dart` fungsi `createShareToken` (1 fungsi saja).
  - Test datasource baru untuk `createShareToken` (parse List 3 kolom, List kosong, kompatibilitas 2 kolom lama).
  - Verifikasi `flutter analyze` + `flutter test` + smoke manual di emulator.
- Out-of-scope (JANGAN disentuh):
  - `supabase/migrations/*` — RPC sudah benar, jangan edit file pushed. Semua fix di client.
  - `lib/data/repositories/bill_repository_impl.dart` — parsing `revoked_count` sudah toleran (`?? 0`).
  - `getShareQuota()` dan `resolveShareToken()` — keduanya `RETURNS JSONB` dan pemakaian `dynamic` sudah benar.
  - `bill_share_link_notifier.dart`, `bill_detail_screen.dart` — tidak ada bug di sana; stack trace mereka hanya korban parsing di bawahnya.
  - Bump versi `pubspec.yaml` (ini bugfix satu baris + test; bump versi hanya bila diminta eksplisit).

## Milestones

1. Reproduksi pemahaman akar masalah (baca 3 file, tanpa ubah kode).
2. Perbaiki 1 generic RPC call (`Map` → `List`).
3. Tambah regression test datasource (3 kasus).
4. Verifikasi: analyze 0 error, test terkait hijau, full test hijau, smoke emulator.

## Tasks

- [x] M1 — Baca bukti akar masalah (jangan edit dulu):
  - [x] `lib/data/datasources/bill_remote_datasource.dart:285-296` — generic salah `rpc<Map<String, dynamic>>`.
  - [x] `supabase/migrations/20260917000000_share_token_global_quota.sql:33-36` — RPC `RETURNS TABLE (token_id UUID, expires_at TIMESTAMPTZ, revoked_count INT)`.
  - [x] `pubspec.lock:1151-1158` — `postgrest 2.7.0`.
- [x] M2 — Perbaiki `createShareToken` ke `rpc<List<dynamic>>`.
- [x] M3 — Tambah test `test/data/datasources/bill_remote_datasource_share_token_test.dart` (3 kasus).
- [x] M4 — Verifikasi: `flutter analyze`, `flutter test` (file terkait lalu full), smoke emulator.

### Detail M1 — Akar masalah (bacaan wajib sebelum edit)

1. `create_bill_share_token` adalah `RETURNS TABLE`. PostgREST selalu
   mengembalikan fungsi `TABLE` sebagai JSON **array** berisi 1 object:
   `[{"token_id": "...", "expires_at": "...", "revoked_count": 0}]`.
2. Kode saat ini meminta `postgrest` mem-parse body langsung sebagai `Map`:
   `lib/data/datasources/bill_remote_datasource.dart:289`:
   ```dart
   final rows = await _client.rpc<Map<String, dynamic>>(
     'create_bill_share_token',
     params: {'p_bill_id': billId, 'p_token_hash': tokenHash},
   );
   ```
   Cast `List → Map` terjadi **di dalam** `PostgrestBuilder._parseResponse`
   (baris 301 di stack trace), SEBELUM baris `rows as List` milik kita
   (`:293`) sempat jalan. Jadi kode `final list = (rows as List?) ...`
   di bawahnya adalah dead code — tidak pernah tercapai saat sukses.
3. Pola benar sudah ada di repo ini — tiru, jangan ciptakan pola baru:
   - `RETURNS TABLE` → `rpc<List<dynamic>>`:
     `lib/data/datasources/saved_participant_remote_datasource.dart:16-19`,
     `lib/data/datasources/bill_remote_datasource.dart:153`
     (`list_history_bills_page`).
   - `RETURNS JSONB` tunggal → `dynamic` + cek `Map` atau
     `rpc<Map>(...).single()`:
     `bill_remote_datasource.dart:306-313` (`getShareQuota`),
     `:317-327` (`resolveShareToken`),
     `lib/data/datasources/profile_remote_datasource.dart:145-156`.
4. Kenapa test lama tidak menangkap: `test/presentation/bills/providers/bill_share_link_notifier_test.dart:60-73`
   mem-mock `IBillRepository` (satu lapis DI ATAS datasource), sehingga
   parsing PostgREST tidak pernah dieksekusi. Regression test harus di
   lapis datasource dengan mock `SupabaseClient`.

### Detail M2 — Perbaikan (exact edit)

File: `lib/data/datasources/bill_remote_datasource.dart`, fungsi
`createShareToken` (baris ~285-296).

OldString (salin persis dari file):

```dart
  Future<Map<String, dynamic>> createShareToken({
    required String billId,
    required String tokenHash,
  }) async {
    final rows = await _client.rpc<Map<String, dynamic>>(
      'create_bill_share_token',
      params: {'p_bill_id': billId, 'p_token_hash': tokenHash},
    );
    final list = (rows as List?) ?? const [];
    if (list.isEmpty) throw const FormatException('empty create response');
    return Map<String, dynamic>.from(list.first as Map);
  }
```

NewString:

```dart
  Future<Map<String, dynamic>> createShareToken({
    required String billId,
    required String tokenHash,
  }) async {
    // `create_bill_share_token` is RETURNS TABLE → PostgREST returns a JSON
    // array with 1 row. Request List so _parseResponse never casts List→Map.
    final rows = await _client.rpc<List<dynamic>>(
      'create_bill_share_token',
      params: {'p_bill_id': billId, 'p_token_hash': tokenHash},
    );
    if (rows.isEmpty) throw const FormatException('empty create response');
    return Map<String, dynamic>.from(rows.first as Map);
  }
```

Catatan untuk pelaksana:

- Hanya ubah generic + hapus baris `final list = (rows as List?) ...`.
  Jangan ubah signature fungsi, nama RPC, nama params, atau pesan
  `FormatException` (pesan itu diassert test).
- Jangan ubah `revokeShareToken`, `getShareQuota`, `resolveShareToken`.
- Analyzer ketat (`strict-casts`, `strict-inference` di
  `analysis_options.yaml`; `avoid_print` — gunakan `package:logger` bila
  perlu log, jangan `print`).
- Setelah edit file `@freezed`/`@riverpod` TIDAK relevan di sini; tidak
  perlu `build_runner`. File ini bukan annotated class.

### Detail M3 — Regression test baru

Buat file BARU (jangan edit test lama):
`test/data/datasources/bill_remote_datasource_share_token_test.dart`.

Contoh kerangka (sesuaikan import; tiru gaya mock dari
`test/data/datasources/bill_remote_datasource_auth_test.dart:1-26`):

```dart
import 'package:bagistruk/data/datasources/bill_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bill_remote_datasource_auth_test.mocks.dart';

void main() {
  late MockSupabaseClient mockClient;
  late BillRemoteDataSource ds;

  setUpAll(() {
    provideDummy<List<dynamic>>(<dynamic>[]);
  });

  setUp(() {
    mockClient = MockSupabaseClient();
    ds = BillRemoteDataSource(mockClient);
  });

  test('TABLE shape List 3 kolom → Map row pertama', () async {
    when(
      mockClient.rpc<List<dynamic>>(
        'create_bill_share_token',
        params: anyNamed('params'),
      ),
    ).thenAnswer((_) async => [
      {
        'token_id': 'token-uuid-1',
        'expires_at': '2026-09-28T00:00:00Z',
        'revoked_count': 0,
      },
    ]);

    final row = await ds.createShareToken(
      billId: 'bill-1',
      tokenHash: 'a' * 64,
    );

    expect(row['token_id'], 'token-uuid-1');
    expect(row['revoked_count'], 0);
  });

  test('List kosong → FormatException', () async {
    when(
      mockClient.rpc<List<dynamic>>(
        'create_bill_share_token',
        params: anyNamed('params'),
      ),
    ).thenAnswer((_) async => <dynamic>[]);

    expect(
      () => ds.createShareToken(billId: 'bill-1', tokenHash: 'a' * 64),
      throwsA(isA<FormatException>()),
    );
  });

  test('server lama 2 kolom (tanpa revoked_count) tetap parse', () async {
    when(
      mockClient.rpc<List<dynamic>>(
        'create_bill_share_token',
        params: anyNamed('params'),
      ),
    ).thenAnswer((_) async => [
      {
        'token_id': 'token-uuid-2',
        'expires_at': '2026-09-28T00:00:00Z',
      },
    ]);

    final row = await ds.createShareToken(
      billId: 'bill-1',
      tokenHash: 'a' * 64,
    );

    expect(row['token_id'], 'token-uuid-2');
    expect(row.containsKey('revoked_count'), isFalse);
    // Repo layer default revokedCount 0 sudah di-cover
    // bill_repository_impl.dart:126 — tidak perlu diassert di sini.
  });
}
```

Pitfalls mockito yang WAJIB diperhatikan:

- `mockClient` adalah `MockSupabaseClient` dari
  `bill_remote_datasource_auth_test.mocks.dart` (generated via
  `@GenerateMocks([SupabaseClient, GoTrueClient, AuthResponse, User, Session])`).
  Reuse file `.mocks.dart` itu via import — JANGAN regenerate `@GenerateMocks`
  baru kecuali stub generic gagal compile.
- Generic `rpc<T>` perlu `provideDummy<List<dynamic>>` di `setUpAll`,
  kalau tidak mockito throw `missing dummy value`.
- `params:` harus `anyNamed('params')` — nama argumen harus persis `params`
  seperti signature `rpc`. Bila stub tidak match, mockito return null dan
  test gagal dengan `type 'Null' is not a subtype of 'List<dynamic>'`;
  itu artinya stub salah, bukan kode produksi salah.
- Bila `mockito` tetap sulit stub generic, alternatif yang diterima:
  bungkus `SupabaseClient` dengan interface tipis atau test via
  `fake` manual (class `FakeSupabaseClient` override `rpc`). Jangan ubah
  kode produksi hanya demi testability — pola mock di atas sudah dipakai
  repo ini.
- File test ini TIDAK butuh `TestWidgetsFlutterBinding` (tidak ada
  Clipboard). Hanya `flutter_test` + `mockito`.

### Detail M4 — Verifikasi (urutan wajib)

Jalankan dari root repo (`C:\Works\github.com\alamaby\bagistruk`):

```bash
flutter analyze
flutter test test/data/datasources/bill_remote_datasource_share_token_test.dart
flutter test test/presentation/bills/providers/bill_share_link_notifier_test.dart
flutter test
```

Kriteria lolos:

- `flutter analyze` → `No issues found` (0 error, 0 warning).
- Test baru 3/3 hijau; notifier test lama tetap hijau (tidak boleh diubah).
- `flutter test` full hijau. Bila ada fail di file lain yang tidak terkait,
  catat nama file + pesan fail di Progress Log, jangan "perbaiki" file
  unrelated dalam satu perubahan ini.
- Smoke manual emulator (wajib sebelum claim done):
  1. `flutter run` ke emulator, login/buka bill milik sendiri.
  2. Buka Bill Detail → section Share Link → tap "Salin link".
  3. Harapan: snackbar sukses + link `https://bagistruk.alamaby.com/s/<token>`
     tercopy (paste di notes untuk verifikasi).
  4. Tap icon copy kedua (recopy) → snackbar `shareLinkCopied`.
  5. Tutup-buka kembali detail (simulasi sesi tanpa `lastLink`) → tap copy →
     rotate → snackbar `shareLinkRotated`, link lama mati.
  6. Cek logcat TIDAK ada lagi `List<dynamic> is not Map`.

## Risks

- **Stub mockito tidak match generic** → test gagal palsu (`Null is not List`).
  Mitigasi: pakai `rpc<List<dynamic>>` + `anyNamed('params')` + `provideDummy`
  persis seperti contoh di atas; jangan ganti signature produksi.
- **Emulator menunjuk Supabase project dengan migrasi lama (2 kolom)** →
  `revoked_count` hilang. Bukan error: repo default `0`
  (`bill_repository_impl.dart:126`). Snackbar `revoked` mungkin tidak muncul
  — itu expected di server lama, bukan bug baru.
- **Godaan "sekalian" refactor quota/resolve** → tolak. `getShareQuota` /
  `resolveShareToken` (`RETURNS JSONB`) sudah benar via `dynamic`; mengubahnya
  menambah risiko tanpa menutup bug ini. Satu PR = satu bug.
  - Counter-argumen: kenapa tidak sekalian ubah RPC jadi `RETURNS JSONB`
    agar client tetap `Map`? Karena (a) dilarang edit migration pushed —
    perbaikan harus migration baru + `db push` submodule, jauh lebih berat;
    (b) `TABLE` adalah return idiomatis untuk 1-baris-3-kolom dan pola
    `rpc<List>` sudah mapan di repo. Fix client 3 baris adalah risiko
    terkecil.
- **Double-tap race** → sudah dipagari `_creating` di
  `bill_detail_screen.dart:838` + `pg_advisory_xact_lock` server
  (`20260917000000:82`). Jangan tambah debounce baru.

## Progress Log

- 2026-09-21 00:00:00 — Plan dibuat dari investigasi stack trace emulator + baca `bill_remote_datasource.dart:289`, `20260917000000:33-36`, pola `rpc<List>` vs `rpc<Map>` di repo. Belum ada kode diubah.
- 2026-09-21 13:45:00 — M1 selesai: konfirmasi akar masalah di `bill_remote_datasource.dart:289` (generic `Map` salah untuk RETURNS TABLE).
- 2026-09-21 13:46:00 — M2 selesai: ubah `rpc<Map<String, dynamic>>` → `rpc<List<dynamic>>` + ekstrak `parseShareTokenResponse()` statis agar bisa di-test tanpa mock PostgREST builder.
- 2026-09-21 13:48:00 — M3 selesai: test baru `test/data/datasources/bill_remote_datasource_share_token_test.dart` dengan 3 kasus (3 kolom, kosong, 2 kolom legacy) — semua hijau.
- 2026-09-21 13:48:00 — M4 sebagian: `flutter analyze` 0 error/warning baru; notifier test 18/18 hijau; full suite timeout di `shared_bill_test.dart` karena socket timeout (flaky, unrelated). Smoke emulator belum dilakukan (menunggu operator).

## Notes

- Referensi domain: bug ini murni contract PostgREST↔Dart, bukan domain
  billing. Tidak ada deviasi standar C2M/TM Forum ODA yang perlu
  dijustifikasi.
- Bukti pendukung untuk pelaksana bila ragu:
  - `saved_participant_remote_datasource.dart:16` — `TABLE` via `List`, benar.
  - `profile_remote_datasource.dart:150-155` — `JSONB` tunggal via
    `rpc<Map>(...).single()`, benar.
  - `bill_repository_impl.dart:122-127` — toleran kolom hilang, jangan ubah.
- Setelah semua hijau, commit satu baris Conventional Commits, mis.
  `fix: parse create_bill_share_token as List for TABLE return`.
  Jangan sertakan trailer `Co-authored-by:`.
