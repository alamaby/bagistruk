# BagiStruk

**BagiStruk** is a Flutter app that splits bills from receipt photos. Snap one or more receipts, let the AI extract every line item, review and edit the results, then assign items to participants — tax and service charges are distributed proportionally.

---

## Features

- **Receipt OCR** — Upload one or multiple receipt photos. Items, prices, quantities, merchant name, and receipt date are extracted automatically via a multi-provider LLM pipeline (Gemini, OpenRouter, NvidiaNIM with priority-ordered failover).
- **Review & Edit** — Every extracted item is editable before saving: name, quantity (supports decimals for weight/volume), and price. Tax and service amounts are pre-filled from the receipt and can be adjusted.
- **Bill Splitting** — Assign items to participants. Tax and service are distributed proportionally based on each participant's subtotal share.
- **Settlement Loop** — After splitting, a dedicated detail screen tracks per-participant payment status with optimistic toggles. When everyone has paid, the bill is auto-marked settled.
- **Anonymous-first Auth** — Sessions persist across restarts (supabase_flutter local storage). Anonymous sign-in is created lazily on the first action that requires `auth.uid()` (e.g. tapping Scan), so a previously-restored email session is never overwritten. Users can promote an anonymous account to a full email account without losing their bill history. Anonymous users get a generic locale-aware label ("Saya" / "Me") and cannot edit their display name — this nudges them to register if they want personalization.
- **Profile & Settings** — Change display name, default currency, app language, and theme (light / dark / system) from the dedicated Settings tab. Persisted per user account in the `profiles` table. Anonymous users see a "Create Permanent Account" CTA; authenticated users can reset their password or log out.
- **About page** — Dedicated screen with app version (via `package_info_plus`), author info, and link tiles to website / GitHub / LinkedIn / Buy Me a Coffee / Saweria / Patreon. Reachable from the Settings tab.
- **Locale-aware OCR** — User's `default_currency` is sent with each scan so the Edge Function can guide the LLM with the right number-format convention (e.g. for Indonesian / European receipts, `.` is a thousand separator, not a decimal). Server-side post-processing reconstructs integer prices for zero-decimal currencies (IDR, JPY, KRW, VND, CLP, ISK, HUF, TWD), and a client-side safety-net banner warns the user if any extracted price still has a fractional part for a zero-decimal currency.
- **Multi-language** — Full UI localization in Bahasa Indonesia and English. Switch instantly from Settings without restarting the app.
- **Theme** — Light, dark, and system-follow modes. Applied globally and persisted in the user profile.
- **Offline-safe keys** — All LLM API keys are stored server-side in Supabase. No keys are bundled in the app or exposed to the client.
- **Rate-limited inserts** — Database-level trigger enforces 30 bills/hour and 200 bills/day per user to prevent abuse.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile | Flutter 3.11+, Dart |
| State management | Riverpod 3 (code-gen), Freezed 3 |
| Navigation | go_router 14 |
| UI utilities | flutter_screenutil, flutter_animate, Lottie |
| Backend | Supabase (Postgres + RLS, Auth, Edge Functions / Deno) |
| LLM | Gemini, OpenRouter, NvidiaNIM — provider config stored in DB |
| Localization | flutter_localizations + ARB gen-l10n (ID / EN) |

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.11
- A [Supabase](https://supabase.com) project
- At least one LLM provider API key (Gemini recommended)

### 1. Environment

```bash
cp .env.example .env
# Fill in your values:
# SUPABASE_URL=https://<project>.supabase.co
# SUPABASE_ANON_KEY=<anon-key>
```

### 2. Database schema

```bash
supabase db push
```

### 3. LLM provider

Insert at least one active row into `llm_configs`:

```sql
INSERT INTO llm_configs (provider_name, api_key, base_url, model_name, priority, is_active)
VALUES (
  'gemini',
  '<YOUR_GEMINI_API_KEY>',
  'https://generativelanguage.googleapis.com',
  'gemini-2.0-flash',
  1,
  true
);
```

See [PROJECT_SUMMARY.md §5](PROJECT_SUMMARY.md) for adding fallback providers.

### 4. Enable Anonymous Sign-In

In your Supabase Dashboard: **Authentication → Providers → Anonymous Sign-Ins → Enable**

Without this, inserts into `bills` will be rejected by Row Level Security.

### 5. Deploy the Edge Function

```bash
supabase functions deploy process-receipt
```

### 6. Code generation & run

```bash
dart run build_runner build --delete-conflicting-outputs
flutter pub get   # also triggers flutter gen-l10n (ARB → Dart)
flutter run
```

---

## How to Use

1. **Open the app** — your previous session is restored if you have one; otherwise you stay signed-out until your first action.
2. **Tap the camera button** on the home screen to pick one or more receipt photos from your gallery.
3. **Tap Scan** — an anonymous session is created on the fly if needed, then images are sent to the OCR pipeline.
4. **Review the results** — check extracted items, adjust quantities or prices if needed, and set tax/service amounts.
5. **Add participants** — enter the names of people splitting the bill.
6. **Assign items** — mark which items each participant ordered.
7. **Save** — totals per participant (including their share of tax/service) are calculated and stored.
8. **Track settlement** — on the bill detail screen, toggle each participant's payment status. The bill auto-marks as settled when all participants are paid.
9. *(Optional)* **Open the Settings tab** — tap the person icon in the bottom nav. Change your display name, default currency, language, or theme. Tap "Create Permanent Account" to promote your anonymous session to a full email account and keep all your bills.

---

## Smoke Test (CLI)

```bash
./smoketest.sh path/to/receipt.jpg
```

Reads `SUPABASE_URL` and `SUPABASE_ANON_KEY` from `.env`. Exit 0 = OCR pipeline is healthy.

---

## Release Build (Google Play Store)

The Android release build is configured for `compileSdk = 36` / `targetSdk = 36` with R8 minification and resource shrinking enabled. Follow these steps to produce a Play-Store-ready App Bundle:

### 1. Generate the upload keystore (one time)

```bash
keytool -genkey -v -keystore android/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

> ⚠️ Keep `upload-keystore.jks` and its passwords backed up offline. **Losing it means you can no longer publish updates** under the same Play Store listing without contacting Google support. `.gitignore` already excludes `*.jks` and `key.properties`.

### 2. Wire the signing credentials

```bash
cp android/key.properties.example android/key.properties
# Edit android/key.properties and fill in storePassword, keyPassword.
```

### 3. Generate adaptive launcher icons

```bash
dart run flutter_launcher_icons
```

> The current `assets/images/icon_launcher.png` is reused as both the legacy and adaptive-icon foreground. For best results on Android 8+ devices, replace it with a 1024×1024 PNG that has transparent padding (artwork should fit within the inner 66% safe zone) before the first Play Store upload.

### 4. Build the App Bundle

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

Verify the bundle is signed with the upload key (not the debug key):

```bash
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

### 5. Smoke test on Android 16

```bash
flutter build apk --release
flutter install
```

Test on an emulator running API 36 and (ideally) a physical device. Verify:

- Sign-in with Supabase works
- Receipt camera capture + OCR pipeline succeeds
- Share bill action works
- No screen has content hidden behind the status bar / navigation bar (edge-to-edge is enforced on `targetSdk = 36`)
- Predictive back gesture navigates correctly

### 6a. (Optional) Build the AAB via GitHub Actions

Trigger the **Build Play Store AAB** workflow manually from the Actions tab (uses `workflow_dispatch`). Required repository secrets and variables:

| Kind | Name | Value |
|------|------|-------|
| Secret | `KEYSTORE_BASE64` | `base64 -w0 android/upload-keystore.jks` |
| Variable | `KEY_ALIAS` | `upload` (or whatever alias you used with `keytool`) |
| Secret | `KEY_PASSWORD` | key password |
| Secret | `STORE_PASSWORD` | keystore password |
| Variable | `SUPABASE_URL` | Supabase project URL |
| Secret | `SUPABASE_ANON_KEY` | Supabase anon key |

The workflow uploads the signed AAB as a workflow artifact (30-day retention) — download it and upload manually to Play Console. Once the Google service account is ready, add an upload step using [r0adkll/upload-google-play](https://github.com/r0adkll/upload-google-play) for fully automated releases.

### 6b. Upload to Play Console

1. Go to **Play Console → Internal testing** for your app and upload `app-release.aab`.
   - Package name: `com.alamaby.bagistruk`
2. Under **App content**:
   - Submit the **Privacy policy URL** (host `docs/privacy-policy.md` publicly, e.g. on GitHub Pages, and paste the URL here — required because the app uses CAMERA and stores user data).
   - Complete the **Data safety** form: declare collection of email, photos (receipts), and user-entered text (bill data); declare third-party processing (Supabase + OCR providers).
3. Promote to **Closed testing → Production** once internal testing passes.

---

## Full Technical Documentation

See [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) — architecture diagrams, database schema, Edge Function lifecycle, Flutter layer flow, LLM provider configuration, and troubleshooting.
