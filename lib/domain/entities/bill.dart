import 'package:freezed_annotation/freezed_annotation.dart';

import 'bill_payment_status.dart';

part 'bill.freezed.dart';

@freezed
abstract class Bill with _$Bill {
  const Bill._();

  const factory Bill({
    required String id,
    required String title,
    required double totalAmount,
    @Default('IDR') String currencyCode,
    @Default(0) double tax,
    @Default(0) double service,
    @Default(false) bool isSettled,
    DateTime? receiptDate,
    required DateTime createdAt,
    @Default([]) List<bool> participantPaymentStatuses,
  }) = _Bill;

  BillPaymentStatus get paymentStatus {
    if (participantPaymentStatuses.isEmpty) return BillPaymentStatus.unassigned;
    if (participantPaymentStatuses.every((p) => p)) return BillPaymentStatus.settled;
    if (participantPaymentStatuses.any((p) => p)) return BillPaymentStatus.partial;
    return BillPaymentStatus.unpaid;
  }
}
