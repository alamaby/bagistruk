import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Published plugins often omit a Kotlin `jvmTarget` (e.g. receive_sharing_intent
// 1.8.1). The Kotlin Gradle Plugin then falls back to the JDK running Gradle
// (21 locally via the Android Studio JBR, 17 on CI) while the Java task keeps
// AGP's 1.8 default, failing `:plugin:compileDebugKotlin` with "Inconsistent
// JVM-target compatibility". Forcing one global target is wrong — some plugins
// deliberately pin Java *and* Kotlin to 1.8 — so align each subproject's Kotlin
// target with that subproject's own Java target instead. That keeps the build
// independent of which JDK Gradle happens to run on.
subprojects {
    // Matching every `KotlinCompile` task (rather than gating on a plugin id) is
    // deliberate: plugins apply the legacy `kotlin-android` alias, which does
    // not register the `org.jetbrains.kotlin.android` id.
    tasks.withType(KotlinCompile::class.java).configureEach {
        // `configureEach` defers to task realization (after evaluation), so the
        // plugin's own `compileOptions` are already applied. Reflection is used
        // because plugins pinning their own AGP buildscript classpath (e.g.
        // flutter_native_contact_picker) expose a different `BaseExtension` type.
        val android = project.extensions.findByName("android") ?: return@configureEach
        val javaTarget = runCatching {
            val compileOptions = android.javaClass.getMethod("getCompileOptions").invoke(android)
            compileOptions.javaClass.getMethod("getTargetCompatibility").invoke(compileOptions)
        }.getOrNull() ?: return@configureEach
        compilerOptions.jvmTarget.set(JvmTarget.fromTarget(javaTarget.toString()))
    }
}
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
