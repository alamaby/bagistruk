# Supabase CLI Token Helper Plan

Created: 2026-09-21 17:43:17

## Objective

Sediakan `scripts/supabase-with-token.ps1` di repo induk bagistruk — port 1:1 dari sibling bikinstiker — agar `supabase db push` dan `functions deploy` bisa dijalankan tanpa export manual `SUPABASE_ACCESS_TOKEN`, dengan token dibaca dari `.env.local` (gitignored) dan tidak pernah tercetak ke log.

## Scope

- Buat `scripts/supabase-with-token.ps1` (port dari bikinstiker, contoh usage ke `process-receipt`)
- Tambah blok placeholder `SUPABASE_ACCESS_TOKEN` di `.env.example`
- Update `CLAUDE.md` § Common commands + gotcha keamanan token
- Tidak menyentuh submodule `supabase/`, tidak menambah versi `.sh`, tidak mengubah workflow CI

## Milestones

1. Script helper dibuat dan lolos parse-check
2. `.env.example` + `CLAUDE.md` terupdate
3. Verifikasi `--DryRun` hijau, plan + memory tercatat

## Tasks

- [x] Buat `scripts/supabase-with-token.ps1` (port 1:1, contoh usage `db push` + `functions deploy process-receipt`)
- [x] Tambah blok `SUPABASE_ACCESS_TOKEN` placeholder ke `.env.example`
- [x] Update `CLAUDE.md` Common commands + gotcha token
- [x] Verifikasi: parse-check PS1 + `--DryRun` untuk `db push` dan `functions deploy process-receipt`

## Risks

- Bagistruk tidak punya `config.toml` di submodule (bikinstiker punya), jadi `db push` bergantung pada `supabase link` yang sudah dilakukan operator sebelumnya. Helper tidak memperbaiki itu — prasyarat dicatat, bukan dipecahkan script. Auto-`link --project-ref` sengaja tidak ditambah (butuh DB password, menambah surface secret).
- `.env.local` asli tidak dibaca (Env Guard). Verifikasi hanya via `--DryRun`: dengan `.env.local` asli hasilnya error "kosong/hilang" → operator perlu mengisi `SUPABASE_ACCESS_TOKEN=sbp_...` secara manual. Logika parsing terbukti OK via file dummy di temp dir (26 chars, redacted, exit 0 untuk kedua perintah).
- Temuan di luar scope: `CLAUDE.md` mereferensikan `./smoketest.sh` yang tidak ada di repo (glob `smoketest.*` kosong). Ditindaklanjuti terpisah.

## Progress Log

- 2026-09-21 17:43:17 — Semua tasks selesai: script dibuat (164 baris, port 1:1), `.env.example` +7 baris, `CLAUDE.md` commands + gotcha. Parse-check OK, CLI ditemukan di PATH, DryRun hijau via file dummy. Ter-commit via `chore: add supabase CLI token helper script` (hanya 5 file: script, `.env.example`, plan ini, memory entry + index; `CLAUDE.md` di working tree berstatus untracked sejak awal — tidak ikut di-commit, keputusan terpisah).

## Notes

- Commit di repo induk saja (`scripts/`, `.env.example`, `CLAUDE.md`); tidak ada bump pointer submodule.
- Standar domain (C2M/TM Forum/TOGAF) tidak relevan — helper ops rutin tanpa perubahan arsitektur/skema.
- Contoh pakai:
  ```powershell
  & "scripts/supabase-with-token.ps1" db push
  & "scripts/supabase-with-token.ps1" functions deploy process-receipt
  & "scripts/supabase-with-token.ps1" --DryRun functions deploy process-receipt
  ```
