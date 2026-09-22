# Landing publishable-key migration (`VITE_SUPABASE_ANON_KEY` → `sb_publishable_…`)

Created: 2026-09-22 00:00:00

## Objective

Ganti nilai `VITE_SUPABASE_ANON_KEY` di Vercel (landing `bagistruk-landing-page`,
Production) dari legacy JWT anon key ke publishable key (`sb_publishable_…`),
lalu redeploy dan verifikasi halaman share `/s/<token>` kembali me-render
rincian bill (bukan "Could not load the bill").

Latar: link `/s/1ca8…` menampilkan status `error` di `ShareBillPage`
("Could not load the bill" + tombol "Try again"), yang menurut kode hanya
terjadi bila Supabase client null (env hilang/placeholder) atau RPC melempar
exception — bukan bila token invalid (itu jatuh ke UI "expired"). Grant live
`resolve_share_token` untuk `anon` sudah terverifikasi ada. Migrasi ini juga
menjawab deprecation legacy keys Supabase (akhir 2026).

## Scope

- In-scope:
  - Env Vercel Production landing: `VITE_SUPABASE_URL` (pastikan persis
    `https://cxgllbkbcwnqlyjoshsb.supabase.co`) dan `VITE_SUPABASE_ANON_KEY`
    (nilai diganti ke publishable key). Nama variabel TIDAK berubah.
  - Redeploy production landing (wajib — Vite menanam env saat build).
  - Verifikasi via DevTools (Network + Console) dan uji ulang di HP.
- Out-of-scope (JANGAN disentuh):
  - Kode landing (`supabase.ts`, `ShareBillPage.tsx`, `App.tsx`) — tidak ada
    perubahan kode yang dibutuhkan (drop-in, sudah dikonfirmasi di docs).
  - App Flutter (`SUPABASE_ANON_KEY` di `.env`, `Env`, `main.dart`) — tetap
    memakai legacy anon key sampai rencana migrasi terpisah.
  - Dashboard → JANGAN disable/delete legacy anon key (keputusan: tetap aktif).
  - Migration/submodule Supabase — tidak ada perubahan DB.
  - Secret key (`sb_secret_…`) — tidak dibutuhkan di client; jangan dibuat /
    jangan dipakai di sini.

## Milestones

1. Siapkan publishable key di Dashboard (manual, tanpa menyentuh nilai key di chat/file).
2. Tukar env Vercel Production + redeploy.
3. Verifikasi hijau di desktop (DevTools) dan di HP (kasus asli).
4. Tutup: catat hasil di Progress Log (+ memory entry bila alur tim menghendaki).

## Tasks

- [ ] M1 — Siapkan key (Dashboard Supabase, manual):
  - [ ] Buka Settings → API Keys → tab *Publishable and secret API keys*.
  - [ ] Jika belum ada key: *Create new API keys* (aman — legacy keys tetap jalan).
  - [ ] Copy nilai publishable key (`sb_publishable_…`) SEKALI ke password
    manager. JANGAN paste ke chat, markdown, kode, `.env.example`, atau file
    apa pun yang ter-commit.
- [ ] M2 — Tukar env + redeploy (Vercel Dashboard, manual):
  - [ ] Project landing → Settings → Environment Variables → Production:
    `VITE_SUPABASE_URL` = `https://cxgllbkbcwnqlyjoshsb.supabase.co` (persis,
    tanpa trailing slash).
  - [ ] Production: `VITE_SUPABASE_ANON_KEY` = nilai publishable key dari M1.
    (Nama variabel dipertahankan; `lib/supabase.ts` tidak diubah.)
  - [ ] Trigger redeploy Production (env Vite hanya berlaku setelah build
    ulang — ganti env tanpa redeploy TIDAK berpengaruh).
- [ ] M3 — Verifikasi desktop (Chrome + DevTools):
  - [ ] Buka link share (buat link FRESH dari app bila link lama sudah
    lewat/ter-rotate), buka DevTools → Network, filter `resolve_share_token`.
  - [ ] Harapan: `POST .../rest/v1/rpc/resolve_share_token` status 200,
    body JSON berisi `bill`/`items`/`participants`/`assignments`/`expires_at`;
    halaman me-render rincian (bukan error/expired). Console bersih dari
    `Failed to fetch` dan `crypto.subtle`.
  - [ ] Jika masih "Could not load the bill": lihat Console — `Failed to
    fetch`/CORS = jaringan/project; `crypto.subtle` = WebView lama;
    tidak ada request sama sekali = env belum masuk build (ulangi M2 +
    pastikan redeploy dari commit terbaru).
  - [ ] Jika muncul "This link is expired or invalid" (status `expired`,
    BUKAN `error`): itu masalah token (rotate/kuota/expiry), bukan key —
    buat link fresh dari app dan ulangi.
- [ ] M4 — Verifikasi HP (kasus asli) + close-out:
  - [ ] Buka link yang sama di HP yang kemarin gagal → rincian tampil.
  - [ ] Pastikan: tidak ada secret yang masuk repo (`git status` bersih untuk
    tracked paths; tidak ada file `.env*` baru ter-stage), legacy anon key
    masih enabled di Dashboard, app Flutter tidak diubah.
  - [ ] Isi Progress Log di bawah dengan hasil (tanggal, status tiap
    milestone, sisa temuan bila ada).

## Risks

- **Env diganti tapi tidak redeploy** → build lama (env lama) tetap tayang,
  error berlanjut. Mitigasi: redeploy adalah langkah wajib M2; verifikasi
  dengan cek build time/commit di Vercel deployment.
- **Salah project (URL/key dari project lain)** → RPC 200 + `null` (UI
  "expired") atau 401. Mitigasi: URL harus persis dari MCP
  (`cxgllbkbcwnqlyjoshsb`); key diambil dari project yang sama.
- **Godaan disable legacy anon key** → tolak. App Flutter masih memakainya
  (`lib/core/config/env.dart`, `lib/main.dart`); mematikannya akan memutus
  auth + Edge Function di app. Keputusan tercatat: tetap aktif.
- **Godaan "sekalian" migrasi Flutter** → tolak di plan ini. Kompatibilitas
  `supabase_flutter 2.12.4` / `gotrue 2.20` terhadap key non-JWT belum
  divalidasi (khususnya path Edge Function `process-receipt` yang memakai
  verifikasi JWT). Satu plan = landing saja.
- **Key bocor ke chat/log/file** → rotasi segera di Dashboard bila terjadi.
  Aturan: nilai key hanya hidup di Dashboard ↔ Vercel ↔ password manager.
- Counter-argumen: kenapa tidak ganti nama variabel env sekalian (mis.
  `VITE_SUPABASE_PUBLISHABLE_KEY`)? Karena butuh perubahan kode + redeploy
  yang sama, tanpa manfaat fungsional; nama lama dipertahankan agar diff nol.

## Progress Log

- 2026-09-22 00:00:00 — Plan dibuat (validasi MCP: project URL live,
  grant `resolve_share_token` untuk `anon` ada, `@supabase/supabase-js
  ^2.108.2` kompatibel; docs: publishable = drop-in anon, keys berjalan
  bersamaan, anon tetap aktif). Scope diputuskan: landing saja. Belum ada
  perubahan dilakukan.
- 2026-09-22 08:45:00 — Audit kesiapan pra-manual: (1) Publishable key
  sudah ada di project (`sb_publishable_...`, `disabled: false`, id
  `864f433d`); legacy anon tetap aktif. (2) Lokal `landing/.env.local`
  sudah terisi kedua variabel dengan nilai benar (`VITE_SUPABASE_URL` +
  `VITE_SUPABASE_ANON_KEY=publishable`). (3) `vite build --mode
  production` hijau di `bagistruk-landing-page`. (4) Vercel CLI belum
  ter-auth (no credentials found) — M2 (swap env + redeploy) HARUS
  dilakukan manual via Vercel Dashboard. (5) Tidak ada perubahan kode
  yang dibutuhkan; `vercel.json` punya unstaged diff pre-existing
  (`/((?!api/).*)`) tidak terkait plan ini. M1 selesai (di luar sesi),
  M2 tertahan blocker: akses Vercel Dashboard. M3/M4 pending redeploy.

## Notes

- Fakta terverifikasi (jangan diverifikasi ulang kecuali ada anomali):
  - Project URL: `https://cxgllbkbcwnqlyjoshsb.supabase.co`.
  - Grant live: `resolve_share_token` → `EXECUTE` untuk `anon`,
    `authenticated` (+ `postgres`, `service_role`).
  - Landing: `@supabase/supabase-js ^2.108.2`; client `persistSession:
    false`; hanya panggil PostgREST RPC (bukan Edge Function), jadi
    batasan "Edge Functions only support JWT verification" tidak berlaku.
  - UI mapping (`ShareBillPage.tsx:292-301`): `error/null-client/throw` →
    "Could not load the bill"; `error-object/null-data` → "expired";
    token malformed → "invalid".
- Standar domain: bukan proyek telecom — tidak ada deviasi C2M/TM Forum ODA
  yang perlu dijustifikasi.
