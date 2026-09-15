# LLM Schema-Mismatch Validator Fix (request 119b813b)

- **Date:** 2026-09-15 15:45 (local)
- **Trigger:** analisa `llm_logs.request_id = 119b813b-7d48-44fd-b267-183129a439a5` via MCP `supabase-bagistruk-production`.

## Task / problem

Attempt-1 OCR (`gemini-3.5-flash-lite`, prio 2) me-return `"price": "25,000"` (koma) untuk IDR lalu kena `422 schema_error / schema_mismatch` dan failover ke `gemini-3.1-flash-lite` (prio 3) yang sukses. Bill akhir benar (`bfe7799c-...`, INDOMARET 25000), hanya tambah ~2 dtk. Root cause: `isNumberOrNumericString()` memakai `Number("25,000") = NaN`, padahal `toNumber()`/`parseZeroDecimalString()` sudah menangani koma. Validator lebih ketat dari parser.

## Files changed (di dalam submodule `supabase/`, belum di-commit)

- `functions/process-receipt/zero_decimal.ts` (baru): `ZERO_DECIMAL_CURRENCIES` + `parseZeroDecimalString` + `toNumber` + `isNumberOrNumericString(v, currency)` locale-aware + guard anti-sampah (wajib ada digit, minus hanya leading, huruf ditolak; terima `(1.500)` ala akuntansi).
- `functions/process-receipt/zero_decimal_test.ts` (baru): 9 test — regresi `"25,000"`, matriks terima/tolak, round-trip parser, semantik USD.
- `functions/process-receipt/index.ts`: hapus duplikat Set/parser/validator, import shared; `isOcrPayload(value, currency)` + 3 call-site teruskan `currency`.
- `functions/process-receipt/discount_resolver.ts`: hapus duplikat, import shared (`toNumber` di-re-export untuk kompatibilitas).
- `functions/process-receipt/receipt_total_resolver.ts`: hapus duplikat Set, import shared.

## Decisions

- Scope hanya validator + shared helper + test (disetujui user); prompt text tidak diubah — validator menerima koma maupun titik sehingga robust lintas-lokal.
- Ekstrak shared module (disetujui user) untuk hapus 3 kopian `ZERO_DECIMAL_CURRENCIES`; invarian didokumentasikan di header `zero_decimal.ts`: validator tidak boleh lebih ketat dari parser.
- `isOcrPayload` tetap di `index.ts` (tidak di-import test agar tidak menarik remote `esm.sh`); `index.ts` diverifikasi via `deno check` eksplisit.

## Assumptions / risks

- `"12a34"`/`"Rp 15.000"` tetap ditolak validator (huruf ditolak) — sama seperti perilaku lama, bukan regresi; prompt sudah melarang simbol mata uang.
- 2 temuan `deno lint` di `index.ts` (import `https:` baris 15, `any` baris 1171) adalah pre-existing, tidak tersentuh.

## Blockers / unresolved

- `supabase functions deploy process-receipt` + bump pointer submodule + verifikasi `llm_logs` 7 hari — menunggu operator (butuh kredensial Supabase).
- Commit: kerjakan di dalam submodule dulu (`cd supabase`), lalu bump pointer dari parent.

## Verification

- `deno test --allow-env` (dari `functions/process-receipt/`): **64 passed, 0 failed** (55 lama + 9 baru).
- `deno check index.ts`: bersih.
- `deno lint` pada 4 file tersentuh: bersih.

## Commit proposal

- Submodule: `fix(ocr): accept comma thousand separators in validator via shared zero_decimal helper`
- Parent: `chore: bump supabase submodule pointer`

## Related

- Plan: `plans/2026-09-15-llm-schema-mismatch-validator-fix.md`
