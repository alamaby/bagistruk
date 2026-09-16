# History Swipe-to-Delete (ganti tombol hapus)

- **Task:** di layar History, action delete tidak lagi pakai tombol ikon tempat sampah — diganti swipe kanan-ke-kiri per row, dialog konfirmasi tetap ada (permintaan user, opsi "ganti total ke swipe" + "kanan-ke-kiri saja").
- **Key files:**
  - `lib/presentation/history/screens/history_screen.dart` — row dibungkus `Dismissible(ValueKey(bill.id), endToStart)`, `_deleteBill` → `_confirmAndDeleteBill` (return `bool`), widget baru `_HistorySwipeBackground`, `trailing` tinggal tombol duplicate.
  - `test/presentation/history/screens/history_screen_test.dart` — grup baru `swipe-to-delete` (4 test, pakai `FakeBillRepository` dari `history_list_notifier_test.dart` + stub `_NoopReminderService`).
  - `plans/2026-09-16-history-swipe-to-delete-plan.md` — plan + progress.
- **Decisions:**
  - Delete berjalan di dalam `confirmDismiss` (bukan `onDismissed`) dan selalu return `false` — row hanya hilang lewat perubahan state provider, jadi delete gagal / dialog batal tidak pernah menghilangkan row secara visual.
  - Pakai `Dismissible` bawaan (konsisten dengan `bill_review_screen.dart`), tanpa tambah dependensi `flutter_slidable`.
  - Key = `bill.id` (stabil antar halaman `loadMore`), bukan index.
  - Tidak ada string ARB baru; background pakai `delete_outline` + `semanticLabel=deleteBillAction` untuk aksesibilitas.
- **Assumptions/risks:** discoverability turun (gesture tersembunyi, diterima user; fallback: menu "..." bila ada keluhan). Swipe kiri-ke-kanan tidak bereaksi (sesuai pilihan). Gotcha: cascade `..x` setelah closure di Dart menempel ke ekspresi terakhir — assignment repo di test ditulis tanpa cascade.
- **Blockers:** verifikasi manual di device belum dilakukan (swipe → dialog → Batal/Hapus, tap → detail, duplicate, arah sebaliknya).
- **Verification:** `flutter analyze` 0 error (23 info, semua pre-existing di file test); `flutter test test/presentation/history/screens/history_screen_test.dart` 41 passed; full `flutter test` 649 passed (+4 baru).
- **Commit proposal:** `feat(history): ganti tombol hapus dengan swipe-to-delete plus konfirmasi`
- **Related:** [plan](../../plans/2026-09-16-history-swipe-to-delete-plan.md)
