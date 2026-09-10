# UX Batch 2 — Category Collapse, Assign Race, Share Recopy, Status Badge, Manual Limit

Created: 2026-09-10 00:00:00

## Objective

Lima perbaikan dari temuan uji manual: panel kategori collapsible di review,
race 23505 saat assign cepat, tombol salin-ulang share-link (= rotate),
badge status di history, rate-limit manual bill via tabel.

## Scope

- In-scope: 5 item di bawah + ARB ID/EN + test + bump patch.
- Out-of-scope: migrasi lain, Edge Function, Play upload.

## Milestones

1. Review: kategori collapsible
2. Split: serialisasi assign + 23505 silent reconcile
3. Detail: recopy = rotate + clipboard logging
4. History: badge status ikon+warna
5. Manual bill rate-limit (app_limits + bills.origin)

## Tasks

- [x] T1 category collapsible default-collapsed di review (+ test)
- [x] T2 assign queue + 23505 re-fetch silent (+ test)
- [x] T3 recopy/rotate + clipboard log (+ test)
- [x] T4 badge status history (+ test)
- [x] T5 migrasi app_limits + origin + client mapping (+ test)
- [ ] Verifikasi: analyze 0 error, full test, bump patch, commit, push, tag

## Risks

- Trigger manual-limit butuh kolom origin; duplikat/template server-side default 'ocr' (tak terhitung).
- Rotate Free mematikan link lama yang sudah dibagikan (disetujui user).
- 23505 silent hanya untuk race; gagal persist betulan tetap toast + reconcile.

## Progress Log

- 2026-09-10 — Plan ditulis; eksekusi dimulai.
- 2026-09-10 — T1–T5 selesai di kode. analyze 0 error, full test 636 passed,
  pubspec 0.32.5+85. Migrasi `20260910000000` ditulis di submodule, menunggu
  commit submodule + apply operator. Verifikasi CI/release + commit/push/tag
  parvientzia belum jalan.

## Notes

- Persetujuan user: (a) serialisasi+re-fetch boleh; (b) recopy = rotate; (c) kolom bills.origin boleh.
- Migrasi DB + apply menunggu operator (MCP read-only); Edge tak berubah.
