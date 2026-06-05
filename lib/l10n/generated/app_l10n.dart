import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_l10n_en.dart';
import 'app_l10n_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n)!;
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In id, this message translates to:
  /// **'Profil & Pengaturan'**
  String get settingsTitle;

  /// No description provided for @settingsTab.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settingsTab;

  /// No description provided for @scanTab.
  ///
  /// In id, this message translates to:
  /// **'Pindai'**
  String get scanTab;

  /// No description provided for @historyTab.
  ///
  /// In id, this message translates to:
  /// **'Riwayat'**
  String get historyTab;

  /// No description provided for @scanScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Pindai Struk'**
  String get scanScreenTitle;

  /// No description provided for @scanAddPhotos.
  ///
  /// In id, this message translates to:
  /// **'Tambah Foto'**
  String get scanAddPhotos;

  /// No description provided for @scanAction.
  ///
  /// In id, this message translates to:
  /// **'Pindai'**
  String get scanAction;

  /// No description provided for @scanInProgress.
  ///
  /// In id, this message translates to:
  /// **'Memindai…'**
  String get scanInProgress;

  /// No description provided for @scanSourceSheetTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah foto struk'**
  String get scanSourceSheetTitle;

  /// No description provided for @scanSourceCamera.
  ///
  /// In id, this message translates to:
  /// **'Kamera'**
  String get scanSourceCamera;

  /// No description provided for @scanSourceGallery.
  ///
  /// In id, this message translates to:
  /// **'Galeri'**
  String get scanSourceGallery;

  /// No description provided for @scanCameraContinuePrompt.
  ///
  /// In id, this message translates to:
  /// **'Foto lagi untuk struk panjang?'**
  String get scanCameraContinuePrompt;

  /// No description provided for @scanCameraTakeAnother.
  ///
  /// In id, this message translates to:
  /// **'Foto Lagi'**
  String get scanCameraTakeAnother;

  /// No description provided for @scanCameraDone.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get scanCameraDone;

  /// No description provided for @scanNotReceiptTitle.
  ///
  /// In id, this message translates to:
  /// **'Foto bukan struk'**
  String get scanNotReceiptTitle;

  /// No description provided for @scanNotReceiptHint.
  ///
  /// In id, this message translates to:
  /// **'Gambar yang dipilih sepertinya bukan struk. Coba foto struk yang jelas.'**
  String get scanNotReceiptHint;

  /// No description provided for @retry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get retry;

  /// No description provided for @accountSection.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get accountSection;

  /// No description provided for @preferencesSection.
  ///
  /// In id, this message translates to:
  /// **'Preferensi'**
  String get preferencesSection;

  /// No description provided for @displayNameFallback.
  ///
  /// In id, this message translates to:
  /// **'Pengguna BagiStruk'**
  String get displayNameFallback;

  /// No description provided for @anonDisplayName.
  ///
  /// In id, this message translates to:
  /// **'Saya'**
  String get anonDisplayName;

  /// No description provided for @guestAccount.
  ///
  /// In id, this message translates to:
  /// **'Akun Tamu'**
  String get guestAccount;

  /// No description provided for @changeName.
  ///
  /// In id, this message translates to:
  /// **'Ubah Nama'**
  String get changeName;

  /// No description provided for @changeNameSheetTitle.
  ///
  /// In id, this message translates to:
  /// **'Ubah Nama Tampilan'**
  String get changeNameSheetTitle;

  /// No description provided for @changeNameHint.
  ///
  /// In id, this message translates to:
  /// **'Nama tampilan'**
  String get changeNameHint;

  /// No description provided for @saveAction.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get saveAction;

  /// No description provided for @cancelAction.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancelAction;

  /// No description provided for @resetPassword.
  ///
  /// In id, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Kirim email reset password?'**
  String get resetPasswordConfirmTitle;

  /// No description provided for @resetPasswordConfirmBody.
  ///
  /// In id, this message translates to:
  /// **'Kami akan mengirim tautan reset password ke {email}.'**
  String resetPasswordConfirmBody(String email);

  /// No description provided for @resetPasswordSent.
  ///
  /// In id, this message translates to:
  /// **'Email reset password telah dikirim.'**
  String get resetPasswordSent;

  /// No description provided for @currencyLabel.
  ///
  /// In id, this message translates to:
  /// **'Mata Uang Default'**
  String get currencyLabel;

  /// No description provided for @languageLabel.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get languageLabel;

  /// No description provided for @themeLabel.
  ///
  /// In id, this message translates to:
  /// **'Tema Tampilan'**
  String get themeLabel;

  /// No description provided for @themeLight.
  ///
  /// In id, this message translates to:
  /// **'Terang'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In id, this message translates to:
  /// **'Gelap'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In id, this message translates to:
  /// **'Ikuti Sistem'**
  String get themeSystem;

  /// No description provided for @languageIndonesian.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageIndonesian;

  /// No description provided for @languageEnglish.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @logout.
  ///
  /// In id, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @registerPermanent.
  ///
  /// In id, this message translates to:
  /// **'Daftar Akun Permanen'**
  String get registerPermanent;

  /// No description provided for @confirmLogoutTitle.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari akun?'**
  String get confirmLogoutTitle;

  /// No description provided for @confirmLogoutBody.
  ///
  /// In id, this message translates to:
  /// **'Anda akan keluar dan kembali sebagai pengguna tamu.'**
  String get confirmLogoutBody;

  /// No description provided for @deleteAccount.
  ///
  /// In id, this message translates to:
  /// **'Hapus Akun'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus permanen akun dan data bill tersimpan.'**
  String get deleteAccountSubtitle;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus akun kamu?'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmBody.
  ///
  /// In id, this message translates to:
  /// **'Tindakan ini akan menghapus permanen akun, profil, bill tersimpan, item bill, peserta, pembagian item, dan status pelunasan. Tindakan ini tidak bisa dibatalkan.'**
  String get deleteAccountConfirmBody;

  /// No description provided for @deleteAccountConfirmPhrase.
  ///
  /// In id, this message translates to:
  /// **'HAPUS'**
  String get deleteAccountConfirmPhrase;

  /// No description provided for @deleteAccountTypeTitle.
  ///
  /// In id, this message translates to:
  /// **'Ketik HAPUS untuk konfirmasi'**
  String get deleteAccountTypeTitle;

  /// No description provided for @deleteAccountTypeBody.
  ///
  /// In id, this message translates to:
  /// **'Ketik {phrase} untuk menghapus akun secara permanen.'**
  String deleteAccountTypeBody(String phrase);

  /// No description provided for @deleteAccountInProgress.
  ///
  /// In id, this message translates to:
  /// **'Menghapus akun...'**
  String get deleteAccountInProgress;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In id, this message translates to:
  /// **'Akun dan data tersimpan sudah dihapus.'**
  String get deleteAccountSuccess;

  /// No description provided for @errorGeneric.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan. Coba lagi.'**
  String get errorGeneric;

  /// No description provided for @loading.
  ///
  /// In id, this message translates to:
  /// **'Memuat...'**
  String get loading;

  /// No description provided for @noSessionMessage.
  ///
  /// In id, this message translates to:
  /// **'Daftar atau masuk untuk mengakses pengaturan.'**
  String get noSessionMessage;

  /// No description provided for @registerOrLogin.
  ///
  /// In id, this message translates to:
  /// **'Daftar / Masuk'**
  String get registerOrLogin;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang kembali'**
  String get loginWelcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk untuk melanjutkan ke BagiStruk.'**
  String get loginSubtitle;

  /// No description provided for @loginSaveBanner.
  ///
  /// In id, this message translates to:
  /// **'Daftar untuk menyimpan riwayat tagihanmu'**
  String get loginSaveBanner;

  /// No description provided for @loginButton.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get loginButton;

  /// No description provided for @loginOr.
  ///
  /// In id, this message translates to:
  /// **'atau'**
  String get loginOr;

  /// No description provided for @loginEmailHint.
  ///
  /// In id, this message translates to:
  /// **'kamu@email.com'**
  String get loginEmailHint;

  /// No description provided for @loginOtpButton.
  ///
  /// In id, this message translates to:
  /// **'Kirim kode email'**
  String get loginOtpButton;

  /// No description provided for @loginOtpSending.
  ///
  /// In id, this message translates to:
  /// **'Mengirim kode…'**
  String get loginOtpSending;

  /// No description provided for @loginNoAccount.
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun? '**
  String get loginNoAccount;

  /// No description provided for @loginRegisterLink.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get loginRegisterLink;

  /// No description provided for @registerTitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get registerTitle;

  /// No description provided for @registerBackToScanTooltip.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke Scan'**
  String get registerBackToScanTooltip;

  /// No description provided for @registerSkip.
  ///
  /// In id, this message translates to:
  /// **'Lewati'**
  String get registerSkip;

  /// No description provided for @registerHeading.
  ///
  /// In id, this message translates to:
  /// **'Buat akun baru'**
  String get registerHeading;

  /// No description provided for @registerSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Simpan riwayat tagihanmu di semua perangkat.'**
  String get registerSubtitle;

  /// No description provided for @registerPasswordHint.
  ///
  /// In id, this message translates to:
  /// **'Minimal 6 karakter'**
  String get registerPasswordHint;

  /// No description provided for @registerHaveAccount.
  ///
  /// In id, this message translates to:
  /// **'Sudah punya akun? '**
  String get registerHaveAccount;

  /// No description provided for @registerLoginLink.
  ///
  /// In id, this message translates to:
  /// **'Login'**
  String get registerLoginLink;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In id, this message translates to:
  /// **'Verifikasi email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailBackTooltip.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get verifyEmailBackTooltip;

  /// No description provided for @verifyEmailHeading.
  ///
  /// In id, this message translates to:
  /// **'Cek email kamu'**
  String get verifyEmailHeading;

  /// No description provided for @verifyEmailBodyPrefix.
  ///
  /// In id, this message translates to:
  /// **'Kami sudah mengirim link konfirmasi ke '**
  String get verifyEmailBodyPrefix;

  /// No description provided for @verifyEmailBodySuffix.
  ///
  /// In id, this message translates to:
  /// **'. Klik link itu untuk mengaktifkan akunmu — sampai itu kamu belum bisa login dari perangkat lain.'**
  String get verifyEmailBodySuffix;

  /// No description provided for @verifyEmailAutonav.
  ///
  /// In id, this message translates to:
  /// **'Setelah konfirmasi, kamu otomatis dipindahkan ke Riwayat.'**
  String get verifyEmailAutonav;

  /// No description provided for @verifyEmailResend.
  ///
  /// In id, this message translates to:
  /// **'Kirim ulang email'**
  String get verifyEmailResend;

  /// No description provided for @verifyEmailResending.
  ///
  /// In id, this message translates to:
  /// **'Mengirim…'**
  String get verifyEmailResending;

  /// No description provided for @verifyEmailResent.
  ///
  /// In id, this message translates to:
  /// **'Email verifikasi sudah dikirim ulang.'**
  String get verifyEmailResent;

  /// No description provided for @verifyEmailUseDifferent.
  ///
  /// In id, this message translates to:
  /// **'Pakai email lain'**
  String get verifyEmailUseDifferent;

  /// No description provided for @verifyOtpTitle.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kode'**
  String get verifyOtpTitle;

  /// No description provided for @verifyOtpHeading.
  ///
  /// In id, this message translates to:
  /// **'Cek kode email'**
  String get verifyOtpHeading;

  /// No description provided for @verifyOtpBodyPrefix.
  ///
  /// In id, this message translates to:
  /// **'Kami sudah mengirim kode 6 digit ke '**
  String get verifyOtpBodyPrefix;

  /// No description provided for @verifyOtpBodySuffix.
  ///
  /// In id, this message translates to:
  /// **'. Masukkan kode itu untuk masuk ke akunmu.'**
  String get verifyOtpBodySuffix;

  /// No description provided for @verifyOtpInvalid.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kode 6 digit.'**
  String get verifyOtpInvalid;

  /// No description provided for @verifyOtpButton.
  ///
  /// In id, this message translates to:
  /// **'Verifikasi & masuk'**
  String get verifyOtpButton;

  /// No description provided for @verifyOtpResend.
  ///
  /// In id, this message translates to:
  /// **'Kirim ulang kode'**
  String get verifyOtpResend;

  /// No description provided for @verifyOtpResending.
  ///
  /// In id, this message translates to:
  /// **'Mengirim…'**
  String get verifyOtpResending;

  /// No description provided for @verifyOtpResent.
  ///
  /// In id, this message translates to:
  /// **'Kode baru sudah dikirim.'**
  String get verifyOtpResent;

  /// No description provided for @verifyOtpResendCountdown.
  ///
  /// In id, this message translates to:
  /// **'Kirim ulang dalam {seconds}d'**
  String verifyOtpResendCountdown(int seconds);

  /// No description provided for @verifyOtpUseDifferent.
  ///
  /// In id, this message translates to:
  /// **'Pakai email lain'**
  String get verifyOtpUseDifferent;

  /// No description provided for @historySignOutTooltip.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get historySignOutTooltip;

  /// No description provided for @historySignedOut.
  ///
  /// In id, this message translates to:
  /// **'Kamu sudah keluar.'**
  String get historySignedOut;

  /// No description provided for @historyLoadingMessage.
  ///
  /// In id, this message translates to:
  /// **'Memuat riwayat…'**
  String get historyLoadingMessage;

  /// No description provided for @historyTotalBills.
  ///
  /// In id, this message translates to:
  /// **'Total bill'**
  String get historyTotalBills;

  /// No description provided for @historyOutstanding.
  ///
  /// In id, this message translates to:
  /// **'Piutang outstanding'**
  String get historyOutstanding;

  /// No description provided for @historyEmptyMessage.
  ///
  /// In id, this message translates to:
  /// **'Belum ada bill tersimpan.\nMulai scan struk dari tab Scan.'**
  String get historyEmptyMessage;

  /// No description provided for @historyWindowFree.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Free'**
  String get historyWindowFree;

  /// No description provided for @historyWindowPlus.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Plus'**
  String get historyWindowPlus;

  /// No description provided for @historyWindowAnonymous.
  ///
  /// In id, this message translates to:
  /// **'Riwayat terkunci'**
  String get historyWindowAnonymous;

  /// No description provided for @historyWindowAnonymousSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar untuk menyimpan dan melihat riwayat bill.'**
  String get historyWindowAnonymousSubtitle;

  /// No description provided for @historyWindowFreeSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Menampilkan bill dari {freeDays} hari terakhir. Plus bisa melihat sampai {plusDays} hari terakhir.'**
  String historyWindowFreeSubtitle(int freeDays, int plusDays);

  /// No description provided for @historyWindowSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Menampilkan bill dari {days} hari terakhir.'**
  String historyWindowSubtitle(int days);

  /// No description provided for @historyUpgradeCta.
  ///
  /// In id, this message translates to:
  /// **'Upgrade ke Plus'**
  String get historyUpgradeCta;

  /// No description provided for @monthlyInsightTitle.
  ///
  /// In id, this message translates to:
  /// **'Insight bulanan'**
  String get monthlyInsightTitle;

  /// No description provided for @monthlyInsightMonth.
  ///
  /// In id, this message translates to:
  /// **'Pengeluaran {month}'**
  String monthlyInsightMonth(String month);

  /// No description provided for @monthlyInsightLoading.
  ///
  /// In id, this message translates to:
  /// **'Memuat insight bulanan...'**
  String get monthlyInsightLoading;

  /// No description provided for @monthlyInsightError.
  ///
  /// In id, this message translates to:
  /// **'Insight bulanan belum bisa dimuat.'**
  String get monthlyInsightError;

  /// No description provided for @monthlyInsightLockedSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Lihat total bulanan, tren, piutang outstanding, dan merchant terbesar dengan Plus.'**
  String get monthlyInsightLockedSubtitle;

  /// No description provided for @monthlyInsightTotal.
  ///
  /// In id, this message translates to:
  /// **'Bulan ini'**
  String get monthlyInsightTotal;

  /// No description provided for @monthlyInsightAverage.
  ///
  /// In id, this message translates to:
  /// **'Rata-rata bill'**
  String get monthlyInsightAverage;

  /// No description provided for @monthlyInsightBills.
  ///
  /// In id, this message translates to:
  /// **'Bill'**
  String get monthlyInsightBills;

  /// No description provided for @monthlyInsightOutstanding.
  ///
  /// In id, this message translates to:
  /// **'Outstanding'**
  String get monthlyInsightOutstanding;

  /// No description provided for @monthlyInsightTopMerchants.
  ///
  /// In id, this message translates to:
  /// **'Merchant terbesar'**
  String get monthlyInsightTopMerchants;

  /// No description provided for @monthlyInsightIncrease.
  ///
  /// In id, this message translates to:
  /// **'Naik {percent}% dibanding bulan lalu'**
  String monthlyInsightIncrease(String percent);

  /// No description provided for @monthlyInsightDecrease.
  ///
  /// In id, this message translates to:
  /// **'Turun {percent}% dibanding bulan lalu'**
  String monthlyInsightDecrease(String percent);

  /// No description provided for @monthlyInsightNoChange.
  ///
  /// In id, this message translates to:
  /// **'Tidak berubah dibanding bulan lalu'**
  String get monthlyInsightNoChange;

  /// No description provided for @splitSummaryTitle.
  ///
  /// In id, this message translates to:
  /// **'Rincian per Orang'**
  String get splitSummaryTitle;

  /// No description provided for @splitSummaryNoItems.
  ///
  /// In id, this message translates to:
  /// **'Belum ambil item.'**
  String get splitSummaryNoItems;

  /// No description provided for @splitSummarySubtotal.
  ///
  /// In id, this message translates to:
  /// **'Subtotal'**
  String get splitSummarySubtotal;

  /// No description provided for @splitSummaryTax.
  ///
  /// In id, this message translates to:
  /// **'Pajak (proporsional)'**
  String get splitSummaryTax;

  /// No description provided for @splitSummaryService.
  ///
  /// In id, this message translates to:
  /// **'Service (proporsional)'**
  String get splitSummaryService;

  /// No description provided for @splitSummaryShare.
  ///
  /// In id, this message translates to:
  /// **'Bagikan'**
  String get splitSummaryShare;

  /// No description provided for @splitSummaryCopy.
  ///
  /// In id, this message translates to:
  /// **'Salin'**
  String get splitSummaryCopy;

  /// No description provided for @splitSummaryCopied.
  ///
  /// In id, this message translates to:
  /// **'Disalin ke clipboard'**
  String get splitSummaryCopied;

  /// No description provided for @splitShareFailed.
  ///
  /// In id, this message translates to:
  /// **'Tidak bisa membagikan'**
  String get splitShareFailed;

  /// No description provided for @settlementTemplateBasic.
  ///
  /// In id, this message translates to:
  /// **'Basic'**
  String get settlementTemplateBasic;

  /// No description provided for @settlementTemplateCompact.
  ///
  /// In id, this message translates to:
  /// **'Pesan ringkas'**
  String get settlementTemplateCompact;

  /// No description provided for @settlementTemplateDetailed.
  ///
  /// In id, this message translates to:
  /// **'Pesan rinci'**
  String get settlementTemplateDetailed;

  /// No description provided for @settlementTemplateAll.
  ///
  /// In id, this message translates to:
  /// **'Rekap semua peserta'**
  String get settlementTemplateAll;

  /// No description provided for @settlementTemplatePlusLocked.
  ///
  /// In id, this message translates to:
  /// **'Template WhatsApp yang lebih rapi tersedia dengan Plus.'**
  String get settlementTemplatePlusLocked;

  /// No description provided for @settlementMessageBillPrefix.
  ///
  /// In id, this message translates to:
  /// **'Rincian'**
  String get settlementMessageBillPrefix;

  /// No description provided for @settlementMessageRecapPrefix.
  ///
  /// In id, this message translates to:
  /// **'Rekap BagiStruk -'**
  String get settlementMessageRecapPrefix;

  /// No description provided for @settlementMessageFor.
  ///
  /// In id, this message translates to:
  /// **'Untuk'**
  String get settlementMessageFor;

  /// No description provided for @settlementMessageGreeting.
  ///
  /// In id, this message translates to:
  /// **'Halo {name}, bagianmu:'**
  String settlementMessageGreeting(String name);

  /// No description provided for @settlementMessageTransferNote.
  ///
  /// In id, this message translates to:
  /// **'Mohon transfer jika sudah sesuai. Terima kasih.'**
  String get settlementMessageTransferNote;

  /// No description provided for @settlementMessageItems.
  ///
  /// In id, this message translates to:
  /// **'Item kamu'**
  String get settlementMessageItems;

  /// No description provided for @settlementMessageUnnamedItem.
  ///
  /// In id, this message translates to:
  /// **'(tanpa nama)'**
  String get settlementMessageUnnamedItem;

  /// No description provided for @settlementMessageSharedWith.
  ///
  /// In id, this message translates to:
  /// **'dibagi {count}'**
  String settlementMessageSharedWith(int count);

  /// No description provided for @settlementMessageTotal.
  ///
  /// In id, this message translates to:
  /// **'Total'**
  String get settlementMessageTotal;

  /// No description provided for @settlementMessageStatus.
  ///
  /// In id, this message translates to:
  /// **'Status'**
  String get settlementMessageStatus;

  /// No description provided for @settlementMessagePaid.
  ///
  /// In id, this message translates to:
  /// **'lunas'**
  String get settlementMessagePaid;

  /// No description provided for @settlementMessageUnpaid.
  ///
  /// In id, this message translates to:
  /// **'belum lunas'**
  String get settlementMessageUnpaid;

  /// No description provided for @settlementMessageGrandTotal.
  ///
  /// In id, this message translates to:
  /// **'Total bill'**
  String get settlementMessageGrandTotal;

  /// No description provided for @settlementMessageOutstanding.
  ///
  /// In id, this message translates to:
  /// **'Belum lunas'**
  String get settlementMessageOutstanding;

  /// No description provided for @aboutTitle.
  ///
  /// In id, this message translates to:
  /// **'Tentang'**
  String get aboutTitle;

  /// No description provided for @aboutSettingsTile.
  ///
  /// In id, this message translates to:
  /// **'Tentang Aplikasi'**
  String get aboutSettingsTile;

  /// No description provided for @aboutVersionLabel.
  ///
  /// In id, this message translates to:
  /// **'Versi'**
  String get aboutVersionLabel;

  /// No description provided for @aboutSectionApp.
  ///
  /// In id, this message translates to:
  /// **'Aplikasi'**
  String get aboutSectionApp;

  /// No description provided for @aboutSectionAuthor.
  ///
  /// In id, this message translates to:
  /// **'Pembuat'**
  String get aboutSectionAuthor;

  /// No description provided for @aboutSectionSupport.
  ///
  /// In id, this message translates to:
  /// **'Dukung'**
  String get aboutSectionSupport;

  /// No description provided for @aboutAuthorName.
  ///
  /// In id, this message translates to:
  /// **'Alam Aby Bashit'**
  String get aboutAuthorName;

  /// No description provided for @aboutWebsite.
  ///
  /// In id, this message translates to:
  /// **'Situs Web'**
  String get aboutWebsite;

  /// No description provided for @aboutGithub.
  ///
  /// In id, this message translates to:
  /// **'GitHub'**
  String get aboutGithub;

  /// No description provided for @aboutLinkedin.
  ///
  /// In id, this message translates to:
  /// **'LinkedIn'**
  String get aboutLinkedin;

  /// No description provided for @aboutBuyMeACoffee.
  ///
  /// In id, this message translates to:
  /// **'Buy Me a Coffee'**
  String get aboutBuyMeACoffee;

  /// No description provided for @aboutSaweria.
  ///
  /// In id, this message translates to:
  /// **'Saweria'**
  String get aboutSaweria;

  /// No description provided for @aboutPatreon.
  ///
  /// In id, this message translates to:
  /// **'Patreon'**
  String get aboutPatreon;

  /// No description provided for @aboutPrivacyPolicy.
  ///
  /// In id, this message translates to:
  /// **'Kebijakan Privasi'**
  String get aboutPrivacyPolicy;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In id, this message translates to:
  /// **'Kebijakan Privasi'**
  String get privacyPolicyTitle;

  /// No description provided for @aboutTermsOfService.
  ///
  /// In id, this message translates to:
  /// **'Syarat dan Ketentuan'**
  String get aboutTermsOfService;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In id, this message translates to:
  /// **'Syarat dan Ketentuan'**
  String get termsOfServiceTitle;

  /// No description provided for @linkUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Tautan belum tersedia'**
  String get linkUnavailable;

  /// No description provided for @reviewSuspectThousandsBug.
  ///
  /// In id, this message translates to:
  /// **'Harga tampak memakai pemisah ribuan sebagai desimal. Mohon periksa tiap angka sebelum menyimpan.'**
  String get reviewSuspectThousandsBug;

  /// No description provided for @paywallTitle.
  ///
  /// In id, this message translates to:
  /// **'Simpan riwayat & lacak piutang'**
  String get paywallTitle;

  /// No description provided for @paywallSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar atau masuk untuk menyimpan riwayat dan melacak piutangmu.'**
  String get paywallSubtitle;

  /// No description provided for @paywallRegister.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get paywallRegister;

  /// No description provided for @paywallLogin.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get paywallLogin;

  /// No description provided for @scanEmptyHint.
  ///
  /// In id, this message translates to:
  /// **'Ambil foto struk belanja atau makan bareng untuk mulai berbagi adil!'**
  String get scanEmptyHint;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppL10nEn();
    case 'id':
      return AppL10nId();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
