# LLM Schema-Mismatch Validator Fix Plan

Created: 2026-09-15 15:30:00

## Objective

Hilangkan false-positive `422 schema_error / schema_mismatch` pada Edge Function `process-receipt` untuk mata uang zero-decimal (IDR dkk.) ketika LLM mengembalikan monetary string dengan thousand-separator koma (kasus `request_id 119b813b-...`: `"price": "25,000"`), tanpa meloloskan string sampah menjadi `0`.

Akar masalah: gate `isOcrPayload()` → `isNumberOrNumericString()` memakai `Number("25,000") = NaN` sehingga menolak, padahal parser hilir `toNumber()` / `parseZeroDecimalString()` sudah menangani pola `^\d{1,3}(,\d{3})+$` → `25000`. Validator lebih ketat dari parser.

## Scope

- In: `supabase/functions/process-receipt/zero_decimal.ts` (baru, shared helper), `index.ts`, `discount_resolver.ts`, `receipt_total_resolver.ts`, `zero_decimal_test.ts` (baru).
- Out: tidak ada migrasi DB, tidak ada perubahan skema `llm_configs`/`llm_logs`, tidak ada perubahan client Flutter, tidak ada rotasi key/model, tidak ada perubahan prompt text.

## Milestones

1. Reproduksi + karakterisasi bug
2. Fix validator (locale-aware) + ekstrak shared helper
3. Test + deploy Edge Function
4. Verifikasi produksi via `llm_logs`

## Tasks

- [x] Analisa `119b813b-...` (2 attempt, failover by-design sukses, bill `bfe7799c-...` benar)
- [x] Buat `zero_decimal.ts`: `ZERO_DECIMAL_CURRENCIES` + `parseZeroDecimalString` + `toNumber` + `isNumberOrNumericString(v, currency)` locale-aware + guard anti-sampah
- [x] `index.ts`: hapus duplikat, import shared; `isOcrPayload(value, currency)` teruskan currency di 3 call-site (`callGemini`, `callOpenAICompatible`, `callOllama`)
- [x] `discount_resolver.ts` + `receipt_total_resolver.ts`: hapus duplikat Set/parser, import shared (`toNumber` di-re-export dari `discount_resolver.ts` untuk kompatibilitas)
- [x] `zero_decimal_test.ts`: regresi `"25,000"` + matriks terima/tolak + round-trip parser
- [x] `deno test` hijau (64 passed, 0 failed) + `deno check index.ts` bersih; `deno lint` bersih untuk file tersentuh (2 temuan pre-existing di `index.ts`)
- [ ] Deploy `supabase functions deploy process-receipt` + bump submodule pointer (operator)
- [ ] Verifikasi 7 hari: `schema_error/schema_mismatch` → 0 untuk pola koma

## Risks

- Over-relaxation: validator longgar bisa meloloskan `","` → `0`. Mitigasi: wajib ada digit + tolak hanya-separator (test negatif).
- Drift parser ganda (3 kopian Set): mitigasi dengan shared module tunggal (disetujui user).
- Prompt tidak diubah (disetujui user): LLM tetap boleh kirim koma atau titik — validator menerima keduanya, jadi robust. Counter-argument: memperketat prompt lebih rapuh lintas-lokal.
- `index.ts` tidak ter-cover `deno test` (tidak di-import test manapun): mitigasi dengan `deno check index.ts` eksplisit.

## Progress Log

- 2026-09-15 15:30:00 — Analisa selesai; plan disusun dan disetujui (scope validator+test saja, boleh ekstrak shared helper). Masuk build mode, mulai implementasi.
- 2026-09-15 15:45:00 — Implementasi selesai, belum di-commit/deploy: `zero_decimal.ts` + `zero_decimal_test.ts` baru; `index.ts` / `discount_resolver.ts` / `receipt_total_resolver.ts` refactor import shared. `deno test`: 64 passed / 0 failed (55 lama + 9 baru). `deno check index.ts` bersih. Sisa operator: `supabase functions deploy process-receipt` dari dalam submodule + bump pointer + verifikasi `llm_logs` 7 hari.
- 2026-09-15 16:00:00 — Deploy selesai oleh operator. Submodule di-commit + push sebagai `3fc4451` di branch `fix/ocr-validator-zero-decimal` (5 file, hanya `functions/process-receipt/`). Pointer di-bump di parent sebagai `ad2f98a` + plan/memory ikut ter-commit. Sisa: merge PR submodule → main, re-bump pointer bila perlu, verifikasi `llm_logs` 7 hari.
