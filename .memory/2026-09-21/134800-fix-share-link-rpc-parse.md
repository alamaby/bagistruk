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
  - `createShareToken`: ubah generic dari `rpc<Map<String, dynamic>>` ke `rpc<List<dynamic>>` (line ~291).
  - Tambah method statis `parseShareTokenResponse(List<dynamic> rows)` agar parsing bisa di-test tanpa mock PostgREST builder.

### Tests (1 file baru)
- `test/data/datasources/bill_remote_datasource_share_token_test.dart`:
  - 3 regression test untuk `parseShareTokenResponse`:
    1. TABLE shape List 3 kolom → Map row pertama
    2. List kosong → FormatException
    3. Server lama 2 kolom (tanpa `revoked_count`) tetap parse

## Verification

- `flutter analyze` lib + test: 0 error, 0 warning baru (hanya pre-existing info-level)
- `flutter test test/data/datasources/bill_remote_datasource_share_token_test.dart`: 3/3 hijau
- `flutter test test/presentation/bills/providers/bill_share_link_notifier_test.dart`: 18/18 hijau
- `flutter test test/data/datasources/`: 7/7 hijau (auth + share token)
- Full suite `flutter test` timeout di `shared_bill_test.dart` (socket timeout, flaky, unrelated)

## Pending

- Smoke manual di emulator: tap "Salin link" → verify snackbar sukses + clipboard berisi `https://bagistruk.alamaby.com/s/<token>` + logcat tidak ada `List<dynamic> is not Map`.

## Commit proposal

`fix: parse create_bill_share_token as List for TABLE return`

## Notes

- Tidak menyentuh: migration, repository, notifier, screen, quota, resolve. Satu PR = satu bug.
- `parseShareTokenResponse` dibuat statis agar bisa di-test tanpa mock PostgREST builder (generic `rpc<T>` sulit di-stub dengan mockito karena `PostgrestFilterBuilder` punya banyak method).
