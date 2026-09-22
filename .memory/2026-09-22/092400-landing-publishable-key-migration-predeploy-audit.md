# Landing publishable-key migration — pra-deploy audit

- **Task:** Lanjutkan `plans/2026-09-22-landing-publishable-key-migration-plan.md` (M1–M4).
- **Key files:** `plans/2026-09-22-landing-publishable-key-migration-plan.md`; sibling repo `C:\Works\github.com\alamaby\bagistruk-landing-page\.env.local`.
- **Technical decisions:**
  - M1 sudah selesai di luar sesi ini: publishable key sudah dibuat di Supabase Dashboard (`sb_publishable_...`, id `864f433d`, `disabled: false`). Legacy anon tetap aktif.
  - Lokal `.env.local` landing sudah terisi dua variabel dengan nilai benar (di-set operator, bukan agen).
  - Vercel CLI belum ter-auth di mesin ini → M2 (swap env + redeploy) HARUS manual via Vercel Dashboard.
  - Tidak ada perubahan kode yang dibutuhkan; `supabase.ts` pakai nama variabel lama (`VITE_SUPABASE_ANON_KEY`) sebagai drop-in.
  - `vite build --mode production` di landing hijau.
- **Assumptions/risks:** Redeploy dari Vercel Dashboard wajib dilakukan sebelum M3/M4 bisa divalidasi. Tanpa redeploy, build lama (legacy key) tetap tayang.
- **Blockers:** Akses Vercel Dashboard (M2). CLI tidak ter-login, tidak ada token yang tersimpan di `.vercel*`.
- **Verification performed atau direkomendasikan:** Jalankan M2 manual → redeploy → buka `/s/<fresh-token>` di Chrome DevTools + HP → cek Network (200 RPC) dan Console (bersih).
- **One-line commit proposal:** N/A (plan ini operasi operasional, bukan kode yang di-commit).
- **Related plans/issues:** [plan](../../plans/2026-09-22-landing-publishable-key-migration-plan.md).
