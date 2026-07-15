enum BillPaymentStatus {
  unassigned,
  unpaid,
  partial,
  settled;

  bool get isFinalStatus => this == BillPaymentStatus.settled;
}
