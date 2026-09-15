# Info Pagination di Layar History

Created: 2026-09-15 00:00:00 UTC

## Objective

Tampilkan informasi pagination di layar History dengan format **X/Y + status selesai**, di **atas daftar**, memakai **total jendela** (`summary.totalBillCount`). Contoh akhir (ID):

- Masih ada halaman: `Menampilkan 25 dari 60 bill`
- Semua termuat: `Menampilkan 60 dari 60 bill · Semua ditampilkan`

Keputusan user yang sudah final: format X/Y + selesai, posisi atas daftar, akurasi cukup total jendela (tanpa migrasi DB).

## Scope

- In-scope:
  - `lib/presentation/history/screens/history_screen.dart` (kondisi tampil + widget label).
  - `lib/l10n/app_id.arb` + `lib/l10n/app_en.arb` (2 key baru) + regen `lib/l10n/generated/` via `flutter pub get`.
  - `test/presentation/history/screens/history_screen_test.dart` (widget test baru).
  - (Opsional, aturan repo) bump minor `pubspec.yaml` karena ini fitur.
- Out-of-scope:
  - Migrasi DB / extend RPC `get_history_page_summary` agar total akurat penuh (sengaja ditolak — lihat Notes).
  - Footer bawah daftar, nomor halaman ala `Halaman A/B` (tidak cocok dengan cursor-based pagination).
  - Perubahan `HistoryListNotifier`, datasource, DTO, atau kontrak RPC.

## Milestones

1. L10n: 2 key baru ID+EN + regen berjalan, tidak ada key duplikat.
2. UI: label tampil selalu saat daftar ada isi, teks + sufiks benar di semua state.
3. Test: widget test baru hijau + tidak ada regresi (`history` suite + full suite).
4. Rilis: plan file dicentang + (opsional) bump versi minor.

## Tasks

- [x] T1 — Tambah 2 key ARB (ID + EN)
- [x] T2 — Regen l10n (`flutter pub get`)
- [x] T3 — Ubah `history_screen.dart`: kondisi tampil + widget `_PaginationInfoLabel`
- [x] T4 — Tambah widget test pagination di `history_screen_test.dart`
- [x] T5 — Verifikasi: `analyze` 0 error, 7 pagination test baru hijau, history suite 98/98 hijau, full suite 642/642 hijau, `dart format` clean
- [x] T6 — bump minor `pubspec.yaml` `0.32.6+86` → `0.33.0+87`

### T1 — Tambah 2 key ARB (detail)

File: `lib/l10n/app_id.arb` dan `lib/l10n/app_en.arb`. Letakkan berdekatan dengan `historyFilterCount` (ID baris ±558, EN baris ±558) agar mudah ditemukan.

ID (`app_id.arb`), tambah persis:

```json
"historyPaginationShowing": "Menampilkan {shown} dari {total} bill",
"@historyPaginationShowing": {
  "placeholders": {
    "shown": { "type": "int" },
    "total": { "type": "int" }
  }
},
"historyPaginationAllShown": "Semua ditampilkan",
```

EN (`app_en.arb`), tambah persis:

```json
"historyPaginationShowing": "Showing {shown} of {total} bills",
"@historyPaginationShowing": {
  "placeholders": {
    "shown": { "type": "int" },
    "total": { "type": "int" }
  }
},
"historyPaginationAllShown": "All shown",
```

Aturan:

- JANGAN ubah/hapus key lama `historyFilterCount` — key itu dipakai ulang untuk kasus filter aktif (lihat T3) dan test lama bergantung padanya.
- Separator `·` TIDAK masuk ARB; digabung di widget (`'$base · $suffix'`) agar translator tidak perlu menangani tanda baca.
- Validasi JSON: koma benar, tidak ada trailing comma, placeholder `int` sesuai pemakaian (`items.length`, `totalBillCount`).

### T2 — Regen l10n

```bash
flutter pub get
```

- Per `CLAUDE.md`, `pub get` otomatis menjalankan `gen-l10n` (ARB → `lib/l10n/generated/app_l10n.dart`).
- JANGAN edit file di `lib/l10n/generated/` manual.
- Verifikasi: `lib/l10n/generated/app_l10n.dart` mengandung `historyPaginationShowing` dan `historyPaginationAllShown`; cek juga `app_l10n_id.dart` / `app_l10n_en.dart` ter-regen.
- Jika regen gagal (mis. JSON rusak), perbaiki ARB dulu, jangan lanjut ke T3.

### T3 — Ubah `history_screen.dart` (detail)

Konteks kode saat ini (jangan mengandalkan nomor baris secara buta — cari stringnya):

1. Slot label lama, sekitar baris 358-364:

```dart
if (filter.hasActiveFilters && hasItems)
  SliverToBoxAdapter(
    child: _FilteredCountLabel(
      filteredCount: items.length,
      totalCount: summary?.totalBillCount ?? items.length,
    ),
  ),
```

2. Widget lama `_FilteredCountLabel`, sekitar baris 675-696, memakai `l10n.historyFilterCount(filteredCount, totalCount)` dengan style `TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant)` dan padding `EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0)`.

Ganti slot menjadi (nama/param persis agar test T4 cocok):

```dart
if (hasItems)
  SliverToBoxAdapter(
    child: _PaginationInfoLabel(
      shown: items.length,
      total: summary?.totalBillCount ?? items.length,
      hasMore: historyState.hasMore,
      isLoadingMore: historyState.isLoadingMore,
      loadMoreFailed: historyState.loadMoreFailure != null,
      filtered: filter.hasActiveFilters,
    ),
  ),
```

Ganti `_FilteredCountLabel` dengan widget baru (letakkan di lokasi yang sama, hapus class lama agar tidak ada dead code):

```dart
class _PaginationInfoLabel extends StatelessWidget {
  const _PaginationInfoLabel({
    required this.shown,
    required this.total,
    required this.hasMore,
    required this.isLoadingMore,
    required this.loadMoreFailed,
    required this.filtered,
  });

  final int shown;
  final int total;
  final bool hasMore;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final bool filtered;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final scheme = Theme.of(context).colorScheme;
    // Anti-aneh saat summary stale (mis. transient setelah delete):
    // total tidak boleh lebih kecil dari yang sedang tampil.
    final effectiveTotal = total < shown ? shown : total;
    final base = filtered
        ? l10n.historyFilterCount(shown, effectiveTotal)
        : l10n.historyPaginationShowing(shown, effectiveTotal);
    final allShown = !hasMore && !isLoadingMore && !loadMoreFailed;
    final text = allShown ? '$base · ${l10n.historyPaginationAllShown}' : base;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant),
      ),
    );
  }
}
```

Aturan perilaku (wajib):

- `filtered=true` → basis teks TETAP `historyFilterCount` (contoh ID: `2 dari 60 bill`). `filtered=false` → key baru (contoh ID: `Menampilkan 2 dari 60 bill`).
- Sufiks `· Semua ditampilkan` / `· All shown` HANYA jika `!hasMore && !isLoadingMore && !loadMoreFailed`. Saat `isLoadingMore=true`, sufiks disembunyikan walau `hasMore=false` (hindari klaim selesai saat spinner masih jalan).
- `summary==null` → fallback `total = items.length` (dari call site), sehingga label menjadi `Menampilkan X dari X` + sufiks ikut `hasMore`. Aman.
- Style/padding SAMA dengan label lama — tidak boleh menggeser layout (tetap `12.sp`, `onSurfaceVariant`, padding `16.w/4.h/16.w/0`).
- Tidak ada perubahan pada `HistoryListNotifier`, limit 25, atau logika cursor.

### T4 — Widget test (detail)

File: `test/presentation/history/screens/history_screen_test.dart`.

Konteks yang perlu diketahui small model:

- Helper `buildApp` di file ini (baris ±57-83) saat ini TIDAK meng-override `historyFilterProvider`. Tambahkan param opsional `HistoryFilterState? filterState` dan override `historyFilterProvider.overrideWithValue(filterState)` bila non-null (import sudah ada: `history_filter_notifier.dart` + `history_filter_state.dart`).
- Fixture `_nonEmptyHistoryState` (baris ±33-36) punya `summary` tapi `items` KOSONG → `hasItems=false` → label tidak tampil. Untuk test pagination WAJIB buat state dengan `items` terisi. Contoh helper (tambahkan di group baru, import `HistoryBill` dari `package:bagistruk/domain/entities/history_bill.dart`):

```dart
HistoryBill paginationBill(String id) => HistoryBill(
  id: id,
  title: 'Bill $id',
  totalAmount: 10000,
  currencyCode: 'IDR',
  participantCount: 1,
  paidParticipantCount: 0,
  paymentStatus: BillPaymentStatus.unpaid,
  createdAt: DateTime.utc(2026, 9, 1),
);
```

- Untuk tampilnya daftar, `creditStatus` harus yang punya akses history (pakai `freeStatus` yang sudah ada di file) dan `summary.totalBillCount > 0`.
- Buat group baru `group('HistoryScreen pagination info', ...)` berisi minimal 5 test:
  1. Tanpa filter + `hasMore=true` → tampil `Menampilkan 2 dari 60 bill`, TIDAK ada sufiks. State: `items: [paginationBill('1'), paginationBill('2')]`, `summary: totalBillCount 60`, `hasMore: true`.
  2. Tanpa filter + `hasMore=false` → tampil `Menampilkan 3 dari 3 bill · Semua ditampilkan`. State: 3 items, `summary: totalBillCount 3`, `hasMore: false`, `isLoadingMore: false`.
  3. Tanpa filter + `hasMore=false` tapi `isLoadingMore=true` → sufiks DISEMBUNYIKAN (hanya base text).
  4. Dengan filter aktif (`filterState: const HistoryFilterState(query: 'kopi')`) → tampil format lama `2 dari 60 bill` (via `historyFilterCount`), bukan `Menampilkan...`.
  5. Tidak tampil saat: `isLoadingInitial=true` / `items` kosong / `initialFailure != null`.
  6. (Disarankan) EN locale: `Showing 2 of 60 bills` dan sufiks `All shown`.
- Pola pump mengikuti test lama: `pumpWidget` → `pump()` → `pump(Duration(milliseconds: 100))`, lalu `expect(find.text(...), findsOneWidget)`. Akhiri tiap widget test dengan `await tester.pumpWidget(const SizedBox.shrink());` seperti test carousel (melepas timer PageView `_SummaryCards`).
- JANGAN ubah test lama kecuali kompilasi rusak akibat rename (seharusnya tidak — tidak ada test lama yang merujuk `_FilteredCountLabel` langsung).

### T5 — Verifikasi (perintah persis)

Jalankan berurutan, semua harus hijau:

```bash
flutter analyze
flutter test test/presentation/history/screens/history_screen_test.dart
flutter test test/presentation/history/
flutter test
```

Plus:

```bash
dart format lib/presentation/history/screens/history_screen.dart test/presentation/history/screens/history_screen_test.dart
```

- `flutter analyze`: 0 error (info baseline boleh ada).
- Jika full `flutter test` ada 1 fail date-rot lama (`history_screen_test.dart` "previous month navigates..." — hardcode Agustus 2026, lihat `.memory/README.md`), catat sebagai pre-existing, JANGAN diperbaiki di scope ini kecuali trivial dan terpisah commit.

### T6 — Versi + tutup plan (opsional tapi disarankan)

- Aturan repo (`AGENTS.md` §4): fitur → bump **minor** `pubspec.yaml` (+1), reset patch ke 0, bump build number +1.
- Update file plan ini: centang `Tasks` yang selesai, tambah baris `Progress Log` tertanggal.

## Risks

- **Total tetap total jendela saat filter status/mata uang aktif.** `get_history_page_summary` hanya menerima `p_created_after/p_query/p_category` (migrasi `supabase/migrations/20260907120000_m3_categories_search_trash.sql:240-329`, client `bill_remote_datasource.dart:191-207`). Filter `paymentStatus/currencyCode` tidak ikut total. Ini flaw bawaan `_FilteredCountLabel` lama, BUKAN regresi — tapi kini lebih terlihat karena label selalu tampil. Counter-measure: teks tidak mengklaim "dari hasil filter"; opsi akurat penuh (extend RPC + migrasi + grant ulang) sengaja ditolak user. Jika nanti dibutuhkan, buat plan lanjutan (Opsi B).
- **Edge `shown > total`** (transient setelah delete/duplikat saat summary stale). Ditangani via `effectiveTotal = max(total, shown)` di widget — tidak pernah tampil `25 dari 20`.
- **`summary==null`** → fallback `total = shown`; label menjadi `X dari X`. Bukan bug, hanya state loading awal.
- **Nomor baris bisa bergeser** (file 2556 baris, referensi baris dari riset 2026-09-15). Selalu cari via string (`_FilteredCountLabel`, `filter.hasActiveFilters && hasItems`, `historyFilterCount`) bukan mengandalkan nomor baris buta.
- **Small-model trap: godaan ubah notifier/RPC untuk "memperbaiki" total.** DILARANG di scope ini — UI + l10n + test saja.
- **Small-model trap: edit file generated** (`*.g.dart`, `*.freezed.dart`, `lib/l10n/generated/*`). DILARANG — regen via `flutter pub get` saja.
- Counter-argument desain: alternatif "satu format baru untuk semua kasus" ditolak agar string + test lama (`historyFilterCount`) tidak rusak; unifikasi penuh bisa dilakukan nanti dalam satu commit l10n terpisah.

## Progress Log

- 2026-09-15 00:00:00 UTC — Plan detail ditulis (riset: `history_list_notifier.dart`, `bill_remote_datasource.dart:140-207`, DTO, migrasi summary `20260907120000:235-333`, ARB ID/EN `historyFilterCount`, slot sliver `history_screen.dart:358-364` + `_FilteredCountLabel:675-696`, fixture test). Keputusan user: format X/Y + selesai, posisi atas, total jendela cukup.
- 2026-09-15 — Eksekusi (build mode). T1: 2 key ARB ID+EN ditambah (di samping `historyFilterCount`; separator `·` dan sufiks di widget, bukan ARB). T2: `flutter pub get` regen — generated mengandung `historyPaginationShowing`/`historyPaginationAllShown`. T3: slot sliver ganti `filter.hasActiveFilters && hasItems` → `hasItems`, `_FilteredCountLabel` diganti `_PaginationInfoLabel` (prop: `shown`, `total`, `hasMore`, `isLoadingMore`, `loadMoreFailed`, `filtered`; filter pakai `historyFilterCount`, non-filter pakai `historyPaginationShowing`; sufiks `· Semua ditampilkan` hanya `!hasMore && !isLoadingMore && !loadMoreFailed`; clamp `total`). T4: grup `HistoryScreen pagination info` 7 test (hasMore, suffix selesai, hide suffix loading-more, filter pakai format lama, hidden saat empty/loading, EN + EN suffix). T5: `flutter analyze` 0 error (hanya info baseline); pagination 7/7 hijau; history suite 98/98; full suite 642/642 `All tests passed`; `dart format` clean. T6: `pubspec.yaml` bumped `0.32.6+86` → `0.33.0+87`.

## Notes

- Referensi pagination saat ini: cursor-based, `limit: 25` hardcoded (`history_list_notifier.dart:204-217`), trik `limit+1` untuk `hasMore` (`bill_remote_datasource.dart:168-182`). Tidak ada konsep nomor halaman — maka format `Halaman A/B` tidak valid untuk fitur ini.
- Tidak ada perubahan standar arsitektur/DB; murni presentasi + l10n. Tidak perlu menyebut Oracle C2M / TM Forum / TOGAF di implementasi.
- Aturan repo yang berlaku saat eksekusi: Conventional Commits satu baris; `avoid_print` (pakai `package:logger`, bukan `print`); strict-casts/inference; JANGAN re-add `custom_lint`/`riverpod_lint`; `supabase/` adalah submodule — JANGAN disentuh di task ini.
- Setelah eksekusi, jaga file ini sebagai single source of truth (aturan `AGENTS.md` §7): centang Tasks + tambah Progress Log, satu file satu plan.
