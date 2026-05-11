# Privacy Policy — BagiStruk

**Effective date:** 2026-05-10

This document is also available in-app from **Settings → About → Privacy Policy**. Host this file publicly (e.g. GitHub Pages) and submit the URL to Play Console under **App content → Privacy policy**.

---

## Summary

BagiStruk is a split-bill app that scans receipts using OCR. We only collect data necessary for the app to function, and we do not sell user data to third parties.

## Data Collected

- Email and auth credentials (when you sign up or sign in).
- Participant names you enter for each bill.
- Receipt photos you upload for OCR processing.
- Bill contents: items, prices, taxes, service charges, split history.
- Basic device info automatically sent by the framework (OS version, device model) for diagnostics.

## Permissions Used

- **CAMERA** — to capture receipt photos via image_picker.
- **READ_MEDIA_IMAGES** — to pick receipt photos from the gallery.
- **INTERNET / ACCESS_NETWORK_STATE** — for Supabase backend communication.

## Storage & Processing

Data is stored in Supabase (managed PostgreSQL and object storage). Receipt photos are processed by Supabase Edge Functions that call third-party OCR services (Google Gemini and/or OpenRouter). API keys for those services live only on the server side and are never bundled into the client app.

## Third Parties

- Supabase (authentication, database, storage).
- OCR providers (Google Gemini / OpenRouter) for receipt image processing.

We do not use third-party analytics or advertising SDKs.

## User Rights

You may delete your account and all associated data at any time by contacting the support email below. For anonymous users, data is only kept while the device session is active.

## Policy Changes

This policy may be updated from time to time. The latest version is always available in the app and at the public URL hosting this document.

## Contact

For privacy questions or requests: **alam.aby.b@gmail.com**

---

## Versi Bahasa Indonesia

### Ringkasan

BagiStruk adalah aplikasi pembagi tagihan (split bill) yang memindai struk menggunakan OCR. Kami hanya mengumpulkan data yang diperlukan agar fitur aplikasi berfungsi dan tidak menjual data pengguna kepada pihak ketiga.

### Data yang Dikumpulkan

- Email dan kredensial autentikasi (saat Anda mendaftar atau login).
- Nama peserta yang Anda masukkan untuk setiap tagihan.
- Foto struk yang Anda unggah untuk diproses OCR.
- Isi tagihan: item, harga, pajak, service, riwayat pembagian.
- Informasi perangkat dasar (versi OS, model perangkat) untuk diagnostik.

### Izin yang Dipakai

- **KAMERA** — untuk memotret struk via image_picker.
- **READ_MEDIA_IMAGES** — untuk memilih foto struk dari galeri.
- **INTERNET / ACCESS_NETWORK_STATE** — untuk komunikasi dengan backend Supabase.

### Penyimpanan & Pemrosesan

Data disimpan di Supabase (database PostgreSQL terkelola dan storage objek). Foto struk diproses oleh Supabase Edge Functions yang memanggil layanan OCR pihak ketiga (Google Gemini dan/atau OpenRouter). API key untuk layanan tersebut hanya berada di sisi server dan tidak pernah didistribusikan dalam aplikasi klien.

### Pihak Ketiga

- Supabase (autentikasi, database, storage).
- Penyedia OCR (Google Gemini / OpenRouter) untuk memproses gambar struk.

Kami tidak menggunakan SDK analitik atau iklan pihak ketiga.

### Hak Pengguna

Anda dapat menghapus akun dan seluruh data terkait kapan saja dengan menghubungi kontak dukungan di atas. Untuk pengguna anonim, data hanya tersimpan selama sesi perangkat aktif.

### Kontak

Pertanyaan atau permintaan terkait privasi: **alam.aby.b@gmail.com**
