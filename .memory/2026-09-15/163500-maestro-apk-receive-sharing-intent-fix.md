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

**Assumptions / risks.**
- Pin must stay exact; `flutter pub upgrade`/Dependabot could otherwise re-propose 1.9.0.
- The Gradle workaround is inert for plugins already consistent on Java/Kotlin targets, but it is repo-wide by design.
- Not validated on CI yet (local JDK 21 vs CI JDK 17); the fix removes JDK dependence, so the CI re-run is the remaining confirmation.

**Unresolved / follow-up.**
- Re-run `Maestro Android E2E` (dispatch or nightly cron) to confirm `Build debug APK` passes on CI.
- Separate plan for the full AGP 9 migration (Flutter ≥3.47, AGP 9.2.1, Kotlin 2.4.0, `compileSdk 37`, `android.builtInKotlin=true`, iOS SPM/SceneDelegate) — also needed before any future `receive_sharing_intent` 1.9.0 bump.
- Fallback if 1.8.1 regresses: `flutter_sharing_intent` (needs `ISharedMediaService` rewrite).

**Commit proposal.** `fix(android): unblock debug APK build with receive_sharing_intent 1.8.1 pin`

**Plan.** [plans/2026-09-15-maestro-apk-receive-sharing-intent-fix.md](../../plans/2026-09-15-maestro-apk-receive-sharing-intent-fix.md)
