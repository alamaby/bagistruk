import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_summary.freezed.dart';

@freezed
abstract class HistorySummary with _$HistorySummary {
  const factory HistorySummary({
    required int totalBillCount,
    required List<String> availableCurrencies,
    required List<OutstandingByCurrency> outstanding,
  }) = _HistorySummary;

  const HistorySummary._();
}

@freezed
abstract class OutstandingByCurrency with _$OutstandingByCurrency {
  const factory OutstandingByCurrency({
    required String currency,
    required double amount,
  }) = _OutstandingByCurrency;
}
