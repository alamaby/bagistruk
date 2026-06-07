// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppL10nId extends AppL10n {
  AppL10nId([String locale = 'id']) : super(locale);

  @override
  String get settingsTitle => 'Profil & Pengaturan';

  @override
  String get settingsTab => 'Pengaturan';

  @override
  String get scanTab => 'Pindai';

  @override
  String get historyTab => 'Riwayat';

  @override
  String get scanScreenTitle => 'Pindai Struk';

  @override
  String get scanAddPhotos => 'Tambah Foto';

  @override
  String get scanAction => 'Pindai';

  @override
  String get scanInProgress => 'Memindai…';

  @override
  String get scanSourceSheetTitle => 'Tambah foto struk';

  @override
  String get scanSourceCamera => 'Kamera';

  @override
  String get scanSourceGallery => 'Galeri';

  @override
  String get scanCameraContinuePrompt => 'Foto lagi untuk struk panjang?';

  @override
  String get scanCameraTakeAnother => 'Foto Lagi';

  @override
  String get scanCameraDone => 'Selesai';

  @override
  String get scanNotReceiptTitle => 'Foto bukan struk';

  @override
  String get scanNotReceiptHint =>
      'Gambar yang dipilih sepertinya bukan struk. Coba foto struk yang jelas.';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get accountSection => 'Akun';

  @override
  String get preferencesSection => 'Preferensi';

  @override
  String get displayNameFallback => 'Pengguna BagiStruk';

  @override
  String get anonDisplayName => 'Saya';

  @override
  String get guestAccount => 'Akun Tamu';

  @override
  String get changeName => 'Ubah Nama';

  @override
  String get changeNameSheetTitle => 'Ubah Nama Tampilan';

  @override
  String get changeNameHint => 'Nama tampilan';

  @override
  String get saveAction => 'Simpan';

  @override
  String get cancelAction => 'Batal';

  @override
  String get creditScanTitle => 'Credit scan';

  @override
  String get creditStatusLoading => 'Memuat status credit...';

  @override
  String creditStatusRemaining(
    int balance,
    int monthlyAllowance,
    String planCode,
  ) {
    return '$balance/$monthlyAllowance tersisa ($planCode)';
  }

  @override
  String get billingTitle => 'Plus dan paket credit';

  @override
  String get billingAnonSubtitle =>
      'Daftar akun dulu untuk membeli Plus atau top-up credit.';

  @override
  String get billingPlusActive => 'Plus aktif';

  @override
  String get billingUpgradePlus => 'Upgrade Plus';

  @override
  String get billingBuyCredits => 'Beli 50 credit';

  @override
  String get billingLoading => 'Memuat...';

  @override
  String get billingRestorePurchases => 'Pulihkan pembelian';

  @override
  String get transferBankSettingsTitle => 'Info bank transfer';

  @override
  String get transferBankSettingsSubtitle =>
      'Tambahkan rekening untuk pesan WhatsApp settlement.';

  @override
  String get transferBankSettingsLockedSubtitle =>
      'Khusus Plus. Info bank bisa ikut di pesan WhatsApp settlement.';

  @override
  String get transferBankScreenTitle => 'Bank Transfer';

  @override
  String get transferBankNameLabel => 'Nama bank';

  @override
  String get transferAccountNameLabel => 'Nama pemilik rekening';

  @override
  String get transferAccountNumberLabel => 'Nomor rekening';

  @override
  String get transferBankShareTitle => 'Transfer ke';

  @override
  String get transferBankShareHint =>
      'Kalau terisi, info ini ikut muncul di pesan yang dibagikan ke WhatsApp.';

  @override
  String get transferBankPlusOnly =>
      'Info bank transfer adalah fitur Plus. Upgrade untuk menyimpan rekening dan menambahkannya ke pesan settlement.';

  @override
  String get transferBankRequired =>
      'Lengkapi field ini atau kosongkan semuanya.';

  @override
  String get transferBankSaved => 'Info bank transfer tersimpan.';

  @override
  String get transferBankClear => 'Kosongkan info bank';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordConfirmTitle => 'Kirim email reset password?';

  @override
  String resetPasswordConfirmBody(String email) {
    return 'Kami akan mengirim tautan reset password ke $email.';
  }

  @override
  String get resetPasswordSent => 'Email reset password telah dikirim.';

  @override
  String get currencyLabel => 'Mata Uang Default';

  @override
  String get languageLabel => 'Bahasa';

  @override
  String get themeLabel => 'Tema Tampilan';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeSystem => 'Ikuti Sistem';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get logout => 'Logout';

  @override
  String get registerPermanent => 'Daftar Akun Permanen';

  @override
  String get confirmLogoutTitle => 'Keluar dari akun?';

  @override
  String get confirmLogoutBody =>
      'Anda akan keluar dan kembali sebagai pengguna tamu.';

  @override
  String get deleteAccount => 'Hapus Akun';

  @override
  String get deleteAccountSubtitle =>
      'Hapus permanen akun dan data bill tersimpan.';

  @override
  String get deleteAccountConfirmTitle => 'Hapus akun kamu?';

  @override
  String get deleteAccountConfirmBody =>
      'Tindakan ini akan menghapus permanen akun, profil, bill tersimpan, item bill, peserta, pembagian item, dan status pelunasan. Tindakan ini tidak bisa dibatalkan.';

  @override
  String get deleteAccountConfirmPhrase => 'HAPUS';

  @override
  String get deleteAccountTypeTitle => 'Ketik HAPUS untuk konfirmasi';

  @override
  String deleteAccountTypeBody(String phrase) {
    return 'Ketik $phrase untuk menghapus akun secara permanen.';
  }

  @override
  String get deleteAccountInProgress => 'Menghapus akun...';

  @override
  String get deleteAccountSuccess => 'Akun dan data tersimpan sudah dihapus.';

  @override
  String get errorGeneric => 'Terjadi kesalahan. Coba lagi.';

  @override
  String get loading => 'Memuat...';

  @override
  String get noSessionMessage =>
      'Daftar atau masuk untuk mengakses pengaturan.';

  @override
  String get registerOrLogin => 'Daftar / Masuk';

  @override
  String get loginWelcomeBack => 'Selamat datang kembali';

  @override
  String get loginSubtitle => 'Masuk untuk melanjutkan ke BagiStruk.';

  @override
  String get loginSaveBanner => 'Daftar untuk menyimpan riwayat tagihanmu';

  @override
  String get loginButton => 'Masuk';

  @override
  String get loginOr => 'atau';

  @override
  String get loginEmailHint => 'kamu@email.com';

  @override
  String get loginOtpButton => 'Kirim kode email';

  @override
  String get loginOtpSending => 'Mengirim kode…';

  @override
  String get loginNoAccount => 'Belum punya akun? ';

  @override
  String get loginRegisterLink => 'Daftar';

  @override
  String get registerTitle => 'Daftar';

  @override
  String get registerBackToScanTooltip => 'Kembali ke Scan';

  @override
  String get registerSkip => 'Lewati';

  @override
  String get registerHeading => 'Buat akun baru';

  @override
  String get registerSubtitle => 'Simpan riwayat tagihanmu di semua perangkat.';

  @override
  String get registerPasswordHint => 'Minimal 6 karakter';

  @override
  String get registerHaveAccount => 'Sudah punya akun? ';

  @override
  String get registerLoginLink => 'Login';

  @override
  String get verifyEmailTitle => 'Verifikasi email';

  @override
  String get verifyEmailBackTooltip => 'Kembali';

  @override
  String get verifyEmailHeading => 'Cek email kamu';

  @override
  String get verifyEmailBodyPrefix => 'Kami sudah mengirim link konfirmasi ke ';

  @override
  String get verifyEmailBodySuffix =>
      '. Klik link itu untuk mengaktifkan akunmu — sampai itu kamu belum bisa login dari perangkat lain.';

  @override
  String get verifyEmailAutonav =>
      'Setelah konfirmasi, kamu otomatis dipindahkan ke Riwayat.';

  @override
  String get verifyEmailResend => 'Kirim ulang email';

  @override
  String get verifyEmailResending => 'Mengirim…';

  @override
  String get verifyEmailResent => 'Email verifikasi sudah dikirim ulang.';

  @override
  String get verifyEmailUseDifferent => 'Pakai email lain';

  @override
  String get verifyOtpTitle => 'Masukkan kode';

  @override
  String get verifyOtpHeading => 'Cek kode email';

  @override
  String get verifyOtpBodyPrefix => 'Kami sudah mengirim kode 6 digit ke ';

  @override
  String get verifyOtpBodySuffix =>
      '. Masukkan kode itu untuk masuk ke akunmu.';

  @override
  String get verifyOtpInvalid => 'Masukkan kode 6 digit.';

  @override
  String get verifyOtpButton => 'Verifikasi & masuk';

  @override
  String get verifyOtpResend => 'Kirim ulang kode';

  @override
  String get verifyOtpResending => 'Mengirim…';

  @override
  String get verifyOtpResent => 'Kode baru sudah dikirim.';

  @override
  String verifyOtpResendCountdown(int seconds) {
    return 'Kirim ulang dalam ${seconds}d';
  }

  @override
  String get verifyOtpUseDifferent => 'Pakai email lain';

  @override
  String get historySignOutTooltip => 'Keluar';

  @override
  String get historySignedOut => 'Kamu sudah keluar.';

  @override
  String get historyLoadingMessage => 'Memuat riwayat…';

  @override
  String get historyTotalBills => 'Total bill';

  @override
  String get historyOutstanding => 'Piutang outstanding';

  @override
  String get historyEmptyMessage =>
      'Belum ada bill tersimpan.\nMulai scan struk dari tab Scan.';

  @override
  String get historyWindowFree => 'Riwayat Free';

  @override
  String get historyWindowPlus => 'Riwayat Plus';

  @override
  String get historyWindowAnonymous => 'Riwayat terkunci';

  @override
  String get historyWindowAnonymousSubtitle =>
      'Daftar untuk menyimpan dan melihat riwayat bill.';

  @override
  String historyWindowFreeSubtitle(int freeDays, int plusDays) {
    return 'Menampilkan bill dari $freeDays hari terakhir. Plus bisa melihat sampai $plusDays hari terakhir.';
  }

  @override
  String historyWindowSubtitle(int days) {
    return 'Menampilkan bill dari $days hari terakhir.';
  }

  @override
  String get historyUpgradeCta => 'Upgrade ke Plus';

  @override
  String get monthlyInsightTitle => 'Insight bulanan';

  @override
  String monthlyInsightMonth(String month) {
    return 'Pengeluaran $month';
  }

  @override
  String get monthlyInsightLoading => 'Memuat insight bulanan...';

  @override
  String get monthlyInsightError => 'Insight bulanan belum bisa dimuat.';

  @override
  String get monthlyInsightLockedSubtitle =>
      'Lihat total bulanan, tren, piutang outstanding, dan merchant terbesar dengan Plus.';

  @override
  String get monthlyInsightTotal => 'Bulan ini';

  @override
  String get monthlyInsightAverage => 'Rata-rata bill';

  @override
  String get monthlyInsightBills => 'Bill';

  @override
  String get monthlyInsightOutstanding => 'Outstanding';

  @override
  String get monthlyInsightTopMerchants => 'Merchant terbesar';

  @override
  String monthlyInsightIncrease(String percent) {
    return 'Naik $percent% dibanding bulan lalu';
  }

  @override
  String monthlyInsightDecrease(String percent) {
    return 'Turun $percent% dibanding bulan lalu';
  }

  @override
  String get monthlyInsightNoChange => 'Tidak berubah dibanding bulan lalu';

  @override
  String get splitSummaryTitle => 'Rincian per Orang';

  @override
  String get splitSummaryNoItems => 'Belum ambil item.';

  @override
  String get splitSummarySubtotal => 'Subtotal';

  @override
  String get splitSummaryTax => 'Pajak (proporsional)';

  @override
  String get splitSummaryService => 'Service (proporsional)';

  @override
  String get splitSummaryShare => 'Bagikan';

  @override
  String get participantShareAgain => 'Bagikan ulang';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get exportPdfPlusLocked => 'Export PDF (Plus)';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get exportCsvPlusLocked => 'Export CSV (Plus)';

  @override
  String get exportFailed => 'Export belum bisa dibuat. Coba lagi.';

  @override
  String exportPdfSubject(String title) {
    return 'Export $title';
  }

  @override
  String exportPdfShareText(String title) {
    return 'Export PDF untuk $title';
  }

  @override
  String exportCsvSubject(String title) {
    return 'Export $title';
  }

  @override
  String exportCsvShareText(String title) {
    return 'Export CSV untuk $title';
  }

  @override
  String get splitSummaryCopy => 'Salin';

  @override
  String get splitSummaryCopied => 'Disalin ke clipboard';

  @override
  String get splitShareFailed => 'Tidak bisa membagikan';

  @override
  String get settlementTemplateBasic => 'Basic';

  @override
  String get settlementTemplateCompact => 'Pesan ringkas';

  @override
  String get settlementTemplateDetailed => 'Pesan rinci';

  @override
  String get settlementTemplateAll => 'Rekap semua peserta';

  @override
  String get settlementTemplatePlusLocked =>
      'Template WhatsApp yang lebih rapi tersedia dengan Plus.';

  @override
  String get settlementMessageBillPrefix => 'Rincian';

  @override
  String get settlementMessageRecapPrefix => 'Rekap BagiStruk -';

  @override
  String get settlementMessageFor => 'Untuk';

  @override
  String settlementMessageGreeting(String name) {
    return 'Halo $name, bagianmu:';
  }

  @override
  String get settlementMessageTransferNote =>
      'Mohon transfer jika sudah sesuai. Terima kasih.';

  @override
  String get settlementMessageItems => 'Item kamu';

  @override
  String get settlementMessageUnnamedItem => '(tanpa nama)';

  @override
  String settlementMessageSharedWith(int count) {
    return 'dibagi $count';
  }

  @override
  String get settlementMessageTotal => 'Total';

  @override
  String get settlementMessageStatus => 'Status';

  @override
  String get settlementMessagePaid => 'lunas';

  @override
  String get settlementMessageUnpaid => 'belum lunas';

  @override
  String get settlementMessageGrandTotal => 'Total bill';

  @override
  String get settlementMessageOutstanding => 'Belum lunas';

  @override
  String get aboutTitle => 'Tentang';

  @override
  String get aboutSettingsTile => 'Tentang Aplikasi';

  @override
  String get aboutVersionLabel => 'Versi';

  @override
  String get aboutSectionApp => 'Aplikasi';

  @override
  String get aboutSectionAuthor => 'Pembuat';

  @override
  String get aboutSectionSupport => 'Dukung';

  @override
  String get aboutAuthorName => 'Alam Aby Bashit';

  @override
  String get aboutWebsite => 'Situs Web';

  @override
  String get aboutGithub => 'GitHub';

  @override
  String get aboutLinkedin => 'LinkedIn';

  @override
  String get aboutBuyMeACoffee => 'Buy Me a Coffee';

  @override
  String get aboutSaweria => 'Saweria';

  @override
  String get aboutPatreon => 'Patreon';

  @override
  String get aboutPrivacyPolicy => 'Kebijakan Privasi';

  @override
  String get privacyPolicyTitle => 'Kebijakan Privasi';

  @override
  String get aboutTermsOfService => 'Syarat dan Ketentuan';

  @override
  String get termsOfServiceTitle => 'Syarat dan Ketentuan';

  @override
  String get linkUnavailable => 'Tautan belum tersedia';

  @override
  String get reviewSuspectThousandsBug =>
      'Harga tampak memakai pemisah ribuan sebagai desimal. Mohon periksa tiap angka sebelum menyimpan.';

  @override
  String get paywallTitle => 'Simpan riwayat & lacak piutang';

  @override
  String get paywallSubtitle =>
      'Daftar atau masuk untuk menyimpan riwayat dan melacak piutangmu.';

  @override
  String get paywallRegister => 'Daftar';

  @override
  String get paywallLogin => 'Masuk';

  @override
  String get scanEmptyHint =>
      'Ambil foto struk belanja atau makan bareng untuk mulai berbagi adil!';
}
