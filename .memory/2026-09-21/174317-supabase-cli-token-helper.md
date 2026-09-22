# Supabase CLI Token Helper

- **Date:** 2026-09-21 17:43
- **Task:** buatkan script helper `supabase db push` + deploy Edge Function memakai `SUPABASE_ACCESS_TOKEN` dari `.env.local`, meniru sibling bikinstiker.
- **Key files changed:**
  - `scripts/supabase-with-token.ps1` (baru, 164 baris — port 1:1 dari `bikinstiker/scripts/supabase-with-token.ps1`, contoh usage disesuaikan ke `process-receipt`)
  - `.env.example` (+7 baris: blok placeholder `SUPABASE_ACCESS_TOKEN=sbp_...placeholder...` + komentar HANYA-di-`.env.local`)
  - `CLAUDE.md` (Common commands → via helper; gotcha baru: token hanya di `.env.local`, `pubspec.yaml` bundles `.env` ke APK/AAB)
  - `plans/2026-09-21-supabase-cli-token-helper-plan.md` (plan file per AGENTS.md §7)
- **Decisions:** lokasi `scripts/` repo induk (bukan submodule — tidak perlu bump pointer); cakupan script+env+docs; PS1 saja tanpa versi `.sh`. Tidak ada auto-`supabase link` (butuh DB password, menambah surface secret). Placeholder tetap lolos Zod-style guard secara konseptual (`sbp_` prefix) tapi jelas fake.
- **Assumptions/risks:** `.gitignore` sudah mengabaikan `.env`/`.env.local` (terverifikasi baris 113–116); `supabase/` submodule punya `functions/`+`migrations/` langsung di root jadi CLI dari repo root bekerja. Bagistruk tanpa `config.toml` → `db push` butuh `supabase link` manual oleh operator. Isi `.env.local` asli TIDAK dibaca/diverifikasi (Env Guard) — DryRun asli gagal "kosong/hilang", operator harus isi manual.
- **Blockers/unresolved:** di-commit via `chore: add supabase CLI token helper script` (5 file; `CLAUDE.md` tidak ikut karena untracked sejak awal — lihat Recent Entries di `.memory/README.md`). Eksekusi penuh (`db push`/`deploy` sungguhan) wewenang operator.
- **Verification:** PowerShell `ParseFile` → PARSE-OK (0 errors); `supabase` CLI ada di PATH; `--DryRun db push` dan `--DryRun functions deploy process-receipt` → exit 0, "token loaded (26 chars, redacted)", via file dummy di temp dir (dihapus setelahnya). Tidak ada nilai token di output.
- **Commit proposal:** `chore: add supabase CLI token helper script`
