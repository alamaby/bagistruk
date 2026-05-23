import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load android/key.properties for release signing. The file is gitignored;
// see key.properties.example for the expected schema. Falls back to debug
// signing when the file is absent (e.g. CI debug builds, fresh clones).
val keystoreProperties = Properties().apply {
    val keystoreFile = rootProject.file("key.properties")
    if (keystoreFile.exists()) {
        load(FileInputStream(keystoreFile))
    }
}
val hasReleaseSigning = keystoreProperties.getProperty("storeFile") != null

android {
    namespace = "com.alamaby.bagistruk"
    // Pinned to Android 16 (API 36) — Play Store requires targetSdk 35+ from
    // Aug 2025 and is expected to require 36 from Aug 2026. Pinning explicitly
    // also avoids surprises when bumping the Flutter SDK.
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.alamaby.bagistruk"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // When key.properties is absent we fall back to debug signing so
            // `flutter run --release` still works locally. Play Store uploads
            // MUST use the release keystore — see README "Release build".
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}

fun readPubspecValue(key: String): String? {
    val pubspec = rootProject.projectDir.parentFile.resolve("pubspec.yaml")
    if (!pubspec.exists()) return null
    return pubspec.readLines()
        .firstOrNull { it.startsWith("$key:") }
        ?.substringAfter(":")
        ?.trim()
        ?.trim('"', '\'')
}

fun readAndroidAppLabel(): String? {
    val manifest = projectDir.resolve("src/main/AndroidManifest.xml")
    if (!manifest.exists()) return null
    val labelRegex = Regex("""android:label\s*=\s*"([^"]+)"""")
    return labelRegex.find(manifest.readText())?.groupValues?.getOrNull(1)
}

fun String.asApkFileSegment(): String =
    replace(Regex("""[^\w.-]+"""), "-").trim('-').ifEmpty { "app" }

val copyNamedReleaseApk = tasks.register<Copy>("copyNamedReleaseApk") {
    group = "build"
    description = "Copies the release APK using the app name and pubspec version."

    val flutterProjectDir = rootProject.projectDir.parentFile
    val appName = (readAndroidAppLabel() ?: readPubspecValue("name") ?: "app")
        .asApkFileSegment()
    val version = (readPubspecValue("version") ?: "0.0.0")
        .replace("+", "-")
        .asApkFileSegment()
    val apkName = "$appName-$version.apk"
    val releaseApk = flutterProjectDir.resolve("build/app/outputs/apk/release/app-release.apk")
    val flutterApkOutputDir = flutterProjectDir.resolve("build/app/outputs/flutter-apk")

    from(releaseApk) {
        rename { "app-release.apk" }
    }
    from(releaseApk) {
        rename { apkName }
    }
    into(flutterApkOutputDir)

    doLast {
        println("Named APK created: build/app/outputs/flutter-apk/$apkName")
    }
}

tasks.matching { it.name == "assembleRelease" }.configureEach {
    finalizedBy(copyNamedReleaseApk)
}
