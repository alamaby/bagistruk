import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    String? displayName,
    String? email,
    @Default('USD') String defaultCurrency,
    @Default('en') String languagePref,
    @Default('system') String themePref,
    @Default(false) bool isAnonymous,
    // Marketing email opt-in (GDPR / CAN-SPAM). Defaults to FALSE; user must
    // explicitly opt in via the register form, the post-login welcome, or
    // the Settings toggle.
    @Default(false) bool marketingEmailOptIn,
    DateTime? marketingEmailOptInAt,
    String? marketingEmailOptInSource,
    // Legal acceptance. Version fields let the router force re-acceptance
    // when the corresponding document changes in `app_config`.
    DateTime? acceptedTermsAt,
    DateTime? acceptedPrivacyAt,
    int? acceptedTermsVersion,
    int? acceptedPrivacyVersion,
    // Post-login welcome gate. Set once when a non-anonymous user finishes
    // the post-login welcome (Google sign-in flow). Email/password sign-up
    // sets it directly after `signUp` so the welcome screen is skipped.
    DateTime? welcomedAt,
    // User-declared age 18+ (or older if required by local law). Drives the
    // AdMob `setTagForUnderAgeOfConsent` call so users below the age of
    // consent only see non-personalized ads. Default FALSE so the app
    // behaves conservatively until the user explicitly declares adult age
    // during the legal acceptance flow.
    @Default(false) bool isAdult,
  }) = _UserProfile;
}
