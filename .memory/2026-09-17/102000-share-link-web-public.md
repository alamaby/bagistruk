# Share-Link Web Publik + Kuota Global + Peringatan In-App

- **Task:** Enhance fitur share-link: copy-link menghasilkan URL https `/s/<token>` yang
  dirender sibling `bagistruk-landing-page` tanpa install aplikasi (aktif 7 hari, tanpa
  HP, tanggal date-only, judul termasking) + tombol "Buka di aplikasi" + kuota global
  (Free 1 auto-expire, Plus 5 FIFO, entitlement habis sisa 1) + peringatan in-app.
- **Key files:**
  - `supabase/migrations/20260917000000_share_token_global_quota.sql` (baru, untracked di
    submodule — rewrite create + `my_share_token_quota()` + trigger downgrade + resolve guard)
  - `lib/core/config/app_constants.dart` (`shareBaseUrl`, `shareHost`, website kanonis,
    `shareLinksEnabled=true`), `lib/core/billing/share_link_token.dart`
    (`webLink`/`appLink`/`maskPlaceName`), `lib/data/services/deep_link_handler.dart`
    (parse https `/s/`), `lib/presentation/bills/screens/shared_bill_screen.dart` (privacy),
    `lib/presentation/bills/providers/bill_share_link_notifier.dart`
    (`revokedCount`, `shareQuotaProvider` + `retry: (_, _) => null`),
    `lib/presentation/bills/screens/bill_detail_screen.dart` (quota note + dialog + snackbar),
    `lib/l10n/app_{id,en}.arb` (12 key baru), data layer quota (`getShareQuota`)
  - Landing: `src/components/ShareBillPage.tsx` (baru), `src/App.tsx` (route `/s/`,
    canonical, noindex), `src/utils/analytics.ts` (`share` page)
  - Test: rewrite `bill_detail_share_link_test.dart` (kill-switch hidden → visible+dialog
    matrix), tambah quota/revoked/https/masking tests; selaraskan `shared_bill_screen_test.dart`
- **Decisions:**
  - Kuota dihitung global per user (bukan per bill); Free auto-revoke (bukan error);
    Plus FIFO + invariant 1-aktif-per-bill dipertahankan; downgrade 3 lapis
    (lazy-create + trigger + resolve-guard).
  - Masking judul client-side (4 char + `•••`); privasi server-side penuh (RPC v2)
    ditunda fase lanjut — dicatat sebagai risiko di plan.
  - `shareQuotaProvider` fail-fast (`retry: (_, _) => null`) — quota advisory.
  - Tombol buka-di-aplikasi = custom-scheme + fallback timer Play Store (tanpa App Links).
- **Assumptions/risks:** masking client-side tetap kirim judul penuh via kabel; kuota
  global bisa mematikan link antar-bill (dikomunikasikan via dialog+note); `tsc` landing
  1 error pra-eksis (Waitlist); migration BELUM di-apply (MCP read-only) + BELUM commit.
- **Blockers:** operator perlu: commit+push migration di submodule + `supabase db push` +
  advisor re-run + uji manual device (Free/Plus × kuota × downgrade, incognito, app-button).
- **Verification:** `flutter analyze` 0 error/0 warning; `flutter test` 670 passed;
  landing `vite build` hijau; `dart format` hanya untuk baris baru (churn tak terkait
  dikembalikan agar diff minimal).
- **Apply produksi (2026-09-17):** migration TER-APPLY via MCP (CLI tanpa token).
  Insiden: payload pertama korup di transit (blok items ganda di resolve) → terdeteksi
  via read-back `prosrc` → corrective re-apply → verified (4 fungsi sesuai file, trigger
  aktif, grants benar, EXPLAIN valid, advisor tanpa temuan baru). File disk tak berubah.
- **Push:** submodule `4d53566` branch `feat/share-token-global-quota` (PR belum dibuat);
  parent `ee8352d` + pointer `34b0c63` ke main; landing `4ffcb00` ke main.
  Sisa: uji manual matriks + merge PR submodule bila alur tim menghendaki.
- **Review (2026-09-17):** F1 token bill-terhapus dikecualikan dari semua active-set
  (guard downgrade bisa buta bila newest menunjuk bill terhapus) + revoked aktual;
  F2 snackbar `shareLinkRotated` + test rotate; F3 unit test `ShareQuota.fromJson`;
  lokal Dart 3.11.5 == pin CI sehingga codegen byte-identical.
- **Commit proposal:** `feat: public https share links with global quota and in-app warnings`
- **Plan:** [plans/2026-09-17-share-link-web-public-plan.md](../plans/2026-09-17-share-link-web-public-plan.md)
