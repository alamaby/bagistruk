// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => _ProfileDto(
  id: json['id'] as String,
  displayName: json['display_name'] as String?,
  defaultCurrency: json['default_currency'] as String? ?? 'USD',
  languagePref: json['language_pref'] as String? ?? 'en',
  themePref: json['theme_pref'] as String? ?? 'system',
  marketingEmailOptIn: json['marketing_email_opt_in'] as bool? ?? false,
  marketingEmailOptInAt: json['marketing_email_opt_in_at'] == null
      ? null
      : DateTime.parse(json['marketing_email_opt_in_at'] as String),
  marketingEmailOptInSource: json['marketing_email_opt_in_source'] as String?,
  acceptedTermsAt: json['accepted_terms_at'] == null
      ? null
      : DateTime.parse(json['accepted_terms_at'] as String),
  acceptedPrivacyAt: json['accepted_privacy_at'] == null
      ? null
      : DateTime.parse(json['accepted_privacy_at'] as String),
  acceptedTermsVersion: (json['accepted_terms_version'] as num?)?.toInt(),
  acceptedPrivacyVersion: (json['accepted_privacy_version'] as num?)?.toInt(),
  welcomedAt: json['welcomed_at'] == null
      ? null
      : DateTime.parse(json['welcomed_at'] as String),
  isAdult: json['is_adult'] as bool? ?? false,
);

Map<String, dynamic> _$ProfileDtoToJson(_ProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': ?instance.displayName,
      'default_currency': instance.defaultCurrency,
      'language_pref': instance.languagePref,
      'theme_pref': instance.themePref,
      'marketing_email_opt_in': instance.marketingEmailOptIn,
      'marketing_email_opt_in_at': ?instance.marketingEmailOptInAt
          ?.toIso8601String(),
      'marketing_email_opt_in_source': ?instance.marketingEmailOptInSource,
      'accepted_terms_at': ?instance.acceptedTermsAt?.toIso8601String(),
      'accepted_privacy_at': ?instance.acceptedPrivacyAt?.toIso8601String(),
      'accepted_terms_version': ?instance.acceptedTermsVersion,
      'accepted_privacy_version': ?instance.acceptedPrivacyVersion,
      'welcomed_at': ?instance.welcomedAt?.toIso8601String(),
      'is_adult': instance.isAdult,
    };
