# Project Memory — BagiStruk

- **Updated:** 2026-09-17 11:45
- **Format version:** 1

## Current State

- **2026-09-17:** Share-link web publik (code only, belum commit/apply): copy-link jadi `https://bagistruk.alamaby.com/s/<token>` dirender landing (`ShareBillPage.tsx` + kalkulator + tombol buka-di-aplikasi + noindex); kuota global Free 1 auto-expire / Plus 5 FIFO / downgrade sisa 1 via migration `20260917000000` (untracked di submodule, menunggu operator `db push`); privacy in-app (mask judul, date-only); quota note + dialog + snackbar revoked; `shareLinksEnabled=true`. `flutter analyze` 0e/0w, `flutter test` 666 passed, landing build hijau. Temuan: Riverpod 3 default-retry 10x untuk non-Error → `shareQuotaProvider` di-set fail-fast. Detail: [plan](../plans/2026-09-17-share-link-web-public-plan.md).

- **2026-09-16:** History swipe-to-delete: tombol ikon hapus per-row diganti `Dismissible(endToStart)` + dialog konfirmasi tetap (`_confirmAndDeleteBill`, `_HistorySwipeBackground`); 4 widget test baru. `flutter analyze` 0 error, `flutter test` 649 passed. Verifikasi manual device belum dilakukan.
- Flutter + Supabase split-bill app; capture → OCR (Edge Function → LLM) → review/edit → split → settlement loop.
- Lazy anonymous sign-in; onboarding has a preference slide (language + currency + theme with live preview) and optional promo slide.
- Theme picker unified as bottom sheet (onboarding + Settings); transient preview via `themePreviewProvider`, persisted atomically with language + currency.
- Backend lives in `supabase/` git submodule (`bagistruk-supabase`).
- **2026-09-15:** Maestro E2E debug-APK build fixed: pin `receive_sharing_intent` `^1.9.0` → exact `1.8.1` (1.9.0 butuh AGP 9.2.1 + `compileSdk 37` + Flutter built-in Kotlin ≥3.47; app di AGP 8.11.1/Flutter 3.41.7) + `android/build.gradle.kts` selaraskan `KotlinCompile.jvmTarget` tiap subproject dengan `compileOptions.targetCompatibility` sendiri (perbaiki "Inconsistent JVM-target compatibility" yang JDK-dependent: 21 lokal / 17 CI). Commit `715bacc` GAGAL CI (stray `}` di line 50, build lokal terverifikasi sebelum edit terakhir) → fixed `4e2c6fb`; CI run `34978993486` hijau, `Build debug APK` pass. Lalu `1ae71b6` menutup "hijau palsu": flow E2E ternyata 8/8 gagal (placeholder `.env` + tidak ada state ter-seed) tapi workflow tetap `success` karena `continue-on-error`. Verifikasi lokal: analyze 0 error/0 warning, `flutter test` 645 passed.
- **2026-09-14:** Gemini flash-lite migration: `20260914120000` tambah `gemini-3.5-flash-lite` (default p30) + `gemini-2.5-flash-lite` (default p40), `is_active=false`, key clone dari default p10. Commit `a7ed1ff` + pointer `b1489c5` TER-PUSH; migration TER-APPLY (terverifikasi di remote). Sisa: validasi upstream + aktivasi.
- **2026-09-08:** M4 Power Plus implemented (code only): bill templates/duplikat (migration `20260908120000` + RPC, `BillDuplicator`, detail menu + history row + templates sheet), Plus server retry 1x (`plus_retry.ts` + wiring), Plus in-card retry + scanning status, client 10-photo cap + 413 mapping, 22 ARB keys ID+EN. `flutter test` 612 passed, `deno test` 55 passed, `analyze` 0 errors. BELUM di-commit; migrasi + Edge deploy menunggu operator.
- **2026-09-05:** Onboarding theme picker + preview + review fix; commit `a75fdaf` ter-push; `pubspec 0.30.1+76` (patch bump), `flutter test` 482 passed, `analyze` 0 errors. APK lokal gagal (Gradle `receive_sharing_intent` pre-existing) — build di workflow. **Resolved 2026-09-15** (pin 1.8.1 + Gradle JVM-target fix).
- **2026-09-04:** Legal docs refresh (privacy + terms) — effective date `2026-09-04`; share-to-scan disclosure, HMAC v2 signals, post-confirmation opt-in, ToS §4 shared-images, ID date fix `2026-07-10→2026-09-04`; `pubspec 0.29.1+74`, `legal-compliance-checklist` now tracked. `app_config` bump 1→2 pending operator (post-rollout). `flutter test` 477 passed, `analyze` 0 errors.
- **2026-09-04:** Android share-to-scan (activity-alias "Scan receipt", `receive_sharing_intent` 1.9.0, draft `addSharedFiles` dedup, auto-scan via pending flag). Commits `4a3f538` + `d43cdf4` ter-push, Flutter CI + CodeQL hijau, 477 test passed. Tag `v0.29.0` di-push → Release Android Artifacts sukses (3 APK split-per-ABI + AAB). `PROJECT_SUMMARY.md`/`docs/release-play-store.md` diff dari agen paralel dibiarkan (tidak di-commit).
- **2026-08-31:** Security audit → 2 celah kritis ditutup (REVOKE FROM PUBLIC tidak efektif di Supabase → RPC monetisasi bisa dipanggil langsung; IDOR `migrate_anon_data`). 8 migration hardening (20260830110000–07) TER-APPLY ke remote + 6 migration admin dipulihkan dari remote history; `migration list` sinkron penuh. BELUM di-commit.

## Active Decisions

- **Memory format:** active memory lives in `.memory/`; `PROJECT_MEMORY.md` is a historical archive (read-only) linked below.
- **Onboarding layout:** illustrations are centered vertically via `LayoutBuilder` + `ConstrainedBox(minHeight)` inside `_page()` scroll view.
- **Versioning:** current pubspec version `0.35.0+90` (v0.35.0 tag: share-link web publik).
- **Legal docs (2026-09-04):** effective date bumped to 2026-09-04; HMAC v2 signals enumerated, marketing opt-in post-confirmation clarified, share-to-scan disclosed. `app_config` `legal.terms_version`/`privacy_version` must be bumped 1→2 via Dashboard after app rollout to trigger re-accept (pending operator). Sibling landing-page `legalContent.ts` + public privacy URL + Play Console Data Safety pending manual sync.
- **Ads readiness (2026-09-03):** jangan pernah meng-issue `ad.load()` sebelum `AdService.ready` (dengan timeout); init ads tetap non-blocking di `main()` (insiden launch freeze). Banner failure class harus self-healing (watchdog) + observable (log `BannerAd ... tag=<placement>`).
- **SQL standard baru (2026-08-30):** setiap fungsi public baru wajib `REVOKE ALL ... FROM PUBLIC, anon, authenticated` + GRANT eksplisit; `REVOKE FROM PUBLIC` saja tidak cukup (default privileges Supabase).
- **Event trigger `ensure_rls`** (auto-enable RLS untuk tabel public baru) adalah kontrol defensif yang dijaga — definisinya terkodifikasi di `20260830110007`; jangan di-drop saat cleanup drift.

## Open Items / Blockers

- **Maestro E2E: workflow diperbaiki agar tidak "hijau palsu"** (commit `1ae71b6`, CI run `35030305477` terverifikasi). `continue-on-error: true` dihapus (workflow manual/nightly, bukan required PR check → merah tidak memblokir apa pun); `Create CI environment file` sekarang skip flow kalau secret `E2E_SUPABASE_URL` tidak ada (APK tetap dibangun, jadi step ini tetap berfungsi sebagai build check); kalau secret ada, `.env` ditulis ulang ke satu pasang `SUPABASE_URL`/`SUPABASE_ANON_KEY` yang benar lalu flow dijalankan sungguhan. Ditambah summary `always()` + upload artifact `if: failure()`. **JANGAN pakai project produksi** untuk `E2E_*` — flow memutasi preferensi & membuat user anonim (lihat `plans/2026-07-24-p2-testing-maintainability-plan.md:50,70`); sampai backend test ter-seed ada, flow di-SKIP (bukan merah, bukan hijau palsu). Detail: [plan](../plans/2026-09-15-maestro-apk-receive-sharing-intent-fix.md).
- Follow-up plan migrasi penuh AGP 9 (Flutter ≥3.47, AGP 9.2.1, Kotlin 2.4.0, `compileSdk 37`, `builtInKotlin=true`, iOS SPM) diperlukan sebelum bump `receive_sharing_intent` ≥1.9.0. Detail: [plan](../plans/2026-09-15-maestro-apk-receive-sharing-intent-fix.md).
- Operator bump `app_config` `legal.terms_version`/`privacy_version` 1→2 via Supabase Dashboard setelah rilis `0.29.1+74` (MCP read-only; jangan bump sebelum rollout karena aset markdown ter-bundle). Detail: [plan](../plans/2026-09-04-legal-docs-refresh-plan.md).
- Manual sync: `bagistruk-landing-page/src/legalContent.ts`, public privacy URL (host `docs/privacy-policy.md`), Play Console Data Safety check (tidak ada tipe data baru, hanya jalur foto baru via share intent).
- Manual device verification for share-to-scan (adb SEND/SEND_MULTIPLE, cold/warm, gates) + `flutter build apk --split-per-abi`. Commits ter-push (`4a3f538`, `d43cdf4`) — `PROJECT_SUMMARY.md`/`docs/release-play-store.md` working-tree diff dari agen paralel belum di-commit, sengaja dibiarkan.
- Commit submodule (8 hardening + 6 file admin pemulihan) + pointer di repo utama; advisor re-run + regression runtime. Detail: [plan](../plans/2026-08-30-security-remediation-plan.md) & entry 2026-08-30 di bawah.
- Verifikasi lapangan fix scan banner ad di device user lama (cold start → banner scan terload / pulih via watchdog). Commit `7995f24` sudah di-push. Detail: [plan](../plans/2026-09-03-scan-banner-ad-rca-fix.md).
- **Pre-existing test failure (date-rot):** `history_screen_test.dart` "previous month navigates; next is disabled at current month" hardcode "Pengeluaran Agustus 2026" (ditulis 2026-08-30) — gagal mulai September 2026. Perbaikan terpisah.
- `PROJECT_MEMORY.md` has a duplicate `## 2026-08-04` entry and is untracked — clean up when committing.

## Archive (Legacy)

- [PROJECT_MEMORY.md](../PROJECT_MEMORY.md) — full historical per-change log (kept at original location).

## Recent Entries

- [2026-09-17/release-v0-35-0.md](2026-09-17/114500-release-v0-35-0.md)
- [2026-09-17/share-link-web-public.md](2026-09-17/102000-share-link-web-public.md)
- [2026-09-16/landing-preline-revamp-plan.md](2026-09-16/222200-landing-preline-revamp-plan.md)
- [2026-09-16/history-swipe-to-delete.md](2026-09-16/191500-history-swipe-to-delete.md)
- [2026-09-15/maestro-apk-receive-sharing-intent-fix.md](2026-09-15/163500-maestro-apk-receive-sharing-intent-fix.md)
- [2026-09-15/history-pagination-info-label.md](2026-09-15/150000-history-pagination-info-label.md)
- [2026-09-15/llm-schema-mismatch-validator-fix.md](2026-09-15/154500-llm-schema-mismatch-validator-fix.md)
- [2026-09-14/gemini-flash-lite-models.md](2026-09-14/120000-gemini-flash-lite-models.md)
- [2026-09-08/m4-power-plus-implementation.md](2026-09-08/073000-m4-power-plus-implementation.md)- [2026-09-05/onboarding-theme-review-fix-commit.md](2026-09-05/101500-onboarding-theme-review-fix-commit.md)
- [2026-09-05/onboarding-theme-picker-preview.md](2026-09-05/083000-onboarding-theme-picker-preview.md)
- [2026-09-04/legal-docs-refresh.md](2026-09-04/135559-legal-docs-refresh.md)
- [2026-09-04/android-share-to-scan-receipt.md](2026-09-04/120000-android-share-to-scan-receipt.md)
- [2026-09-03/scan-banner-ad-silent-drop-fix.md](2026-09-03/140500-scan-banner-ad-silent-drop-fix.md)
- [2026-08-30/security-audit-supabase-rpc-hardening.md](2026-08-30/122000-security-audit-supabase-rpc-hardening.md)
- [2026-08-12/onboarding-image-centering.md](2026-08-12/onboarding-image-centering.md)
