# Fix Maestro Android E2E `assembleDebug` Failure (receive_sharing_intent)

Created: 2026-09-15 16:35:00

## Objective

Unblock the `Maestro Android E2E` workflow step `Build debug APK` (`flutter build apk --debug`), which failed evaluating project `:receive_sharing_intent` with `Could not find method kotlin()` at `build.gradle` line 53.

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
- [ ] Re-run `Maestro Android E2E` via `workflow_dispatch` / nightly schedule; confirm `Build debug APK` passes.
- [ ] Open follow-up plan for the full AGP 9 migration.

## Risks

- **Pin must exclude `>=1.9.0`.** `^1.8.1` would still allow 1.9.0 (same major), so an exact pin is required; `flutter pub upgrade` / Dependabot may otherwise re-propose 1.9.0.
- **Root Gradle workaround is repo-wide.** The subproject JVM-target alignment touches every Android subproject, not just `receive_sharing_intent`. It is intentionally a no-op for plugins that already agree on a target (it only mirrors each project's own Java target), but it is inert once every plugin ships consistent targets.
- **1.8.1 vs 1.9.0 behaviour.** 1.8.1 predates the iOS SPM/SceneDelegate rewrite and `compileSdk 37`; Android share-target behaviour is unchanged and the host manifest (`AndroidManifest.xml:96-112`) is host-side.
- **Local JDK drift.** The mismatch was JDK-dependent (21 via the Android Studio JBR locally, 17 on CI); the fix removes that dependency rather than matching one specific JDK.

## Progress Log

- 2026-09-15 16:35 — Plan created. Root cause: `receive_sharing_intent 1.9.0` migrated to Flutter Built-in Kotlin and requires AGP 9.2.1 / `compileSdk 37` / Flutter ≥3.47; this app is AGP 8.11.1 / `compileSdk 36` / Flutter 3.41.7, so the plugin's `kotlin {}` block had no extension to resolve. Pinned to 1.8.1.
- 2026-09-15 16:35 — Pin exposed a second, pre-existing defect: plugins omitting a Kotlin `jvmTarget` (e.g. `receive_sharing_intent 1.8.1`) inherit the Gradle JDK target (21 local / 17 CI) while Java stays at AGP's 1.8 default → `:plugin:compileDebugKotlin` "Inconsistent JVM-target compatibility". Fixed in `android/build.gradle.kts` by aligning each subproject's `KotlinCompile.jvmTarget` with that subproject's own `compileOptions.targetCompatibility`.
- 2026-09-15 16:35 — Iterations tried and rejected: (a) global Kotlin→17 override broke `flutter_native_contact_picker`, which deliberately pins Java+Kotlin to 1.8; (b) typed `BaseExtension` lookup returned null for plugins bundling their own AGP classpath (AGP 8.13.0); (c) root-level and `withPlugin`-scoped `afterEvaluate` were illegal because Flutter tooling eagerly evaluates `:app` via `evaluationDependsOn(":app")`; (d) gating on the `org.jetbrains.kotlin.android` plugin id missed plugins using the legacy `kotlin-android` alias. Final solution uses un-gated `tasks.withType(KotlinCompile).configureEach` + reflection, deferred to task realization.
- 2026-09-15 16:35 — Verified locally: `flutter build apk --debug` → `√ Built build\app\outputs\flutter-apk\app-debug.apk` (182 MB); `flutter analyze --no-fatal-infos` → 159 infos, 0 errors, 0 warnings; `flutter test` → 645 passed.
- 2026-09-15 16:35 — Pending: Maestro workflow re-run (manual dispatch or nightly cron) and the AGP 9 follow-up plan.

## Notes

- Architecture benchmark: TOGAF applied proportionally — this is a toolchain/build-config fix, not an architecture change. No C2M/TM Forum ODA deviation to justify (not a rating/billing domain change).
- Why not the full upgrade now: `android.builtInKotlin=true` requires Flutter ≥3.47, and 1.9.0 also mandates an iOS SPM/SceneDelegate migration this repo has not adopted. Upgrading Flutter also risks the CI codegen-freshness gate, which pins Flutter for byte-identical `.g.dart` output.
- Replacement candidate if 1.8.1 regresses: `flutter_sharing_intent`, which needs a `ISharedMediaService` rewrite (see `lib/data/services/shared_media_service.dart`).
