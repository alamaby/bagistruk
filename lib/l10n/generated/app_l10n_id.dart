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
  String get splitSummaryCopy => 'Salin';

  @override
  String get splitSummaryCopied => 'Disalin ke clipboard';

  @override
  String get splitShareFailed => 'Tidak bisa membagikan';

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
