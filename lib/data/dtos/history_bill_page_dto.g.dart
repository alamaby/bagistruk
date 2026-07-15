// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_bill_page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HistoryBillPageDto _$HistoryBillPageDtoFromJson(Map<String, dynamic> json) =>
    _HistoryBillPageDto(
      bills: (json['bills'] as List<dynamic>)
          .map((e) => HistoryBillDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      cursor: json['cursor'] == null
          ? null
          : HistoryCursorDto.fromJson(json['cursor'] as Map<String, dynamic>),
      hasMore: json['has_more'] as bool,
    );

Map<String, dynamic> _$HistoryBillPageDtoToJson(_HistoryBillPageDto instance) =>
    <String, dynamic>{
      'bills': instance.bills.map((e) => e.toJson()).toList(),
      'cursor': ?instance.cursor?.toJson(),
      'has_more': instance.hasMore,
    };
