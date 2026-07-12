import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_dto.freezed.dart';
part 'profile_dto.g.dart';

@freezed
abstract class ProfileDto with _$ProfileDto {
  const ProfileDto._();

  const factory ProfileDto({
    required String id,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'default_currency') @Default('USD') String defaultCurrency,
    @JsonKey(name: 'language_pref') @Default('en') String languagePref,
    @JsonKey(name: 'theme_pref') @Default('system') String themePref,
    @JsonKey(name: 'marketing_email_opt_in')
    @Default(false)
    bool marketingEmailOptIn,
    @JsonKey(name: 'marketing_email_opt_in_at') DateTime? marketingEmailOptInAt,
    @JsonKey(name: 'marketing_email_opt_in_source')
    String? marketingEmailOptInSource,
    @JsonKey(name: 'accepted_terms_at') DateTime? acceptedTermsAt,
    @JsonKey(name: 'accepted_privacy_at') DateTime? acceptedPrivacyAt,
    @JsonKey(name: 'accepted_terms_version') int? acceptedTermsVersion,
    @JsonKey(name: 'accepted_privacy_version') int? acceptedPrivacyVersion,
    @JsonKey(name: 'welcomed_at') DateTime? welcomedAt,
    @JsonKey(name: 'onboarding_completed_at') DateTime? onboardingCompletedAt,
    @JsonKey(name: 'onboarding_version') @Default(1) int onboardingVersion,
    @JsonKey(name: 'is_adult') @Default(false) bool isAdult,
  }) = _ProfileDto;

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);
}
