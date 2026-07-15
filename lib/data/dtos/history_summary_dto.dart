import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/history_summary.dart';

part 'history_summary_dto.freezed.dart';
part 'history_summary_dto.g.dart';

@freezed
abstract class HistorySummaryDto with _$HistorySummaryDto {
  const factory HistorySummaryDto({
    @JsonKey(name: 'total_bill_count') required int totalBillCount,
    @JsonKey(name: 'available_currencies')
    required List<String> availableCurrencies,
    @JsonKey(name: 'outstanding_by_currency')
    required List<OutstandingDto> outstanding,
  }) = _HistorySummaryDto;

  factory HistorySummaryDto.fromJson(Map<String, dynamic> json) =>
      _$HistorySummaryDtoFromJson(json);
}

extension HistorySummaryDtoX on HistorySummaryDto {
  HistorySummary toEntity() => HistorySummary(
    totalBillCount: totalBillCount,
    availableCurrencies: availableCurrencies,
    outstanding: outstanding.map((o) => o.toEntity()).toList(growable: false),
  );
}

@freezed
abstract class OutstandingDto with _$OutstandingDto {
  const factory OutstandingDto({
    required String currency,
    required double amount,
  }) = _OutstandingDto;

  factory OutstandingDto.fromJson(Map<String, dynamic> json) =>
      _$OutstandingDtoFromJson(json);
}

extension OutstandingDtoX on OutstandingDto {
  OutstandingByCurrency toEntity() => OutstandingByCurrency(
    currency: currency,
    amount: amount,
  );
}
