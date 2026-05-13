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
  String get splitSummaryCopy => 'Copy';

  @override
  String get splitSummaryCopied => 'Copied to clipboard';

  @override
  String get splitShareFailed => 'Could not share';

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
