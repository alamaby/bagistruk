# Privacy Policy — BagiStruk

**Effective date:** 2026-05-30

This policy explains how BagiStruk collects, uses, stores, and deletes data. This document is provided for product transparency and should be reviewed for legal compliance before publication.

## Summary

BagiStruk is a split-bill app that helps users scan receipts, extract bill items with OCR, and divide payments among participants. We collect only the data needed to provide these features. We do not sell personal data. If ads are enabled, we use Google Mobile Ads / AdMob to show ads and measure ad performance.

## Data We Collect

- Account data: email address, authentication identifiers, and sign-in provider information when you create or use an account.
- Anonymous session data: an anonymous Supabase user ID may be created when you use features that require saving data.
- Google Sign-In data: when you sign in with Google, we receive authentication tokens from Google through Supabase Auth. We do not receive your Google password.
- Profile preferences: display name, default currency, language preference, and theme preference.
- App activity metadata: `last_active_at`, used to understand when an account was last active and to support inactivity cleanup.
- Receipt photos: images you choose or capture for OCR processing.
- Bill data: merchant names, receipt dates, items, quantities, prices, taxes, service charges, participants, split assignments, and settlement status.
- OCR credit data: plan/entitlement status, monthly credit grants, credit usage, and audit records needed to enforce scan limits.
- Google Play Billing data when purchases are available: product IDs, purchase tokens, order IDs, subscription status/expiry, and verification responses needed to grant Plus access or OCR credit packs.
- Support and reminder data: email address and inactivity reminder timestamps when reminders are sent.
- Basic technical data sent by app/framework/network services, such as device and request metadata needed for diagnostics and security. For anonymous anti-abuse, we may store a server-side HMAC hash derived from coarse request signals; we do not store the raw IP address or raw device fingerprint for this purpose.
- Advertising data when ads are enabled: advertising identifiers such as the Android Advertising ID, device/ad interaction data, approximate location inferred by ad services, and consent status used by Google Mobile Ads / AdMob for ad delivery, frequency capping, fraud prevention, and measurement.

## Permissions Used

- **Camera**: to capture receipt photos.
- **Photos / media access**: to pick receipt photos from the gallery.
- **Internet / network state**: to communicate with Supabase and OCR services.

## How We Use Data

- To authenticate users and keep sessions active.
- To process receipt photos and extract bill information.
- To save, display, edit, split, and settle bills.
- To preserve anonymous data when a user upgrades to a registered account.
- To enforce OCR credit limits, including anonymous, free, and Plus plan limits.
- To verify Google Play purchases server-side and grant Plus subscriptions or one-time OCR credit packs.
- To store user preferences and personalize the app.
- To track last activity for account retention and cleanup.
- To send inactivity reminders to registered users before account cleanup.
- To show ads, measure ad performance, prevent ad fraud, and respect consent choices when ads are enabled.
- To diagnose errors, prevent abuse, and enforce database rate limits.

## Storage And Processing

App data is stored in Supabase, including authentication data and PostgreSQL database records. Receipt images are processed by Supabase Edge Functions. OCR processing may call third-party AI/OCR providers such as Google Gemini and OpenRouter. API keys for those providers are stored server-side and are not bundled into the mobile app.

## Third-Party Services

BagiStruk may use:

- Supabase: authentication, database, row-level security, Edge Functions, and scheduled cleanup.
- Google Sign-In: optional account login.
- Google Gemini and/or OpenRouter: OCR and receipt parsing.
- Resend or another email provider: inactivity reminder emails, if configured.
- Google Mobile Ads / AdMob: optional ad delivery, ad measurement, fraud prevention, and consent/privacy messaging.
- Google Play Billing / Google Play Developer API: purchase processing and server-side purchase verification for subscriptions and one-time OCR credit packs.

## Account Retention And Deletion

- Anonymous users may be deleted after 30 days of inactivity.
- Registered users may receive an inactivity reminder after 6 months of inactivity.
- If a registered user remains inactive for 30 days after the reminder, the account may be deleted.
- When an inactive user is deleted, bills owned by that user are deleted first, then the authentication user is deleted.
- If a user opens the app after receiving a reminder, the pending deletion state is reset.
- You can delete your account and associated app data from **Profile & Settings > Delete Account** in the app.

You may also request account and data deletion by contacting us at the email below or through the public privacy page: https://bagistruk.vercel.app/privacy

## Security

We rely on Supabase authentication, row-level security, server-side API keys, and database policies to protect user data. No system is perfectly secure, but we take reasonable steps to limit access and reduce exposure.

## Children

BagiStruk is not intended for children under the age required by applicable law to consent to digital services. If you believe a child has provided personal data, contact us so we can review and delete it.

## Changes

We may update this policy from time to time. The latest version should be made available in the app and on the public page hosting this document.

## Contact

For privacy questions or deletion requests, contact: **alam.aby.b@gmail.com**

---

# Kebijakan Privasi — BagiStruk

**Tanggal berlaku:** 2026-05-30

Kebijakan ini menjelaskan bagaimana BagiStruk mengumpulkan, menggunakan, menyimpan, dan menghapus data. Dokumen ini disediakan untuk transparansi produk dan sebaiknya ditinjau kembali untuk kepatuhan hukum sebelum dipublikasikan.

## Ringkasan

BagiStruk adalah aplikasi pembagi tagihan yang membantu pengguna memindai struk, mengekstrak item tagihan dengan OCR, dan membagi pembayaran antar peserta. Kami hanya mengumpulkan data yang diperlukan agar fitur aplikasi berjalan. Kami tidak menjual data pribadi. Jika iklan diaktifkan, kami memakai Google Mobile Ads / AdMob untuk menampilkan iklan dan mengukur performa iklan.

## Data Yang Kami Kumpulkan

- Data akun: alamat email, identifier autentikasi, dan informasi penyedia login saat Anda membuat atau menggunakan akun.
- Data sesi anonim: ID pengguna anonim Supabase dapat dibuat saat Anda memakai fitur yang perlu menyimpan data.
- Data Google Sign-In: saat Anda login dengan Google, kami menerima token autentikasi melalui Supabase Auth. Kami tidak menerima password Google Anda.
- Preferensi profil: nama tampilan, mata uang default, bahasa, dan tema.
- Metadata aktivitas aplikasi: `last_active_at`, digunakan untuk mengetahui kapan akun terakhir aktif dan mendukung pembersihan akun tidak aktif.
- Foto struk: gambar yang Anda pilih atau ambil untuk pemrosesan OCR.
- Data tagihan: nama merchant, tanggal struk, item, jumlah, harga, pajak, service, peserta, pembagian item, dan status pembayaran.
- Data credit OCR: status plan/entitlement, grant credit bulanan, penggunaan credit, dan audit yang dibutuhkan untuk menerapkan batas scan.
- Data Google Play Billing saat pembelian tersedia: product ID, purchase token, order ID, status/expiry subscription, dan respons verifikasi yang dibutuhkan untuk memberi akses Plus atau paket credit OCR.
- Data dukungan dan reminder: alamat email dan timestamp reminder tidak aktif saat reminder dikirim.
- Data teknis dasar dari app/framework/network service, seperti metadata perangkat dan request yang dibutuhkan untuk diagnostik dan keamanan. Untuk anti-abuse pengguna anonim, kami dapat menyimpan hash HMAC sisi server yang diturunkan dari sinyal request terbatas; kami tidak menyimpan alamat IP mentah atau fingerprint perangkat mentah untuk tujuan ini.
- Data iklan saat iklan diaktifkan: identifier iklan seperti Android Advertising ID, data perangkat/interaksi iklan, perkiraan lokasi yang disimpulkan layanan iklan, dan status consent yang digunakan Google Mobile Ads / AdMob untuk penayangan iklan, pembatasan frekuensi, pencegahan fraud, dan pengukuran.

## Izin Yang Digunakan

- **Kamera**: untuk mengambil foto struk.
- **Akses foto / media**: untuk memilih foto struk dari galeri.
- **Internet / status jaringan**: untuk berkomunikasi dengan Supabase dan layanan OCR.

## Cara Kami Menggunakan Data

- Mengautentikasi pengguna dan menjaga sesi tetap aktif.
- Memproses foto struk dan mengekstrak informasi tagihan.
- Menyimpan, menampilkan, mengedit, membagi, dan menyelesaikan tagihan.
- Mempertahankan data anonim saat pengguna upgrade ke akun terdaftar.
- Menerapkan batas credit OCR, termasuk batas untuk pengguna anonim, Free, dan Plus.
- Memverifikasi pembelian Google Play dari sisi server dan memberi subscription Plus atau paket credit OCR sekali beli.
- Menyimpan preferensi pengguna dan menyesuaikan pengalaman aplikasi.
- Melacak aktivitas terakhir untuk retensi dan pembersihan akun.
- Mengirim reminder tidak aktif kepada pengguna terdaftar sebelum pembersihan akun.
- Menampilkan iklan, mengukur performa iklan, mencegah fraud iklan, dan menghormati pilihan consent saat iklan diaktifkan.
- Mendiagnosis error, mencegah penyalahgunaan, dan menerapkan rate limit database.

## Penyimpanan Dan Pemrosesan

Data aplikasi disimpan di Supabase, termasuk data autentikasi dan record database PostgreSQL. Foto struk diproses oleh Supabase Edge Functions. Pemrosesan OCR dapat memanggil penyedia AI/OCR pihak ketiga seperti Google Gemini dan OpenRouter. API key untuk layanan tersebut disimpan di sisi server dan tidak dibundel ke aplikasi mobile.

## Layanan Pihak Ketiga

BagiStruk dapat menggunakan:

- Supabase: autentikasi, database, row-level security, Edge Functions, dan scheduled cleanup.
- Google Sign-In: login akun opsional.
- Google Gemini dan/atau OpenRouter: OCR dan parsing struk.
- Resend atau penyedia email lain: email reminder tidak aktif, jika dikonfigurasi.
- Google Mobile Ads / AdMob: penayangan iklan opsional, pengukuran iklan, pencegahan fraud, dan pesan consent/privasi.
- Google Play Billing / Google Play Developer API: pemrosesan pembelian dan verifikasi pembelian sisi server untuk subscription dan paket credit OCR sekali beli.

## Retensi Dan Penghapusan Akun

- Pengguna anonim dapat dihapus setelah 30 hari tidak aktif.
- Pengguna terdaftar dapat menerima reminder setelah 6 bulan tidak aktif.
- Jika pengguna terdaftar tetap tidak aktif selama 30 hari setelah reminder, akun dapat dihapus.
- Saat pengguna tidak aktif dihapus, bill milik pengguna dihapus terlebih dahulu, lalu user autentikasi dihapus.
- Jika pengguna membuka aplikasi setelah menerima reminder, jadwal penghapusan akan direset.
- Anda dapat menghapus akun dan data aplikasi terkait dari **Profil & Pengaturan > Hapus Akun** di dalam aplikasi.

Anda juga dapat meminta penghapusan akun dan data dengan menghubungi email di bawah atau melalui halaman privacy publik: https://bagistruk.vercel.app/privacy

## Keamanan

Kami menggunakan autentikasi Supabase, row-level security, API key sisi server, dan policy database untuk melindungi data pengguna. Tidak ada sistem yang sepenuhnya aman, tetapi kami mengambil langkah wajar untuk membatasi akses dan mengurangi risiko.

## Anak-Anak

BagiStruk tidak ditujukan untuk anak di bawah usia yang diwajibkan hukum untuk memberikan persetujuan layanan digital. Jika Anda yakin seorang anak memberikan data pribadi, hubungi kami agar dapat ditinjau dan dihapus.

## Perubahan

Kami dapat memperbarui kebijakan ini dari waktu ke waktu. Versi terbaru sebaiknya tersedia di aplikasi dan halaman publik yang menghosting dokumen ini.

## Kontak

Pertanyaan privasi atau permintaan penghapusan data: **alam.aby.b@gmail.com**
