# BagiStruk Email Campaign Plan

**Tanggal:** 2026-06-09

Dokumen ini menyiapkan strategi email lifecycle untuk:

- membantu user Free memahami value BagiStruk,
- mendorong upgrade ke Plus,
- membuat user Plus merasa subscription-nya tetap bernilai,
- mengajak mantan user Plus kembali subscribe,
- memastikan user bisa unsubscribe dari email campaign.

> Catatan compliance: email campaign bersifat komersial/marketing, jadi harus punya unsubscribe yang jelas, alamat pengirim yang valid, subject yang tidak menyesatkan, dan suppression list. Lakukan review legal sebelum campaign aktif publik.

## Prinsip Campaign

1. **Helpful first, sales second.** Email harus membantu user menyelesaikan use case nyata, bukan hanya meminta upgrade.
2. **Lifecycle-aware.** Jangan kirim email upgrade ke user Plus aktif. Jangan kirim winback ke user yang masih berada dalam periode Plus aktif.
3. **Respect inbox.** Batasi frekuensi: maksimal 1 email marketing per user per 7 hari, kecuali email transactional seperti verification atau payment.
4. **Consent and unsubscribe.** Campaign hanya untuk registered user yang belum opt-out. Semua email marketing punya unsubscribe link.
5. **Localized.** Gunakan `profiles.language_pref` untuk memilih Bahasa Indonesia atau English.
6. **Measurable.** Simpan delivery, open/click jika provider mendukung, conversion ke Plus, dan unsubscribe.
7. **Privacy-safe.** Jangan masukkan detail struk sensitif di email. Gunakan aggregate ringan seperti jumlah bill atau sisa credit, bukan nama merchant/item personal kecuali user memberi izin eksplisit.

## Segmentasi Utama

| Segment | Kriteria | Tujuan |
| --- | --- | --- |
| New Free | Registered Free, 1 hari setelah daftar, belum opt-out | onboarding dan link panduan |
| Activated Free | Registered Free, 7 hari setelah daftar | edukasi use case harian |
| Free with usage | Free yang sudah scan/simpan bill | tunjukkan fitur Plus yang relevan |
| Low credit Free | Free dengan credit hampir habis | upgrade atau top-up credit |
| Plus active | Plus aktif | retention, fitur lanjutan, value recap |
| Plus ending soon | Plus aktif dan renewal/expiry dekat | reminder value sebelum churn |
| Former Plus | Plus sudah berakhir minimal 3 hari | winback |
| Email opt-out | User opt-out marketing | jangan kirim marketing |

## Campaign Yang Diusulkan

### 1. Welcome + User Guide

- **Trigger:** 1 hari setelah user registered.
- **Audience:** Free registered user, belum opt-out.
- **Skip jika:** user sudah Plus, email belum verified, atau sudah menerima email welcome.
- **Goal:** bantu user berhasil membuat bill pertama.
- **CTA:** buka landing page/user guide.
- **Landing URL:** `https://bagistruk.vercel.app/?utm_source=email&utm_medium=lifecycle&utm_campaign=welcome_day1`

Subject options:

- `Selamat datang di BagiStruk - ini cara cepat mulai scan struk`
- `Mulai bagi tagihan pertama kamu dengan BagiStruk`

Copy draft:

```text
Halo,

Selamat datang di BagiStruk.

Cara paling cepat mulai:
1. Buka tab Scan.
2. Tambahkan foto struk dari kamera atau galeri.
3. Cek hasil OCR sebelum disimpan.
4. Tambahkan teman dan bagi item sesuai pesanan.
5. Tandai siapa yang sudah bayar.

Kami juga menyiapkan panduan singkat dengan gambar untuk flow scan sampai settlement.

CTA: Baca panduan BagiStruk
```

### 2. Day 7 Use Case Education

- **Trigger:** 7 hari setelah user registered.
- **Audience:** Free registered user, belum opt-out.
- **Skip jika:** sudah Plus, sudah menerima day 7 email.
- **Goal:** memperlihatkan penggunaan sehari-hari yang konkret.
- **CTA:** buka app atau user guide.

Subject options:

- `5 situasi sehari-hari yang cocok dibagi dengan BagiStruk`
- `Makan bareng, patungan, sampai settlement: ini cara pakai BagiStruk`

Contoh use case:

- makan siang kantor saat tiap orang pesan menu berbeda,
- nongkrong di kafe dengan pajak dan service,
- belanja snack untuk acara kecil,
- split bill keluarga saat liburan,
- patungan delivery food dengan item campuran.

Copy draft:

```text
Halo,

BagiStruk paling berguna saat total tagihan tidak cukup dibagi rata.

Contoh:
- Makan bareng kantor: tiap orang pesan menu berbeda.
- Kafe dengan service charge: pajak/service otomatis dibagi proporsional.
- Delivery food: item bisa ditandai ke orang yang benar.
- Patungan acara kecil: pantau siapa yang sudah bayar.

Di Free, kamu bisa mencoba 20 credit scan per bulan. Kalau butuh history lebih panjang, export PDF/CSV, info bank di pesan settlement, dan tanpa iklan, Plus bisa membantu.

CTA: Coba scan struk berikutnya
```

### 3. Low Credit Upgrade Nudge

- **Trigger:** Free user balance <= 3 credit dan sudah memakai minimal 5 scan bulan berjalan.
- **Audience:** Free registered user.
- **Skip jika:** sudah Plus, opt-out, atau sudah menerima low-credit email dalam 14 hari terakhir.
- **Goal:** upgrade ke Plus atau beli credit pack saat tersedia.
- **CTA:** buka Settings billing.

Subject options:

- `Credit scan kamu hampir habis`
- `Butuh scan lebih banyak bulan ini?`

Copy angle:

- Free: 20 credit/bulan.
- Plus: 60 credit/bulan, tanpa iklan, fitur Plus.
- Credit pack: opsi top-up jika user tidak ingin subscription.

### 4. First Successful Settlement

- **Trigger:** user Free menyelesaikan settlement pertama, misalnya semua participant `is_paid=true`.
- **Delay:** 1 hari setelah settlement berhasil.
- **Audience:** Free registered user.
- **Goal:** momentum: user baru merasakan value.
- **CTA:** pelajari fitur Plus.

Subject options:

- `Bill pertama kamu sudah selesai - ini yang bisa dibuat lebih praktis`
- `Settlement beres. Mau lebih cepat untuk bill berikutnya?`

Plus angle:

- simpan info bank transfer agar pesan settlement lebih lengkap,
- export PDF/CSV untuk arsip,
- history 90 hari,
- restore bill terhapus.

### 5. Plus Feature Education

- **Trigger:** 2 hari setelah upgrade ke Plus.
- **Audience:** Plus active.
- **Goal:** retention lewat activation fitur Plus.
- **CTA:** buka Settings untuk isi info bank, atau coba export PDF/CSV.

Subject options:

- `Plus kamu aktif - 4 fitur yang sebaiknya langsung dicoba`
- `Cara memaksimalkan BagiStruk Plus`

Copy points:

- 60 credit scan per bulan.
- Tanpa iklan.
- History 90 hari dan monthly insight.
- Export PDF/CSV.
- Info bank transfer untuk settlement.
- Restore bill terhapus 30 hari.

### 6. Monthly Plus Value Recap

- **Trigger:** setiap bulan, 3-5 hari sebelum periode Plus berakhir/renewal.
- **Audience:** Plus active, belum opt-out marketing.
- **Goal:** membuat user sadar value yang sudah dipakai.
- **CTA:** buka History atau scan struk berikutnya.

Subject options:

- `Ringkasan BagiStruk Plus kamu bulan ini`
- `Plus recap: bill, scan, dan settlement bulan ini`

Isi aman:

- jumlah scan bulan ini,
- jumlah bill disimpan,
- jumlah settlement lunas,
- sisa credit,
- fitur Plus yang belum dicoba.

Hindari:

- nama merchant,
- daftar item,
- nominal personal yang terlalu detail.

### 7. Plus Ending Soon Reminder

- **Trigger:** 3 hari sebelum `current_period_end`, hanya jika Google Play/entitlement menunjukkan subscription berisiko tidak renew atau status `past_due/canceled`.
- **Audience:** Plus active yang kemungkinan akan berakhir.
- **Goal:** cegah churn.
- **CTA:** buka Google Play subscription atau Settings billing.

Subject options:

- `Plus kamu akan segera berakhir`
- `Jangan kehilangan fitur Plus untuk bill berikutnya`

Catatan:

- Jika subscription masih auto-renew normal, tidak perlu email ini agar tidak membuat user bingung.
- Jika payment issue, email bisa lebih transactional; pisahkan dari marketing.

### 8. Former Plus Winback

- **Trigger:** 3 hari setelah akses Plus benar-benar berakhir.
- **Audience:** Former Plus, belum opt-out marketing.
- **Skip jika:** user subscribe lagi sebelum email dikirim.
- **Goal:** ajak kembali subscribe tanpa menyalahkan user.
- **CTA:** buka Settings billing.

Subject options:

- `Fitur Plus siap dipakai lagi kapan pun kamu butuh`
- `Kangen export, history 90 hari, dan tanpa iklan?`

Copy draft:

```text
Halo,

Akses BagiStruk Plus kamu sudah berakhir.

Kamu tetap bisa memakai BagiStruk Free, termasuk scan dengan credit bulanan Free.
Kalau nanti butuh workflow yang lebih lengkap, Plus bisa memberi:

- 60 credit scan per bulan
- tanpa iklan
- History sampai 90 hari
- export PDF/CSV
- info bank transfer di pesan settlement
- restore bill terhapus selama 30 hari

CTA: Aktifkan Plus lagi
```

### 9. Dormant Free Re-activation

- **Trigger:** Free registered user tidak aktif 21 hari, belum opt-out.
- **Skip jika:** sudah menerima inactivity cleanup reminder atau account deletion flow sudah berjalan.
- **Goal:** reactivation ringan, bukan ancaman.
- **CTA:** buka app atau panduan.

Subject options:

- `Ada struk yang belum sempat dibagi?`
- `Bagi tagihan berikutnya tanpa hitung manual`

## Campaign Yang Sebaiknya Dihindari

- Email harian atau terlalu sering.
- Subject clickbait seperti `Akun kamu bermasalah` untuk email marketing.
- Menampilkan isi struk/merchant/item tanpa consent eksplisit.
- Mengirim upgrade email ke user Plus aktif.
- Mengirim winback 3 hari setelah user menekan cancel tetapi akses Plus masih aktif sampai akhir periode. Lebih aman kirim setelah entitlement benar-benar berakhir.

## Unsubscribe Dan Preference Center

Minimal yang dibutuhkan:

- Toggle di aplikasi: **Settings > Email preferences > Product tips and offers**.
- Link unsubscribe di semua email marketing.
- One-click unsubscribe endpoint publik.
- Suppression list server-side, sehingga unsubscribe tetap berlaku meskipun email provider berubah.
- Email transactional tetap bisa dikirim untuk auth, purchase, security, dan account deletion/retention notices.

Suggested preferences:

| Preference | Default | Keterangan |
| --- | --- | --- |
| `product_updates_enabled` | true setelah registered user menerima notice/consent yang jelas | Tips, panduan, fitur baru |
| `plus_offers_enabled` | true setelah registered user menerima notice/consent yang jelas | Upgrade, winback, promo Plus |
| `transactional_enabled` | always true | Tidak bisa dimatikan dari marketing toggle |

Jika ingin lebih konservatif, default marketing ke `false` dan minta opt-in saat registrasi atau di Settings.

## Implementasi Teknis

### 1. Database Migration

Tambahkan tabel baru:

```sql
CREATE TABLE public.email_marketing_preferences (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  product_updates_enabled BOOLEAN NOT NULL DEFAULT true,
  plus_offers_enabled BOOLEAN NOT NULL DEFAULT true,
  unsubscribed_at TIMESTAMPTZ,
  unsubscribe_reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.email_campaign_deliveries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  campaign_key TEXT NOT NULL,
  step_key TEXT NOT NULL,
  provider_message_id TEXT,
  status TEXT NOT NULL CHECK (status IN ('queued', 'sent', 'skipped', 'failed')),
  skip_reason TEXT,
  sent_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  UNIQUE (user_id, campaign_key, step_key)
);

CREATE TABLE public.email_unsubscribe_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  token_hash TEXT NOT NULL UNIQUE,
  expires_at TIMESTAMPTZ,
  used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

RLS:

- user hanya bisa read/update preference miliknya,
- delivery dan token dikelola service role,
- unsubscribe endpoint memakai service role setelah token valid.

Tambahkan helper RPC:

- `get_email_campaign_candidates(p_campaign_key, p_limit)`,
- `mark_email_campaign_sent(...)`,
- `unsubscribe_email_marketing(p_token)`,
- `update_email_marketing_preferences(...)`.

### 2. Event Source

Gunakan data existing:

- `auth.users.created_at` untuk day 1/day 7.
- `profiles.email`, `profiles.language_pref`, `profiles.is_anonymous`.
- `user_entitlements.plan_code`, `status`, `current_period_end`.
- `ocr_credit_grants` dan `get_ocr_credit_status` untuk balance.
- `bills`, `participants.is_paid`, `bills.is_settled` untuk activation/settlement.
- `google_play_purchases.subscription_expires_at` untuk former Plus.

Tambahan yang direkomendasikan:

- Google Play Real-time Developer Notifications atau scheduled subscription sync agar status canceled/expired lebih akurat.
- `last_plus_ended_at` view/RPC dari `google_play_purchases` dan `user_entitlements`.

### 3. Edge Function

Buat function baru:

- `supabase/functions/email-campaign-dispatch/index.ts`
- dipanggil Supabase Cron tiap hari.
- memakai `SUPABASE_SERVICE_ROLE_KEY`.
- memakai `RESEND_API_KEY` dan sender baru, misalnya `BagiStruk <hello@your-domain>`.
- memakai `APP_URL`, `LANDING_PAGE_URL`, `EMAIL_UNSUBSCRIBE_BASE_URL`.

Flow:

1. Validasi secret header, mirip `inactive-user-cleanup`.
2. Ambil campaign candidates dari RPC.
3. Apply frequency cap.
4. Generate unsubscribe token.
5. Render subject/html/text sesuai `language_pref`.
6. Kirim via Resend.
7. Simpan delivery result.

Resend detail:

- Jika memakai Resend Broadcasts/Automations, Resend bisa mengelola unsubscribe dengan placeholder unsubscribe bawaan.
- Jika memakai Edge Function manual via `/emails`, tetap simpan suppression list sendiri dan kirim header `List-Unsubscribe` serta link unsubscribe di body.

### 4. Mobile Settings

Tambahkan menu:

**Settings > Email preferences**

Isi:

- toggle **Product tips and updates**,
- toggle **Plus offers and reminders**,
- teks kecil: email penting seperti login, reset password, purchase, dan account/security tetap dapat dikirim.

Implementation notes:

- Tambahkan field entity/profile atau provider baru untuk `EmailMarketingPreferences`.
- Panggil RPC update preference.
- Tampilkan loading/disabled state saat save.
- Jika semua toggle off, set `unsubscribed_at`.

### 5. Landing Page

Landing page perlu punya:

- section user guide yang menautkan `docs/user-guide.md` dan `docs/user-guide-en.md` versi publik,
- CTA ke app/Google Play/Testing access,
- query param UTM dari email,
- Privacy dan Terms visible di footer.

Recommended public URLs:

- English guide: `https://bagistruk.vercel.app/guide`
- Indonesian guide: `https://bagistruk.vercel.app/id/guide`
- Upgrade CTA: `bagistruk://settings?section=billing` jika deep link sudah didukung, fallback ke landing page pricing.

### 6. Privacy Policy Dan Terms

Saat email marketing benar-benar diaktifkan, update legal docs:

- data yang dikumpulkan: email marketing preferences, delivery events, unsubscribe timestamp, campaign engagement metadata jika dipakai,
- penggunaan data: product tips, feature education, Plus offers, retention/winback,
- third-party service: Resend/email provider untuk campaign, bukan hanya inactivity reminder,
- unsubscribe: user bisa opt-out dari Settings dan link email.

## Candidate Query Examples

Welcome day 1:

```sql
SELECT u.id AS user_id, u.email, p.language_pref
FROM auth.users u
JOIN public.profiles p ON p.id = u.id
LEFT JOIN public.user_entitlements e ON e.user_id = u.id
LEFT JOIN public.email_marketing_preferences pref ON pref.user_id = u.id
WHERE u.email IS NOT NULL
  AND COALESCE(p.is_anonymous, FALSE) = FALSE
  AND COALESCE(e.plan_code, 'free') = 'free'
  AND COALESCE(pref.product_updates_enabled, TRUE) = TRUE
  AND u.created_at <= NOW() - INTERVAL '1 day'
  AND NOT EXISTS (
    SELECT 1 FROM public.email_campaign_deliveries d
    WHERE d.user_id = u.id
      AND d.campaign_key = 'free_onboarding'
      AND d.step_key = 'welcome_day1'
      AND d.status = 'sent'
  );
```

Former Plus D+3:

```sql
SELECT u.id AS user_id, u.email, p.language_pref
FROM auth.users u
JOIN public.profiles p ON p.id = u.id
JOIN public.google_play_purchases gpp ON gpp.user_id = u.id
LEFT JOIN public.user_entitlements e ON e.user_id = u.id
LEFT JOIN public.email_marketing_preferences pref ON pref.user_id = u.id
WHERE u.email IS NOT NULL
  AND gpp.product_type = 'subscription'
  AND gpp.subscription_expires_at <= NOW() - INTERVAL '3 days'
  AND COALESCE(e.plan_code, 'free') <> 'plus'
  AND COALESCE(pref.plus_offers_enabled, TRUE) = TRUE
  AND NOT EXISTS (
    SELECT 1 FROM public.email_campaign_deliveries d
    WHERE d.user_id = u.id
      AND d.campaign_key = 'plus_winback'
      AND d.step_key = 'former_plus_d3'
      AND d.status = 'sent'
  );
```

## Metrics

Track:

- sent count,
- skipped count by reason,
- failure rate,
- unsubscribe rate per campaign,
- click rate per CTA if UTM/click tracking exists,
- upgrade conversion within 7/14/30 days,
- resubscribe conversion for former Plus,
- Plus retention/renewal rate.

Do not optimize only for opens. Better success metric:

- Free: first saved bill, second scan, upgrade, top-up credit.
- Plus: use of export, bank info, monthly insight, renewal.
- Former Plus: resubscribe.

## Implementation Phases

### Phase 1 - Safe Foundation

- Add DB preferences/deliveries/tokens.
- Add Settings email preferences.
- Add unsubscribe endpoint.
- Update Privacy Policy/Terms.
- No marketing sends yet.

### Phase 2 - Onboarding Campaign

- Ship welcome day 1.
- Ship day 7 education.
- Low volume, monitor deliverability.

### Phase 3 - Plus Conversion

- Low credit nudge.
- First settlement follow-up.
- Plus feature education after upgrade.

### Phase 4 - Retention And Winback

- Monthly Plus value recap.
- Former Plus D+3 winback.
- Add subscription sync/RTDN before relying on cancellation timing.

## Compliance Checklist

- From/reply-to identifies BagiStruk clearly.
- Subject matches email content.
- Every marketing email includes unsubscribe.
- Unsubscribe is processed immediately in app DB; operationally no later than required by applicable law.
- Physical mailing address or legally acceptable sender address is included before public production campaigns.
- Transactional email templates are separated from marketing email templates.
- Privacy Policy and Terms updated before sending marketing.
- No purchased/imported email lists.
- Suppression list checked before every send.
- Frequency cap enforced.

## Sources To Review Before Launch

- FTC CAN-SPAM business guide: https://www.ftc.gov/business-guidance/resources/can-spam-act-compliance-guide-business
- Resend unsubscribe guidance: https://resend.com/docs/knowledge-base/should-i-add-an-unsubscribe-link
