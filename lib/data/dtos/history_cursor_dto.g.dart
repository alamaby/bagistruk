// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_cursor_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HistoryCursorDto _$HistoryCursorDtoFromJson(Map<String, dynamic> json) =>
    _HistoryCursorDto(
      sortValue: json['sort_value'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      id: json['id'] as String,
    );

Map<String, dynamic> _$HistoryCursorDtoToJson(_HistoryCursorDto instance) =>
    <String, dynamic>{
      'sort_value': instance.sortValue,
      'created_at': instance.createdAt.toIso8601String(),
      'id': instance.id,
    };
