// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HistorySummaryDto _$HistorySummaryDtoFromJson(Map<String, dynamic> json) =>
    _HistorySummaryDto(
      totalBillCount: (json['total_bill_count'] as num).toInt(),
      availableCurrencies: (json['available_currencies'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      outstanding: (json['outstanding_by_currency'] as List<dynamic>)
          .map((e) => OutstandingDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HistorySummaryDtoToJson(_HistorySummaryDto instance) =>
    <String, dynamic>{
      'total_bill_count': instance.totalBillCount,
      'available_currencies': instance.availableCurrencies,
      'outstanding_by_currency': instance.outstanding
          .map((e) => e.toJson())
          .toList(),
    };

_OutstandingDto _$OutstandingDtoFromJson(Map<String, dynamic> json) =>
    _OutstandingDto(
      currency: json['currency'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$OutstandingDtoToJson(_OutstandingDto instance) =>
    <String, dynamic>{'currency': instance.currency, 'amount': instance.amount};
