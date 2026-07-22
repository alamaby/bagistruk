import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_snapshot.freezed.dart';

@freezed
sealed class AuthSnapshot with _$AuthSnapshot {
  const factory AuthSnapshot({
    required String? userId,
    required bool isAnonymous,
    @Default(false) bool emailConfirmed,
    // True when the current session was established by a Supabase
    // password-recovery callback (`type=recovery` deep link). The router
    // uses this to route the user to the reset-password form instead of
    // the normal scan/history entry points.
    @Default(false) bool isPasswordRecovery,
  }) = _AuthSnapshot;

  const AuthSnapshot._();

  // Supabase flips `is_anonymous = false` the moment `updateUser` runs, even
  // when email confirmation is required and `emailConfirmedAt` is still null.
  // Treat the user as truly signed in only after the email link is clicked so
  // the verify-email screen gets to do its job.
  bool get isSignedIn => userId != null && !isAnonymous && emailConfirmed;
}
