# Fix Maestro Android E2E debug-APK build (`receive_sharing_intent`)

**Task.** `Maestro Android E2E` failed at `Build debug APK` with `Could not find method kotlin()` at `receive_sharing_intent-1.9.0/android/build.gradle` line 53.
**Root cause (two defects).**
1. `receive_sharing_intent 1.9.0` migrated to Flutter Built-in Kotlin, so it no longer applies KGP itself and its `kotlin { compilerOptions { ... } }` block has no extension to resolve against. It also hard-requires AGP 9.2.1, Gradle 9.4.1, Kotlin 2.4.0, `compileSdk 37`. This app is AGP 8.11.1 / Kotlin 2.2.20 / `compileSdk 36` / Flutter 3.41.7, and `android.builtInKotlin=true` needs Flutter ≥3.47.
2. Once pinned, a pre-existing defect surfaced: plugins that omit a Kotlin `jvmTarget` inherit the Gradle JDK's target (21 locally via the Android Studio JBR, 17 on CI) while AGP keeps Java at 1.8 → `:plugin:compileDebugKotlin` "Inconsistent JVM-target compatibility". This affected `receive_sharing_intent` and would have hit more plugins.

**Key files changed.**
- `pubspec.yaml` — `receive_sharing_intent: ^1.9.0` → exact `1.8.1` (last AGP 8 compatible; `^1.8.1` would still allow 1.9.0).
- `pubspec.lock` — regenerated to `receive_sharing_intent 1.8.1`.
- `android/build.gradle.kts` — new `subprojects` block aligning each project's `KotlinCompile.jvmTarget` with its own `compileOptions.targetCompatibility`.

**Decisions / non-obvious constraints (the blocked approaches).**
- Do **not** force a single global Kotlin target: `flutter_native_contact_picker` deliberately pins Java *and* Kotlin to 1.8; overriding Kotlin to 17 broke it. Mirror the project's own Java target instead.
- Do **not** use typed `BaseExtension` lookup: plugins pinning their own AGP buildscript classpath (e.g. `flutter_native_contact_picker` → AGP 8.13.0) expose a different classloader/type, so `findByType` silently returns null. Used reflective `getCompileOptions().getTargetCompatibility()`.
- Do **not** use `afterEvaluate`: Flutter tooling eagerly evaluates `:app` via `evaluationDependsOn(":app")` in the same file, making a later root-level or `withPlugin`-scoped `afterEvaluate` fail with "Cannot run Project.afterEvaluate(Action) when the project is already evaluated". `tasks.withType(...).configureEach` defers to task realization (post-evaluation) and is safe.
- Do **not** gate on the `org.jetbrains.kotlin.android` plugin id: plugins apply the legacy `kotlin-android` alias, which does not register that id for `pluginManager.withPlugin`.

**Verification.**
- `flutter build apk --debug` → `√ Built build\app\outputs\flutter-apk\app-debug.apk` (~182 MB).
- `flutter analyze --no-fatal-infos` → 159 infos, **0 errors, 0 warnings**.
- `flutter test` → **645 passed**.
- CI re-run `Maestro Android E2E` run `34978993486` (`workflow_dispatch` on `4e2c6fb`): **workflow success**, `Build debug APK` step success. Build was green through 2026-09-03 and red daily from 2026-09-04 (when `receive_sharing_intent 1.9.0` landed), matching the diagnosis.

**Regression caught and fixed mid-task.**
- Commit `715bacc` was pushed **and failed CI**: the comment-cleanup edit left a stray `}` at `android/build.gradle.kts:50` → 22 × "Unexpected symbol", `Build debug APK` failed. The local green build had run *before* that final edit.
- Fixed in `4e2c6fb` (removed the brace), rebuilt locally *before* committing, then pushed. Lesson: re-run the build after the last edit, not before it.

**CI green is misleading for the E2E suite (pre-existing, unrelated).**
- Run `34978993486` reports success yet uploaded `maestro-failure-34978993486` (uploaded only when `steps.maestro.outcome == 'failure'`), and the log ends `8/8 Flows Failed` + exit code 1. `continue-on-error: true` masks it.
- All 8 flows fail: 6 × "Element not found: `Riwayat|History` / `Pengaturan|Settings`", 2 × "Assertion is false: … is visible".
- Cause: `maestro.yml` does `cp .env.example .env`, bundling placeholder `SUPABASE_URL=https://YOUR-PROJECT.supabase.co` / `SUPABASE_ANON_KEY=eyJhbGciOi...`, but every flow requires a reachable backend **and a pre-seeded signed-in user with legal acceptance + onboarding complete** (see each flow's Preconditions). There is no seeding step.
- Same masked-green pattern in older runs (e.g. `33300326654`, 2026-08-30, also `8/8 Flows Failed` with a success conclusion), so this long predates this fix — and means the suite has likely never been green despite repeated "success" workflow conclusions.

**Fix: unmask the signal, skip until a test backend exists (`1ae71b6`).**
- Correction to this task's own first instinct: do **not** wire the existing `SUPABASE_*` secrets here. Per `plans/2026-07-24-p2-testing-maintainability-plan.md:50,70` the suite must use an **isolated test backend, never production** — the flows mutate preferences and create anonymous users. Also, `.env` is bundled at *build* time (flutter_dotenv asset), so credentials must be injected before `flutter build apk`.
- Removed `continue-on-error: true` so a real flow failure fails the job. Safe: `maestro.yml` triggers only on `schedule`/`workflow_dispatch` and is not a required PR check, so red blocks nothing (the 2026-07-24 plan keeps it deliberately non-blocking until stable).
- Added a guard in `Create CI environment file`: with no `E2E_SUPABASE_URL` secret the APK still builds (step keeps working as a build check) but `Install Maestro` + the emulator step are **skipped**, and the summary step states the flows were skipped and why. A flow cannot pass against placeholder creds, so running them could only yield a guaranteed failure.
- With the secret present, `.env` is rewritten to exactly one `SUPABASE_URL`/`SUPABASE_ANON_KEY` pair (`grep -v` then append, avoiding duplicate-key ambiguity) and the flows run for real.
- Added an `always()` summary (build status, flow outcome, skip reason) and moved artifact upload to `if: failure()`.
- Verified both paths: `.env` rewrite logic locally under `bash` (one of each key, placeholder gone, other keys intact); CI skip path via run `35030305477` (`Build debug APK` success, flows `skipped`, summary success, notice explains why). YAML parsed clean.

**Assumptions / risks.**
- Pin must stay exact; `flutter pub upgrade`/Dependabot could otherwise re-propose 1.9.0.
- The Gradle workaround is inert for plugins already consistent on Java/Kotlin targets, but it is repo-wide by design.
- Do **not** treat a green `Maestro Android E2E` checkmark as E2E coverage: the flows are skipped until a test backend is configured.
- The `.env` rewrite assumes `E2E_SUPABASE_URL` and `E2E_SUPABASE_ANON_KEY` are set together; a URL without a key would build an APK with a blank anon key. Consider asserting both in a follow-up.

**Unresolved / follow-up.**
- Create a dedicated test Supabase project, add `E2E_SUPABASE_URL`/`E2E_SUPABASE_ANON_KEY` secrets, and add a seeding step (signed-in user + legal acceptance + onboarding complete) so the flows can actually run. Until then the emulator step is skipped, not red.
- Separate plan for the full AGP 9 migration (Flutter ≥3.47, AGP 9.2.1, Kotlin 2.4.0, `compileSdk 37`, `android.builtInKotlin=true`, iOS SPM/SceneDelegate) — also needed before any future `receive_sharing_intent` 1.9.0 bump.
- Fallback if 1.8.1 regresses: `flutter_sharing_intent` (needs `ISharedMediaService` rewrite).

**Commits.** `715bacc` (pin + Gradle fix, failed CI) → `4e2c6fb` (remove stray brace, CI green) → `bbcf521` (docs) → `1ae71b6` (unmask Maestro failures, CI verified).

**Commit proposal.** `fix(android): unblock debug APK build with receive_sharing_intent 1.8.1 pin`

**Plan.** [plans/2026-09-15-maestro-apk-receive-sharing-intent-fix.md](../../plans/2026-09-15-maestro-apk-receive-sharing-intent-fix.md)
