// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_participant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavedParticipantDto _$SavedParticipantDtoFromJson(Map<String, dynamic> json) =>
    _SavedParticipantDto(
      name: json['name'] as String,
      phone: json['phone'] as String? ?? '',
      useCount: (json['use_count'] as num?)?.toInt() ?? 1,
      lastUsedAt: DateTime.parse(json['last_used_at'] as String),
    );

Map<String, dynamic> _$SavedParticipantDtoToJson(
  _SavedParticipantDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'phone': instance.phone,
  'use_count': instance.useCount,
  'last_used_at': instance.lastUsedAt.toIso8601String(),
};
