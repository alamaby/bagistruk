class DeletedBill {
  const DeletedBill({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.currencyCode,
    required this.isSettled,
    required this.createdAt,
    required this.deletedAt,
    required this.deleteExpiresAt,
  });

  final String id;
  final String title;
  final double totalAmount;
  final String currencyCode;
  final bool isSettled;
  final DateTime createdAt;
  final DateTime deletedAt;
  final DateTime deleteExpiresAt;

  bool get isExpired => deleteExpiresAt.isBefore(DateTime.now().toUtc());
}
