import '../providers/bill_detail_notifier.dart';

class BillCsvExporter {
  const BillCsvExporter(this.state);

  final BillDetailState state;

  String build() {
    final rows = <List<Object?>>[
      ['BagiStruk Bill Export'],
      [],
      ['Bill'],
      ['Title', state.bill.title],
      ['Currency', state.bill.currencyCode],
      ['Receipt date', state.bill.receiptDate?.toIso8601String() ?? ''],
      ['Created at', state.bill.createdAt.toIso8601String()],
      ['Total amount', state.bill.totalAmount],
      ['Tax', state.bill.tax],
      ['Service', state.bill.service],
      ['Settled', state.bill.isSettled ? 'yes' : 'no'],
      [],
      ['Items'],
      ['Item', 'Qty', 'Price', 'Subtotal', 'Assigned participants'],
    ];

    final participantById = {
      for (final participant in state.participants) participant.id: participant,
    };
    for (final item in state.items) {
      final assigneeNames = state.assignments
          .where((assignment) => assignment.itemId == item.id)
          .map((assignment) => participantById[assignment.participantId]?.name)
          .whereType<String>()
          .join(', ');
      rows.add([item.name, item.qty, item.price, item.subtotal, assigneeNames]);
    }

    rows.addAll([
      [],
      ['Participants'],
      ['Name', 'Subtotal', 'Tax', 'Service', 'Total', 'Status'],
    ]);
    final totalsByParticipant = {
      for (final total in state.calculateTotals()) total.participantId: total,
    };
    for (final participant in state.participants) {
      final total = totalsByParticipant[participant.id];
      rows.add([
        participant.name,
        total?.subtotal ?? 0,
        total?.tax ?? 0,
        total?.service ?? 0,
        total?.total ?? 0,
        participant.isPaid ? 'paid' : 'unpaid',
      ]);
    }

    return rows.map(_encodeRow).join('\r\n');
  }

  static String _encodeRow(List<Object?> row) =>
      row.map((value) => _encodeCell(value?.toString() ?? '')).join(',');

  static String _encodeCell(String value) {
    final needsQuote =
        value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r');
    final escaped = value.replaceAll('"', '""');
    return needsQuote ? '"$escaped"' : escaped;
  }
}
