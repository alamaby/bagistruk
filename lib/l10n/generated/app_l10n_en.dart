// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Profile & Settings';

  @override
  String get settingsTab => 'Settings';

  @override
  String get scanTab => 'Scan';

  @override
  String get historyTab => 'History';

  @override
  String get scanScreenTitle => 'Scan Receipt';

  @override
  String get scanAddPhotos => 'Add Photos';

  @override
  String get scanAction => 'Scan';

  @override
  String get scanInProgress => 'Scanning…';

  @override
  String get scanSourceSheetTitle => 'Add receipt photo';

  @override
  String get scanSourceCamera => 'Camera';

  @override
  String get scanSourceGallery => 'Gallery';

  @override
  String get scanCameraContinuePrompt =>
      'Take another photo for this long receipt?';

  @override
  String get scanCameraTakeAnother => 'Take another';

  @override
  String get scanCameraDone => 'Done';

  @override
  String get scanNotReceiptTitle => 'Not a receipt';

  @override
  String get scanNotReceiptHint =>
      'The selected image doesn\'t look like a receipt. Try a clear photo of a receipt.';

  @override
  String get retry => 'Retry';

  @override
  String get accountSection => 'Account';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get displayNameFallback => 'BagiStruk User';

  @override
  String get anonDisplayName => 'Me';

  @override
  String get guestAccount => 'Guest Account';

  @override
  String get changeName => 'Change Name';

  @override
  String get changeNameSheetTitle => 'Change Display Name';

  @override
  String get changeNameHint => 'Display name';

  @override
  String get saveAction => 'Save';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get transferBankSettingsTitle => 'Bank transfer info';

  @override
  String get transferBankSettingsSubtitle =>
      'Add an account for WhatsApp settlement messages.';

  @override
  String get transferBankSettingsLockedSubtitle =>
      'Plus only. Bank info can be added to WhatsApp settlement messages.';

  @override
  String get transferBankScreenTitle => 'Bank Transfer';

  @override
  String get transferBankNameLabel => 'Bank name';

  @override
  String get transferAccountNameLabel => 'Account holder name';

  @override
  String get transferAccountNumberLabel => 'Account number';

  @override
  String get transferBankShareTitle => 'Transfer to';

  @override
  String get transferBankShareHint =>
      'When filled, this info appears in settlement messages shared to WhatsApp.';

  @override
  String get transferBankPlusOnly =>
      'Bank transfer info is a Plus feature. Upgrade to save an account and add it to settlement messages.';

  @override
  String get transferBankRequired =>
      'Fill this field or leave everything empty.';

  @override
  String get transferBankSaved => 'Bank transfer info saved.';

  @override
  String get transferBankClear => 'Clear bank info';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordConfirmTitle => 'Send password reset email?';

  @override
  String resetPasswordConfirmBody(String email) {
    return 'We will send a password reset link to $email.';
  }

  @override
  String get resetPasswordSent => 'Password reset email sent.';

  @override
  String get currencyLabel => 'Default Currency';

  @override
  String get languageLabel => 'Language';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'Follow System';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get logout => 'Log Out';

  @override
  String get registerPermanent => 'Create Permanent Account';

  @override
  String get confirmLogoutTitle => 'Log out of your account?';

  @override
  String get confirmLogoutBody =>
      'You will be logged out and returned as a guest user.';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountSubtitle =>
      'Permanently remove your account and saved bill data.';

  @override
  String get deleteAccountConfirmTitle => 'Delete your account?';

  @override
  String get deleteAccountConfirmBody =>
      'This will permanently delete your account, profile, saved bills, bill items, participants, assignments, and settlement status. This action cannot be undone.';

  @override
  String get deleteAccountConfirmPhrase => 'DELETE';

  @override
  String get deleteAccountTypeTitle => 'Type DELETE to confirm';

  @override
  String deleteAccountTypeBody(String phrase) {
    return 'Type $phrase to permanently delete your account.';
  }

  @override
  String get deleteAccountInProgress => 'Deleting account...';

  @override
  String get deleteAccountSuccess =>
      'Your account and saved data have been deleted.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get loading => 'Loading...';

  @override
  String get noSessionMessage => 'Sign up or log in to access settings.';

  @override
  String get registerOrLogin => 'Sign up / Log in';

  @override
  String get loginWelcomeBack => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue to BagiStruk.';

  @override
  String get loginSaveBanner => 'Sign up to save your bill history';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginOr => 'or';

  @override
  String get loginEmailHint => 'you@email.com';

  @override
  String get loginOtpButton => 'Send email code';

  @override
  String get loginOtpSending => 'Sending code…';

  @override
  String get loginNoAccount => 'Don\'t have an account? ';

  @override
  String get loginRegisterLink => 'Sign Up';

  @override
  String get registerTitle => 'Sign Up';

  @override
  String get registerBackToScanTooltip => 'Back to Scan';

  @override
  String get registerSkip => 'Skip';

  @override
  String get registerHeading => 'Create a new account';

  @override
  String get registerSubtitle => 'Save your bill history across all devices.';

  @override
  String get registerPasswordHint => 'At least 6 characters';

  @override
  String get registerHaveAccount => 'Already have an account? ';

  @override
  String get registerLoginLink => 'Log In';

  @override
  String get verifyEmailTitle => 'Verify email';

  @override
  String get verifyEmailBackTooltip => 'Back';

  @override
  String get verifyEmailHeading => 'Check your email';

  @override
  String get verifyEmailBodyPrefix => 'We sent a confirmation link to ';

  @override
  String get verifyEmailBodySuffix =>
      '. Click that link to activate your account — until then you cannot sign in from other devices.';

  @override
  String get verifyEmailAutonav =>
      'After confirmation, you\'ll be automatically navigated to History.';

  @override
  String get verifyEmailResend => 'Resend email';

  @override
  String get verifyEmailResending => 'Sending…';

  @override
  String get verifyEmailResent => 'Verification email has been resent.';

  @override
  String get verifyEmailUseDifferent => 'Use a different email';

  @override
  String get verifyOtpTitle => 'Enter code';

  @override
  String get verifyOtpHeading => 'Check your email code';

  @override
  String get verifyOtpBodyPrefix => 'We sent a 6-digit code to ';

  @override
  String get verifyOtpBodySuffix => '. Enter it to sign in to your account.';

  @override
  String get verifyOtpInvalid => 'Enter the 6-digit code.';

  @override
  String get verifyOtpButton => 'Verify & sign in';

  @override
  String get verifyOtpResend => 'Resend code';

  @override
  String get verifyOtpResending => 'Sending…';

  @override
  String get verifyOtpResent => 'A new code has been sent.';

  @override
  String verifyOtpResendCountdown(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get verifyOtpUseDifferent => 'Use a different email';

  @override
  String get historySignOutTooltip => 'Sign Out';

  @override
  String get historySignedOut => 'You have been signed out.';

  @override
  String get historyLoadingMessage => 'Loading history…';

  @override
  String get historyTotalBills => 'Total bills';

  @override
  String get historyOutstanding => 'Outstanding';

  @override
  String get historyEmptyMessage =>
      'No saved bills yet.\nStart scanning a receipt from the Scan tab.';

  @override
  String get historyWindowFree => 'Free history';

  @override
  String get historyWindowPlus => 'Plus history';

  @override
  String get historyWindowAnonymous => 'History locked';

  @override
  String get historyWindowAnonymousSubtitle =>
      'Sign up to save and view bill history.';

  @override
  String historyWindowFreeSubtitle(int freeDays, int plusDays) {
    return 'Showing bills from the last $freeDays days. Plus can show up to the last $plusDays days.';
  }

  @override
  String historyWindowSubtitle(int days) {
    return 'Showing bills from the last $days days.';
  }

  @override
  String get historyUpgradeCta => 'Upgrade to Plus';

  @override
  String get monthlyInsightTitle => 'Monthly insight';

  @override
  String monthlyInsightMonth(String month) {
    return '$month spending';
  }

  @override
  String get monthlyInsightLoading => 'Loading monthly insight...';

  @override
  String get monthlyInsightError => 'Could not load monthly insight.';

  @override
  String get monthlyInsightLockedSubtitle =>
      'See monthly totals, trends, outstanding amount, and top merchants with Plus.';

  @override
  String get monthlyInsightTotal => 'This month';

  @override
  String get monthlyInsightAverage => 'Average bill';

  @override
  String get monthlyInsightBills => 'Bills';

  @override
  String get monthlyInsightOutstanding => 'Outstanding';

  @override
  String get monthlyInsightTopMerchants => 'Top merchants';

  @override
  String monthlyInsightIncrease(String percent) {
    return 'Up $percent% vs last month';
  }

  @override
  String monthlyInsightDecrease(String percent) {
    return 'Down $percent% vs last month';
  }

  @override
  String get monthlyInsightNoChange => 'No change vs last month';

  @override
  String get splitSummaryTitle => 'Summary per Person';

  @override
  String get splitSummaryNoItems => 'No items selected.';

  @override
  String get splitSummarySubtotal => 'Subtotal';

  @override
  String get splitSummaryTax => 'Tax (proportional)';

  @override
  String get splitSummaryService => 'Service (proportional)';

  @override
  String get splitSummaryShare => 'Share';

  @override
  String get participantShareAgain => 'Share again';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get exportCsvPlusLocked => 'Export CSV (Plus)';

  @override
  String get exportFailed => 'Could not create the export. Please try again.';

  @override
  String exportCsvSubject(String title) {
    return 'Export $title';
  }

  @override
  String exportCsvShareText(String title) {
    return 'CSV export for $title';
  }

  @override
  String get splitSummaryCopy => 'Copy';

  @override
  String get splitSummaryCopied => 'Copied to clipboard';

  @override
  String get splitShareFailed => 'Could not share';

  @override
  String get settlementTemplateBasic => 'Basic';

  @override
  String get settlementTemplateCompact => 'Compact message';

  @override
  String get settlementTemplateDetailed => 'Detailed message';

  @override
  String get settlementTemplateAll => 'All participants recap';

  @override
  String get settlementTemplatePlusLocked =>
      'Neater WhatsApp templates are available with Plus.';

  @override
  String get settlementMessageBillPrefix => 'Details for';

  @override
  String get settlementMessageRecapPrefix => 'BagiStruk recap -';

  @override
  String get settlementMessageFor => 'For';

  @override
  String settlementMessageGreeting(String name) {
    return 'Hi $name, your share is:';
  }

  @override
  String get settlementMessageTransferNote =>
      'Please transfer if everything looks right. Thank you.';

  @override
  String get settlementMessageItems => 'Your items';

  @override
  String get settlementMessageUnnamedItem => '(unnamed item)';

  @override
  String settlementMessageSharedWith(int count) {
    return 'split by $count';
  }

  @override
  String get settlementMessageTotal => 'Total';

  @override
  String get settlementMessageStatus => 'Status';

  @override
  String get settlementMessagePaid => 'paid';

  @override
  String get settlementMessageUnpaid => 'unpaid';

  @override
  String get settlementMessageGrandTotal => 'Total bill';

  @override
  String get settlementMessageOutstanding => 'Outstanding';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutSettingsTile => 'About App';

  @override
  String get aboutVersionLabel => 'Version';

  @override
  String get aboutSectionApp => 'Application';

  @override
  String get aboutSectionAuthor => 'Author';

  @override
  String get aboutSectionSupport => 'Support';

  @override
  String get aboutAuthorName => 'Alam Aby Bashit';

  @override
  String get aboutWebsite => 'Website';

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
  String get aboutPrivacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get aboutTermsOfService => 'Terms of Service';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get linkUnavailable => 'Link is not available yet';

  @override
  String get reviewSuspectThousandsBug =>
      'Prices look like the thousand separator may have been read as a decimal. Please verify each amount before saving.';

  @override
  String get paywallTitle => 'Save history & track debts';

  @override
  String get paywallSubtitle =>
      'Sign up or log in to save your history and track money you’re owed.';

  @override
  String get paywallRegister => 'Sign Up';

  @override
  String get paywallLogin => 'Sign In';

  @override
  String get scanEmptyHint =>
      'Take a photo of a shopping or dining receipt to start splitting fairly!';
}
