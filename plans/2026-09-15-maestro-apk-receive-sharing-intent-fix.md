# Fix Maestro Android E2E `assembleDebug` Failure (receive_sharing_intent)

Created: 2026-09-15 16:35:00

## Objective

Unblock the `Maestro Android E2E` workflow step `Build debug APK` (`flutter build apk --debug`), which failed evaluating project `:receive_sharing_intent` with `Could not find method kotlin()` at `build.gradle` line 53.

Result: `Build debug APK` is fixed and CI-verified. The Maestro flows themselves still fail 8/8 for an unrelated pre-existing reason (placeholder backend credentials), which the workflow masks as success — tracked below as a follow-up, not part of this fix.

## Scope

- In: `pubspec.yaml` dependency pin, `pubspec.lock` regen, `android/build.gradle.kts` Kotlin/JVM target alignment, local verification (APK build + analyze + tests), Maestro re-run.
- Out: full AGP 9 migration (Flutter ≥3.47, AGP 9.2.1, Kotlin 2.4.0, `compileSdk 37`, `android.builtInKotlin=true`, iOS SPM/SceneDelegate), plugin fork swap. Tracked as follow-ups.

## Milestones

1. Pin `receive_sharing_intent` to an AGP 8 compatible release.
2. Fix the secondary JVM-target mismatch exposed once the pin landed.
3. Verify locally (APK + analyze + tests), then re-run Maestro.

## Tasks

- [x] Pin `receive_sharing_intent: 1.8.1` in `pubspec.yaml` with rationale comment.
- [x] Run `flutter pub get`; confirm `pubspec.lock` resolves `receive_sharing_intent 1.8.1`.
- [x] Fix `:plugin:compileDebugKotlin` JVM-target mismatch in `android/build.gradle.kts`.
- [x] Verify `flutter build apk --debug` succeeds.
- [x] Verify `flutter analyze --no-fatal-infos` reports 0 errors / 0 warnings.
- [x] Verify `flutter test` passes.
- [x] Re-run `Maestro Android E2E` via `workflow_dispatch`; confirm `Build debug APK` passes (run `34978993486` on `4e2c6fb` — all steps success).
- [ ] Open follow-up plan for the full AGP 9 migration.
- [ ] **NEW — Maestro flows still fail 8/8 and CI masks it.** Connect a real test backend/account (or gate/skip the manual flows) and stop `continue-on-error` from reporting green.

## Risks

- **Resolved by fix (was blocking): stray brace regression.** The comment-cleanup edit added a stray `}` at line 50 which made `build.gradle.kts` unparseable on CI; the local green build predated that edit. Caught by the CI re-run, fixed in `4e2c6fb`.
- **Pin must exclude `>=1.9.0`.** `^1.8.1` would still allow 1.9.0 (same major), so an exact pin is required; `flutter pub upgrade` / Dependabot may otherwise re-propose 1.9.0.
- **Root Gradle workaround is repo-wide.** The subproject JVM-target alignment touches every Android subproject, not just `receive_sharing_intent`. It is intentionally a no-op for plugins that already agree on a target (it only mirrors each project's own Java target), but it is inert once every plugin ships consistent targets.
- **1.8.1 vs 1.9.0 behaviour.** 1.8.1 predates the iOS SPM/SceneDelegate rewrite and `compileSdk 37`; Android share-target behaviour is unchanged and the host manifest (`AndroidManifest.xml:96-112`) is host-side.
- **Local JDK drift.** The mismatch was JDK-dependent (21 via the Android Studio JBR locally, 17 on CI); the fix removes that dependency rather than matching one specific JDK.
- **CI green is not trustworthy for the E2E suite.** `continue-on-error: true` + `Upload Maestro failure artifacts` on failure means the workflow reports success while every flow fails. Any future "Maestro is green" claim must check the flow log, not the checkmark.

## Progress Log

- 2026-09-15 16:35 — Plan created. Root cause: `receive_sharing_intent 1.9.0` migrated to Flutter Built-in Kotlin and requires AGP 9.2.1 / `compileSdk 37` / Flutter ≥3.47; this app is AGP 8.11.1 / `compileSdk 36` / Flutter 3.41.7, so the plugin's `kotlin {}` block had no extension to resolve. Pinned to 1.8.1.
- 2026-09-15 16:35 — Pin exposed a second, pre-existing defect: plugins omitting a Kotlin `jvmTarget` (e.g. `receive_sharing_intent 1.8.1`) inherit the Gradle JDK target (21 local / 17 CI) while Java stays at AGP's 1.8 default → `:plugin:compileDebugKotlin` "Inconsistent JVM-target compatibility". Fixed in `android/build.gradle.kts` by aligning each subproject's `KotlinCompile.jvmTarget` with that subproject's own `compileOptions.targetCompatibility`.
- 2026-09-15 16:35 — Iterations tried and rejected: (a) global Kotlin→17 override broke `flutter_native_contact_picker`, which deliberately pins Java+Kotlin to 1.8; (b) typed `BaseExtension` lookup returned null for plugins bundling their own AGP classpath (AGP 8.13.0); (c) root-level and `withPlugin`-scoped `afterEvaluate` were illegal because Flutter tooling eagerly evaluates `:app` via `evaluationDependsOn(":app")`; (d) gating on the `org.jetbrains.kotlin.android` plugin id missed plugins using the legacy `kotlin-android` alias. Final solution uses un-gated `tasks.withType(KotlinCompile).configureEach` + reflection, deferred to task realization.
- 2026-09-15 16:35 — Verified locally: `flutter build apk --debug` → `√ Built build\app\outputs\flutter-apk\app-debug.apk` (182 MB); `flutter analyze --no-fatal-infos` → 159 infos, 0 errors, 0 warnings; `flutter test` → 645 passed.
- 2026-09-15 16:39 — Committed `715bacc` and pushed. This commit **failed CI**: the comment-cleanup edit had left a stray `}` at `android/build.gradle.kts:50`, so Gradle reported 22 × "Unexpected symbol" and `Build debug APK` failed. The earlier local green build predated that edit — verification ran before the final edit, not after.
- 2026-09-15 17:02 — Fixed the stray brace in `4e2c6fb`, re-ran `flutter build apk --debug` locally (pass) **before** committing, and pushed.
- 2026-09-15 — Re-ran `Maestro Android E2E` (`34978993486`, `workflow_dispatch` on `4e2c6fb`): **all steps success, job success, workflow success.** `Build debug APK` is genuinely fixed. Historically the build had passed through 2026-09-03 and failed daily from 2026-09-04 (when `receive_sharing_intent 1.9.0` landed) — matching the diagnosis.
- 2026-09-15 — **Follow-up discovery: the workflow green is misleading.** Despite the success conclusion, the run uploaded `maestro-failure-34978993486` (uploaded only when `steps.maestro.outcome == 'failure'`), and the flow log ends with `8/8 Flows Failed` + `The process '/usr/bin/sh' failed with exit code 1`. Failures: `Bottom navigation`, `Currency preference`, `Language preference`, `Empty history state`, `Theme preference`, `Legal documents from Settings` (all "Element not found: Riwayat|History / Pengaturan|Settings"), `Launch existing test state` + `Legal gate on fresh test state` (both "Assertion is false: … is visible"). Cause: the job does `cp .env.example .env`, which bundles **placeholder** `SUPABASE_URL=https://YOUR-PROJECT.supabase.co` / `SUPABASE_ANON_KEY=eyJhbGciOi...`, while the flows require a reachable backend and a pre-seeded signed-in user with legal acceptance + onboarding complete. This is **pre-existing and unrelated to this fix** — the masked-green pattern is visible in older runs too (e.g. `33300326654`, 2026-08-30, also `8/8 Flows Failed` with a success conclusion). Note `SUPABASE_URL`/`SUPABASE_ANON_KEY` *do* exist as repo variable/secret and are already wired in `release.yml`, so the placeholders here are avoidable.

## Notes

- Architecture benchmark: TOGAF applied proportionally — this is a toolchain/build-config fix, not an architecture change. No C2M/TM Forum ODA deviation to justify (not a rating/billing domain change).
- Why not the full upgrade now: `android.builtInKotlin=true` requires Flutter ≥3.47, and 1.9.0 also mandates an iOS SPM/SceneDelegate migration this repo has not adopted. Upgrading Flutter also risks the CI codegen-freshness gate, which pins Flutter for byte-identical `.g.dart` output.
- Replacement candidate if 1.8.1 regresses: `flutter_sharing_intent`, which needs a `ISharedMediaService` rewrite (see `lib/data/services/shared_media_service.dart`).
