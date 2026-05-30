# Google Play Store Release Guide

The Android release build is configured for `compileSdk = 36` / `targetSdk = 36` with R8 minification and resource shrinking enabled. Use this guide to produce a Play-Store-ready App Bundle.

## 1. Generate the upload keystore

Run once:

```bash
keytool -genkey -v -keystore android/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Keep `upload-keystore.jks` and its passwords backed up offline. Losing it can block future updates under the same Play Store listing. `.gitignore` excludes `*.jks` and `key.properties`.

## 2. Wire the signing credentials

```bash
cp android/key.properties.example android/key.properties
# Edit android/key.properties and fill in storePassword, keyPassword.
```

## 3. Generate adaptive launcher icons

```bash
dart run flutter_launcher_icons
```

The current `assets/images/icon_launcher.png` is reused as both the legacy and adaptive-icon foreground. For best results on Android 8+ devices, replace it with a 1024x1024 PNG that has transparent padding before the first Play Store upload.

## 4. Build the App Bundle

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

Verify the bundle is signed with the upload key, not the debug key:

```bash
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

## 5. Smoke test on Android 16

```bash
flutter build apk --release
flutter install
```

Test on an emulator running API 36 and, ideally, a physical device. Verify:

- Sign-in with Supabase works.
- Google Sign-In works with the release/upload key fingerprint.
- Receipt camera capture succeeds.
- Gallery multi-image picker succeeds without broad media-read permission.
- OCR pipeline succeeds for camera and gallery images.
- Save bill, edit item, assign participant, settlement, and share flows work.
- Privacy Policy and Terms of Service screens open.
- No screen has content hidden behind the status bar or navigation bar.
- Predictive back gesture navigates correctly.

## 6. Build the AAB via GitHub Actions

Trigger the **Build Play Store AAB** workflow manually from the Actions tab. It uses `workflow_dispatch`.

Required repository secrets and variables:

| Kind | Name | Value |
|------|------|-------|
| Secret | `KEYSTORE_BASE64` | `base64 -w0 android/upload-keystore.jks` |
| Variable | `KEY_ALIAS` | `upload` or the alias used with `keytool` |
| Secret | `KEY_PASSWORD` | Key password |
| Secret | `STORE_PASSWORD` | Keystore password |
| Variable | `SUPABASE_URL` | Supabase project URL |
| Secret | `SUPABASE_ANON_KEY` | Supabase anon key |

The workflow uploads the signed AAB as a workflow artifact with 30-day retention. Download it and upload manually to Play Console. Once the Google service account is ready, add an upload step using `r0adkll/upload-google-play` for automated internal-track releases.

## 7. Upload to Play Console

1. Go to **Play Console -> Internal testing** and upload `app-release.aab`.
2. Use package name `com.alamaby.bagistruk`.
3. Under **App content**:
   - Submit the public Privacy Policy URL: `https://bagistruk.vercel.app/privacy`.
   - Complete the Data safety form for email, receipt photos, bill data, Supabase, Google Sign-In, OCR providers, and reminder email provider if enabled.
   - Complete content rating, target audience, and app access declarations.
4. Promote to **Closed testing -> Production** once internal testing passes.

## 8. Store listing assets

Place final source assets under `docs/assets/play-store/` or another tracked docs folder:

- Feature graphic: 1024x500.
- Phone screenshots for scan, review, split, and settlement flows.
- Tablet screenshots if tablet support is part of the release target.
- Public Privacy Policy URL: `https://bagistruk.vercel.app/privacy`.
