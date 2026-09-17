# Share-Link Web Publik (/s/:token) + Kuota Global + Peringatan In-App

Created: 2026-09-17 00:00:00

## Objective

Copy-link menghasilkan URL https yang bisa dibuka siapa pun di browser (tanpa install aplikasi) via sibling repo `bagistruk-landing-page` (`/s/<token>`), aktif 7 hari, berisi detail pembagian split item tanpa nomor HP, tanggal date-only tanpa jam, dan judul termasking sebagian. Plus: tombol "Buka di aplikasi", kuota global (Free 1 link auto-expire, Plus 5 link FIFO + 1 tersisa saat entitlement habis), dan peringatan in-app sebelum link lama dimatikan.

## Scope

- `supabase/` (submodule bagistruk-supabase): 1 migration baru — rewrite `create_bill_share_token` (kuota global, FIFO, lock), trigger downgrade `user_entitlements`, guard plan di `resolve_share_token`, RPC `my_share_token_quota()`, `revoked_count` di return create.
- Flutter app: base URL https `/s/`, `DeepLinkHandler` kenal URL https, `SharedBillScreen` privacy (mask judul, date-only), `shareQuotaProvider` + dialog peringatan + snackbar `revoked_count`, ARB ID+EN baru, update test.
- Landing page: route `/s/:token` + `/id/s/:token`, `ShareBillPage.tsx` (anon `rpc resolve_share_token`), port `BillCalculator`, tombol "Buka di aplikasi" + fallback Play Store, `noindex`, strings ID+EN.
- Tidak termasuk: Android App Links / iOS Universal Links (tetap custom-scheme button), Edge Function proxy (fase lanjut bila perlu rate-limit resolve).

## Milestones

1. DB migration ditulis (apply + deploy menunggu operator — MCP read-only).
2. App selesai + `flutter analyze` 0 error + test share-link hijau.
3. Landing selesai + `npm run build` hijau + uji manual token asli.
4. Memory entry + sync docs/legal bila perlu.

## Tasks

- [x] DB: migration `20260917000000_share_token_global_quota` (create rewrite, quota RPC, downgrade trigger, resolve guard)
- [x] App: `AppConstants.shareBaseUrl` kanonis `https://bagistruk.alamaby.com/s/`, link https di create/copy/share-text
- [x] App: `DeepLinkHandler.parseShareToken` terima `https://bagistruk.alamaby.com/s/<token>`
- [x] App: `SharedBillScreen` — mask judul (4 char + `•••`), tanggal date-only dari `receipt_date` saja, tanpa `created_at`/`image_url`
- [x] App: `shareQuotaProvider` + datasource/repo `getShareQuota()` + parse `revoked_count`
- [x] App: quota note permanen + dialog Free/Plus + snackbar revoked di `_ShareLinkSection`
- [x] App: ARB ID+EN baru + `flutter pub get` (gen-l10n)
- [x] App: update test limit lama + test baru (quota, dialog matrix, revoked_count, https parse, masking)
- [x] Landing: route `/s/:token`, `ShareBillPage.tsx`, port kalkulator, tombol buka-di-aplikasi + fallback, noindex, strings
- [x] Verifikasi: analyze 0 error/0 warning, `flutter test` 666 passed, landing `vite build` + `tsc` (1 error pra-eksis Waitlist)
- [x] Review vs plan: F1 alive-bill predicate di semua active-set migration + revoked_count aktual (GET DIAGNOSTICS); F2 snackbar `shareLinkRotated` + test rotate; F3 unit test `ShareQuota.fromJson`; F4 koreksi komentar migration; F5 kembalikan churn `dart format` tak terkait agar diff minimal
- [ ] Operator: commit+push migration di submodule + `supabase db push` + advisor re-run (MCP read-only)
- [ ] Operator: uji manual matriks (Free/Plus × kuota × downgrade, browser incognito, buka-di-aplikasi Android/iOS)
- [ ] Memory entry + update `.memory/README.md`

## Risks

- Kuota global mematikan link antar-bill — user Free bisa kaget ("link bill A mati sendiri"). Mitigasi: dialog + note permanen + copywriting eksplisit.
- Masking judul client-side bukan privasi penuh (judul asli tetap lewat kabel). `resolve_share_token` tetap kirim judul penuh; RPC v2 server-side masking ditunda ke fase lanjut.
- Race dua create paralel → dikunci via `FOR UPDATE` baris aktif caller + advisory xact lock.
- `shareLinksEnabled=false` masih mematikan section — dibuka bersamaan dengan fitur ini.
- Downgrade tanpa aksi user hanya tertutup via trigger + resolve guard; sweep pg_cron opsional (cek ketersediaan).
- iOS `APP_STORE_URL` landing masih kosong — fallback tombol buka-di-aplikasi di iOS = section unduh generik.

## Progress Log

- 2026-09-17 — Plan dibuat dari sesi analisa 2026-09-16/17 (URL /s/, browser-dulu, tanggal tanpa jam, tempat disamarkan, tombol buka-di-aplikasi, kuota Free 1 / Plus 5 FIFO, entitlement habis sisa 1, peringatan in-app). Mulai implementasi dari DB.
- 2026-09-17 — Implementasi selesai semua (kode saja, belum commit/apply): migration global-quota di submodule (untracked, menunggu operator), app (link https, privacy screen, quota+dialog, ARB), landing (`/s/:token` + kalkulator + buka-di-aplikasi). Verifikasi: analyze 0e/0w, test 666 passed, landing build hijau. Temuan penting: Riverpod 3 default-retry 10x untuk non-Error → `shareQuotaProvider` di-set `retry: (_, _) => null` (fail-fast). Sisa operator: submodule commit/push + db push + uji manual device.
- 2026-09-17 — Review vs plan selesai. Temuan in-scope yang diperbaiki: (F1 High) token bill-terhapus ikut dihitung aktif → guard downgrade bisa memilih token mati sebagai "terbaru" sehingga semua link hidup tak resolvable — predikat alive-bill di 5 titik + revoked_count aktual; (F2) snackbar rotate generik → `shareLinkRotated` + test; (F3) `ShareQuota.fromJson` belum dites; (F4) komentar migration; (F5) churn format tak terkait dikembalikan. Verifikasi ulang: analyze 0e/0w, test 670 passed, landing build + tsc (hanya error pra-eksis). Gugur: SELECT-INTO guard (PK tunggal), advisory-lock cast, `.future` hang (mekanisme retry, sudah fail-fast). Out-of-scope (dicatat, tak diubah): diff PROJECT_SUMMARY.md pra-eksis, rewrite vercel.json pra-eksis, error tsc Waitlist, sweep pg_cron, RPC-v2 masking, App Store URL kosong. Lokal Dart 3.11.5 == pin CI → codegen byte-identical.

## Notes

- Standar domain: TOGAF proporsional (fitur kecil — cukup view implementasi + risiko, tanpa ceremony ADM penuh). Deviasi dari Oracle C2M/TMF ODA tidak relevan (bukan proyek telecom).
- Token tetap 32-hex (`uuid` tanpa strip) → SHA-256 64-hex; link lama `bagistruk://share/` tetap valid (back-compat).
- `resolve_share_token` sudah `GRANT ... TO anon` — landing bisa panggil langsung tanpa backend baru.
- Masking judul usulan: 4 karakter pertama + `•••` (mis. "Kopi Kenangan Senayan" → "Kopi•••"). Aturan final bisa diubah satu fungsi.
