import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../domain/entities/participant.dart';
import '../../../domain/entities/transfer_bank_info.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../providers/bill_detail_notifier.dart';
import '../providers/split_notifier.dart' show ParticipantTotal;

class BillPdfExporter {
  const BillPdfExporter({
    required this.state,
    required this.currency,
    required this.dateFormat,
    required this.l10n,
    this.bankInfo,
  });

  final BillDetailState state;
  final NumberFormat currency;
  final DateFormat dateFormat;
  final AppL10n l10n;
  final TransferBankInfo? bankInfo;

  Future<Uint8List> build() async {
    final doc = pw.Document(
      title: 'BagiStruk - ${state.bill.title}',
      author: 'BagiStruk',
    );
    final totalsByParticipant = {
      for (final total in state.calculateTotals()) total.participantId: total,
    };
    final participantById = {
      for (final participant in state.participants) participant.id: participant,
    };

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
          ),
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'BagiStruk - ${context.pageNumber}/${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ),
        build: (context) => [
          pw.Text(
            'BagiStruk',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            state.bill.title,
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            dateFormat.format(state.bill.receiptDate ?? state.bill.createdAt),
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 20),
          _summaryBox(),
          pw.SizedBox(height: 20),
          _sectionTitle('Items'),
          _itemsTable(participantById),
          pw.SizedBox(height: 20),
          _sectionTitle('Participants'),
          _participantsTable(totalsByParticipant),
          if (bankInfo?.isComplete ?? false) ...[
            pw.SizedBox(height: 20),
            _sectionTitle(l10n.transferBankShareTitle),
            _bankInfoBox(bankInfo!),
          ],
        ],
      ),
    );

    return doc.save();
  }

  pw.Widget _summaryBox() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _summaryTextRow('Currency', state.bill.currencyCode),
          _summaryRow(l10n.settlementMessageGrandTotal, state.bill.totalAmount),
          _summaryRow(l10n.splitSummaryTax, state.bill.tax),
          _summaryRow(l10n.splitSummaryService, state.bill.service),
          pw.SizedBox(height: 6),
          pw.Text(
            '${l10n.settlementMessageStatus}: ${state.bill.isSettled ? l10n.settlementMessagePaid : l10n.settlementMessageUnpaid}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  pw.Widget _summaryRow(String label, double value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [pw.Text(label), pw.Text(currency.format(value))],
      ),
    );
  }

  pw.Widget _summaryTextRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [pw.Text(label), pw.Text(value)],
      ),
    );
  }

  pw.Widget _sectionTitle(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _itemsTable(Map<String, Participant> participantById) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellPadding: const pw.EdgeInsets.all(6),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.5),
        1: const pw.FlexColumnWidth(0.8),
        2: const pw.FlexColumnWidth(1.3),
        3: const pw.FlexColumnWidth(1.3),
        4: const pw.FlexColumnWidth(2.5),
      },
      headers: ['Item', 'Qty', 'Price', 'Subtotal', 'Participants'],
      data: state.items.map((item) {
        final assignees = state.assignments
            .where((assignment) => assignment.itemId == item.id)
            .map(
              (assignment) => participantById[assignment.participantId]?.name,
            )
            .whereType<String>()
            .join(', ');
        return [
          item.name.isEmpty ? l10n.settlementMessageUnnamedItem : item.name,
          item.qty.toString(),
          currency.format(item.price),
          currency.format(item.subtotal),
          assignees,
        ];
      }).toList(),
    );
  }

  pw.Widget _participantsTable(
    Map<String, ParticipantTotal> totalsByParticipant,
  ) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellPadding: const pw.EdgeInsets.all(6),
      headers: ['Name', 'Subtotal', 'Tax', 'Service', 'Total', 'Status'],
      data: state.participants.map((participant) {
        final total = totalsByParticipant[participant.id];
        return [
          participant.name,
          currency.format(total?.subtotal ?? 0),
          currency.format(total?.tax ?? 0),
          currency.format(total?.service ?? 0),
          currency.format(total?.total ?? 0),
          participant.isPaid
              ? l10n.settlementMessagePaid
              : l10n.settlementMessageUnpaid,
        ];
      }).toList(),
    );
  }

  pw.Widget _bankInfoBox(TransferBankInfo info) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('${l10n.transferBankNameLabel}: ${info.bankName.trim()}'),
          pw.Text(
            '${l10n.transferAccountNameLabel}: ${info.accountName.trim()}',
          ),
          pw.Text(
            '${l10n.transferAccountNumberLabel}: ${info.accountNumber.trim()}',
          ),
        ],
      ),
    );
  }
}
