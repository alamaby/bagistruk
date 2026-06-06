class TransferBankInfo {
  const TransferBankInfo({
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
  });

  final String bankName;
  final String accountName;
  final String accountNumber;

  bool get isComplete =>
      bankName.trim().isNotEmpty &&
      accountName.trim().isNotEmpty &&
      accountNumber.trim().isNotEmpty;

  static TransferBankInfo? fromProfileRow(Map<String, dynamic> row) {
    final bankName = (row['transfer_bank_name'] as String?)?.trim() ?? '';
    final accountName = (row['transfer_account_name'] as String?)?.trim() ?? '';
    final accountNumber =
        (row['transfer_account_number'] as String?)?.trim() ?? '';
    final info = TransferBankInfo(
      bankName: bankName,
      accountName: accountName,
      accountNumber: accountNumber,
    );
    return info.isComplete ? info : null;
  }
}
