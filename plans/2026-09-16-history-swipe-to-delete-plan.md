# History Swipe-to-Delete Plan

Created: 2026-09-16 08:00:00

## Objective

Di layar History, hapus `IconButton(Icons.delete_outline)` per-row, ganti dengan swipe kanan-ke-kiri (`endToStart`) yang tetap membuka dialog konfirmasi yang sama sebelum menghapus.

## Scope

- In: bungkus row History dengan `Dismissible`, hapus tombol delete, background swipe error, dialog + snackbar + reminder-cancel tetap sama.
- Out: tidak ada perubahan ARB, tidak ada perubahan `history_list_notifier` / repo / API, tidak ada `flutter_slidable` (pakai `Dismissible` bawaan agar konsisten dengan Bill Review), tidak ada bump versi.

## Milestones

1. Refactor `_deleteBill` jadi `_confirmAndDeleteBill` yang return `bool`
2. Bungkus row dengan `Dismissible` + background baru
3. Test + analyze hijau

## Tasks

- [x] Refactor `_deleteBill` → `_confirmAndDeleteBill` (return `bool`), pertahankan dialog + retentionDays + snackbar + reminder-cancel
- [x] Bungkus `Card` row dengan `Dismissible` (`ValueKey(bill.id)`, `endToStart`), hapus `IconButton` delete, sisakan duplicate
- [x] Tambah widget `_HistorySwipeBackground`
- [x] Tambah widget test: swipe memunculkan dialog; Batal pertahankan row; Hapus hilangkan row + snackbar; tidak ada ikon `delete_outline` di row
- [x] `flutter analyze` + `flutter test` (file + full)
- [ ] Verifikasi manual: swipe kanan-ke-kiri → dialog; Batal → row tetap; Hapus → row hilang + snackbar; tap → detail; duplicate tetap; swipe kiri-ke-kanan tidak bereaksi

## Risks

- Discoverability turun: tombol hapus yang selalu terlihat diganti gesture tersembunyi. Diterima sesuai pilihan user; fallback jika ada keluhan: kembalikan sebagai menu "..." bukan ikon langsung.
- Konflik gesture: `Dismissible` dalam `CustomScrollView` + `RefreshIndicator` + pagination. Mitigasi: hanya `endToStart` + threshold default Flutter.
- Key stability: key harus `bill.id` (stabil antar halaman `loadMore`), jangan pakai index agar row tidak tertukar saat paginasi.
- Delete gagal setelah animasi: dihindari dengan pola confirm-melakukan-delete — `confirmDismiss` return `true` hanya jika delete sukses.

## Progress Log

- 2026-09-16 08:00:00 — Plan dibuat dari plan-mode; keputusan user: ganti total ke swipe, kanan-ke-kiri saja.
- 2026-09-16 19:15:00 — Implementasi selesai: `Dismissible(endToStart)` + `_confirmAndDeleteBill` + `_HistorySwipeBackground`; tombol delete dihapus, duplicate dipertahankan. `flutter analyze` 0 error (23 info pre-existing), `flutter test` 649 passed (+4 test baru). Verifikasi manual di device belum dilakukan.

## Notes

Perubahan presentasi murni; logic delete di notifier/repo tidak disentuh. Tidak ada migrasi DB / perubahan Edge Function. Pola acuan: `lib/presentation/bills/screens/bill_review_screen.dart` (`Dismissible` + `_SwipeBackground`).
