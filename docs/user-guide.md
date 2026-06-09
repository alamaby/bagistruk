# Panduan Pengguna BagiStruk

**Terakhir diperbarui:** 2026-06-09

Panduan ini menjelaskan cara memakai BagiStruk dari scan struk sampai settlement, termasuk cara memakai Riwayat, Pengaturan, dan perbedaan akses Free dan Plus.

> Catatan asset: gambar di panduan ini masih placeholder SVG. Ganti dengan screenshot aplikasi asli saat UI final sudah siap agar user melihat tampilan yang sama dengan aplikasi.

## Ringkasan Flow Utama

Flow utama BagiStruk adalah:

1. Tambahkan foto struk dari kamera atau galeri.
2. Scan struk agar aplikasi membaca item, harga, pajak, service, merchant, dan tanggal.
3. Review hasil scan, lalu perbaiki data yang kurang tepat.
4. Simpan bill.
5. Tambahkan partisipan.
6. Pilih partisipan, lalu tap item yang menjadi bagian orang tersebut.
7. Lihat rincian pembagian.
8. Masuk ke detail tagihan untuk share tagihan dan menandai pembayaran.
9. Bill otomatis menjadi lunas ketika semua partisipan sudah ditandai membayar.

![Placeholder flow scan sampai settlement](assets/user-guide/scan-flow.svg)

**Ganti placeholder ini dengan screenshot:** tab Scan yang sudah berisi preview satu atau beberapa foto struk, tombol **Add Photos**, tombol **Scan**, dan status credit/processing jika terlihat.

## 1. Scan Struk

Buka tab **Scan**. Tap **Add Photos**, lalu pilih:

- **Camera** untuk mengambil foto struk langsung dari kamera.
- **Gallery** untuk memilih satu atau beberapa foto dari galeri.

Jika struk panjang, kamu bisa mengambil beberapa foto. Pastikan setiap foto terang, tidak terlalu miring, dan bagian total/item terlihat jelas.

Setelah foto masuk ke preview, tap **Scan**. Aplikasi akan mengecek credit scan terlebih dahulu. Jika credit masih tersedia, foto dikirim ke proses OCR dan AI untuk membaca isi struk.

Catatan penting:

- Scan hanya mengonsumsi credit jika proses menghasilkan hasil struk yang valid.
- Jika gambar bukan struk atau hasil terlalu tidak yakin, aplikasi dapat menolak hasil dan meminta kamu mencoba ulang.
- Untuk struk dengan angka ribuan seperti `15.300`, tetap cek hasil review sebelum menyimpan.

## 2. Review Hasil Scan

![Placeholder layar Review bill](assets/user-guide/review-bill.svg)

**Ganti placeholder ini dengan screenshot:** layar **Review bill** setelah OCR berhasil, idealnya menampilkan nama merchant, tanggal, chip currency, beberapa item, field pajak/service, total, dan tombol **Simpan Bill**.

Setelah scan berhasil, kamu masuk ke layar **Review bill**. Layar ini adalah tahap wajib sebelum data disimpan.

Periksa bagian berikut:

- **Nama merchant**: ubah jika hasil OCR salah atau kosong.
- **Tanggal struk**: muncul jika terbaca dari struk.
- **Currency**: mengikuti currency default dari Settings. Pengguna Plus bisa mengganti currency per bill saat review.
- **Item**: cek nama item, quantity, dan harga per unit.
- **Pajak** dan **Service**: cek angka tambahan yang akan dibagi proporsional ke partisipan.
- **Total**: bandingkan dengan total di struk.

Kamu bisa:

- Mengedit nama item, quantity, dan harga.
- Menambah item dengan tombol **Tambah item**.
- Menghapus item dengan swipe item ke kiri.
- Mengisi atau mengubah pajak dan service.

Jika ada banner peringatan total berbeda dari struk, cek lagi item, pajak, service, atau format angka sebelum menyimpan.

Setelah semuanya benar, tap **Simpan Bill**. Aplikasi akan menyimpan bill dan membuka layar **Split bill**.

## 3. Split Bill

![Placeholder layar Split bill](assets/user-guide/split-bill.svg)

**Ganti placeholder ini dengan screenshot:** layar **Split bill** dengan minimal dua partisipan, salah satu avatar aktif, beberapa item sudah ter-assign, dan indikator **Semua item sudah dibagi** atau nominal **Belum dibagi**.

Di layar **Split bill**, kamu membagi item ke orang yang ikut membayar.

Langkahnya:

1. Tap tombol **Tambah** di kanan bawah.
2. Masukkan nama partisipan.
3. Tap avatar/nama partisipan agar menjadi partisipan aktif.
4. Tap item yang menjadi bagian partisipan tersebut.
5. Jika satu item dibagi beberapa orang, pilih partisipan lain lalu tap item yang sama.
6. Ulangi sampai semua item sudah dibagi.

Bagian atas layar menampilkan:

- Total tagihan.
- Nominal item yang belum dibagi.
- Status apakah semua item sudah dibagi.

Tombol **Lihat Rincian** muncul setelah semua item sudah dibagi dan minimal ada satu partisipan. Gunakan tombol ini untuk mengecek ringkasan pembagian sebelum lanjut.

Tap **Selesai** untuk masuk ke layar detail tagihan atau settlement.

## 4. Settlement

![Placeholder layar Detail Tagihan untuk settlement](assets/user-guide/settlement.svg)

**Ganti placeholder ini dengan screenshot:** layar **Detail Tagihan** yang menampilkan status **Belum lunas** atau **Lunas**, total tagihan, daftar partisipan, tombol share, switch pembayaran, dan tombol export jika memakai akun Plus.

Layar **Detail Tagihan** dipakai untuk menyelesaikan pembayaran.

Di layar ini kamu bisa melihat:

- Nama bill atau merchant.
- Tanggal.
- Total tagihan.
- Status **Belum lunas** atau **Lunas**.
- Progress jumlah partisipan yang sudah membayar.
- Total yang harus dibayar tiap partisipan.

Untuk settlement:

1. Bagikan tagihan ke partisipan dengan tombol share di baris partisipan.
2. Setelah partisipan membayar, aktifkan switch di baris partisipan tersebut.
3. Jika semua partisipan sudah ditandai membayar, bill otomatis berubah menjadi **Lunas**.

Pengguna Plus dapat menyimpan info bank transfer di Settings. Jika info bank terisi, info tersebut dapat ikut muncul di pesan settlement yang dibagikan.

Pengguna Plus juga bisa export bill sebagai PDF atau CSV dari layar detail tagihan.

## 5. Menggunakan History

![Placeholder tab History](assets/user-guide/history.svg)

**Ganti placeholder ini dengan screenshot:** tab **History** akun Free atau Plus yang berisi summary card, banner window History, daftar bill, dan insight bulanan jika memakai Plus.

Tab **History** menampilkan bill yang sudah disimpan.

Di History kamu bisa:

- Melihat jumlah total bill.
- Melihat total outstanding dari bill yang belum lunas.
- Membuka detail bill lama.
- Menghapus bill.
- Melihat status lunas dari ikon centang hijau.
- Refresh daftar dengan pull-to-refresh.

Batas akses History:

- **Anonymous**: History terkunci. Daftar akun untuk menyimpan dan melihat riwayat.
- **Free**: dapat melihat bill dari 7 hari terakhir.
- **Plus**: dapat melihat bill dari 90 hari terakhir.

Saat menghapus bill, bill dipindahkan ke daftar **Bill terhapus**. Pengguna Plus dapat memulihkan bill yang dihapus selama masa pemulihan 30 hari.

Pengguna Plus juga mendapat **Insight bulanan** di History, termasuk total bulan ini, rata-rata bill, jumlah bill, outstanding, tren bulanan, dan merchant terbesar.

## 6. Menggunakan Settings

![Placeholder tab Settings](assets/user-guide/settings.svg)

**Ganti placeholder ini dengan screenshot:** tab **Settings** akun terdaftar yang menampilkan status credit scan, area **Plus dan paket credit**, pilihan currency/language/theme, serta menu **Info bank transfer** dan **Bill terhapus**.

Buka tab **Settings** untuk mengatur akun dan preferensi aplikasi.

Bagian akun menampilkan:

- Nama atau status guest.
- Email untuk akun terdaftar.
- Sisa credit scan.
- Akses Plus dan paket credit.

Pengaturan yang tersedia:

- **Currency**: memilih mata uang default untuk scan dan bill baru.
- **Language**: memilih Bahasa Indonesia atau English.
- **Theme**: memilih light, dark, atau mengikuti sistem.
- **Change name**: mengubah nama tampilan untuk akun terdaftar.
- **Reset password**: mengirim instruksi reset password untuk akun email.
- **Transfer bank info**: menyimpan rekening untuk pesan settlement, khusus Plus.
- **Bill terhapus**: melihat dan memulihkan bill terhapus, khusus Plus.
- **Delete Account**: menghapus akun dan data aplikasi terkait.
- **About**: melihat informasi aplikasi, Privacy Policy, dan Terms of Service.

Untuk pengguna anonymous, Settings menampilkan tombol **Register Permanent**. Gunakan ini untuk membuat akun permanen agar data tidak bergantung pada sesi anonim.

## 7. Free, Anonymous, dan Plus

![Placeholder perbandingan Anonymous, Free, dan Plus](assets/user-guide/plan-comparison.svg)

**Ganti placeholder ini dengan screenshot:** layar billing/paywall di Settings saat produk Plus dan paket credit sudah aktif di Google Play, atau screenshot gabungan yang menunjukkan status credit Anonymous, Free, dan Plus.

Perbedaan akses utama:

| Fitur | Anonymous | Free | Plus |
| --- | --- | --- | --- |
| Scan OCR | 5 credit lifetime | 20 credit/bulan | 60 credit/bulan |
| History | Terkunci | 7 hari terakhir | 90 hari terakhir |
| Iklan | Dapat tampil jika ads aktif | Dapat tampil jika ads aktif | Tidak tampil |
| Per-bill currency saat review | Tidak | Tidak | Ya |
| Monthly insight | Tidak | Preview terkunci | Ya |
| Export PDF/CSV | Tidak | Tidak | Ya |
| Info bank di pesan settlement | Tidak | Tidak | Ya |
| Restore bill terhapus | Tidak | Tidak | Ya, selama 30 hari |
| Paket top-up credit | Perlu daftar akun | Ya, jika tersedia | Ya, jika tersedia |

Credit bulanan dapat hangus pada akhir periode yang berlaku. Paket top-up credit, jika tersedia, ditambahkan setelah pembelian berhasil diverifikasi.

## 8. Tips Agar Hasil Scan Lebih Akurat

- Foto struk di tempat terang.
- Hindari bayangan di bagian total dan daftar item.
- Ambil beberapa foto untuk struk panjang.
- Pastikan angka total, pajak, service, dan item terlihat jelas.
- Review semua angka sebelum tap **Simpan Bill**.
- Jika hasil scan salah jauh, hapus foto dan scan ulang dengan foto yang lebih jelas.

## 9. Menghapus Akun

Kamu bisa menghapus akun dari **Settings > Delete Account**. Aplikasi akan meminta konfirmasi dua tahap, termasuk mengetik frasa konfirmasi.

Jika penghapusan berhasil:

- Bill dan data aplikasi terkait akun akan dihapus.
- Sesi akan kembali ke flow awal.
- Untuk akun terdaftar, autentikasi user juga dihapus dari backend.

Penghapusan akun bersifat serius. Pastikan data yang masih dibutuhkan sudah tidak diperlukan sebelum melanjutkan.
