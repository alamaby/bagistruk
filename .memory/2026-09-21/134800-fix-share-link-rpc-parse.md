# Fix copy share link RPC parse crash (`List<dynamic>` vs `Map`)

Date: 2026-09-21 13:48 WIB
Status: Code done, smoke manual pending operator

## Objective

Perbaiki crash `copy share link` di `bill_detail_screen` emulator: `type 'List<dynamic>' is not a subtype of type 'Map<dynamic, dynamic>'` saat `BillShareLink.createAndCopy` memanggil RPC `create_bill_share_token`.

## Root Cause

`create_bill_share_token` adalah fungsi Postgres `RETURNS TABLE (token_id UUID, expires_at TIMESTAMPTZ, revoked_count INT)`. PostgREST selalu mengembalikan fungsi `TABLE` sebagai JSON **array** `[{"col1":...}]`, bukan single object. Kode produksi salah menggunakan `rpc<Map<String, dynamic>>` sehingga `PostgrestBuilder._parseResponse` mencoba cast `List → Map` dan crash.

## Changes

### Production (1 file)
- `lib/data/datasources/bill_remote_datasource.dart`:
  - `createShareToken`: ubah generic dari `rpc<Map<String, dynamic>>` ke `rpc<List<dynamic>>` (line ~299), hapus baris dead code `(rows as List?)`. Signature, nama RPC, nama params, dan pesan `FormatException` tidak berubah.

### Tests (1 file baru)
- `test/data/datasources/bill_remote_datasource_share_token_test.dart`:
  - 3 regression test yang memanggil `ds.createShareToken` asli via `FakeSupabaseClient` (fake manual, alternatif yang diizinkan plan):
    1. TABLE shape List 3 kolom → Map row pertama (+ assert nama RPC & params)
    2. List kosong → FormatException dengan pesan `empty create response`
    3. Server lama 2 kolom (tanpa `revoked_count`) tetap parse

## Verification

- `flutter analyze` lib + test: 0 error, 0 warning (hanya pre-existing info-level)
- `flutter analyze --no-fatal-infos` penuh: 163 info pre-existing, 0 error/warning (gate CI)
- `dart run build_runner build --delete-conflicting-outputs`: fresh, tidak ada diff generated
- `flutter test test/data/datasources/bill_remote_datasource_share_token_test.dart`: 3/3 hijau
- `flutter test test/presentation/bills/providers/bill_share_link_notifier_test.dart test/data/datasources/bill_remote_datasource_auth_test.dart`: 22/22 hijau (test lama tidak diubah)
- `flutter test` penuh: 673/673 hijau

## Pending

- Smoke manual di emulator: tap "Salin link" → verify snackbar sukses + clipboard berisi `https://bagistruk.alamaby.com/s/<token>` + logcat tidak ada `List<dynamic> is not Map`.

## Commit proposal

`fix: parse create_bill_share_token as List for TABLE return`

## Notes

- Tidak menyentuh: migration, repository, notifier, screen, quota, resolve, `pubspec.yaml` (versi sudah di-bump di commit sebelumnya bila diminta eksplisit). Satu PR = satu bug.
- `MockSupabaseClient` hasil `@GenerateMocks` tidak bisa mensub `rpc<T>` karena return type-nya `PostgrestFilterBuilder<T>` (yang juga `implements Future<T>`): `thenAnswer((_) async => [...])` gagal cast `Future as PostgrestFilterBuilder` di kode mock generated. Dipakai `FakeSupabaseClient` manual sesuai alternatif plan.
