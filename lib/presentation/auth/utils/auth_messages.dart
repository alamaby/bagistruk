import '../../../core/error/failure.dart';
import '../../../l10n/generated/app_l10n.dart';

/// Maps repository [Failure] variants to user-facing messages used in SnackBars
/// on the auth screens. Keep wording short and friendly.
String friendlyAuthMessage(Failure failure, AppL10n l10n) {
  return switch (failure) {
    AuthFailure(:final message) => _humanizeAuth(message, l10n),
    NetworkFailure() => l10n.authErrorNetwork,
    ServerFailure(:final message) => l10n.authErrorServer(message),
    ParsingFailure() => l10n.authErrorParsing,
    UnknownFailure() => l10n.authErrorUnknown,
  };
}

String _humanizeAuth(String raw, AppL10n l10n) {
  final lower = raw.toLowerCase();
  if (lower.contains('invalid login') ||
      lower.contains('invalid credentials')) {
    return l10n.authErrorInvalidLogin;
  }
  if (lower.contains('already registered') || lower.contains('user already')) {
    return l10n.authErrorAlreadyRegistered;
  }
  if (lower.contains('weak password') || lower.contains('password should')) {
    return l10n.authErrorWeakPassword;
  }
  if (lower.contains('email not confirmed')) {
    return l10n.authErrorEmailNotConfirmed;
  }
  if (lower.contains('disposable_email')) {
    return l10n.authErrorDisposableEmail;
  }
  if (lower.contains('email_alias_already_used')) {
    return l10n.authErrorEmailAliasUsed;
  }
  if (lower.contains('invalid_email')) {
    return l10n.authErrorInvalidEmail;
  }
  if (lower.contains('oauth android') || lower.contains('google sign-in')) {
    return l10n.authErrorGoogleSignIn;
  }
  if (lower.contains('coming soon')) {
    return l10n.authErrorComingSoon;
  }
  return raw.isEmpty ? l10n.authErrorFallback : raw;
}
