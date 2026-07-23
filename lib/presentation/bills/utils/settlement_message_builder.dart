import 'package:intl/intl.dart';

import '../../../core/format/phone_formatter.dart';
import '../../../domain/entities/transfer_bank_info.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../providers/split_notifier.dart';

enum SettlementMessageTemplate { basic, compactPlus, detailedPlus, allPlus }

class SettlementMessageBuilder {
  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.alamaby.bagistruk';

  const SettlementMessageBuilder({
    required this.state,
    required this.currency,
    required this.l10n,
    this.bankInfo,
  });

  final SplitState state;
  final NumberFormat currency;
  final AppL10n l10n;
  final TransferBankInfo? bankInfo;

  String build({
    required SettlementMessageTemplate template,
    String? participantId,
    bool includeWhatsappLink = true,
  }) {
    if (template == SettlementMessageTemplate.allPlus) {
      return _buildAllParticipants();
    }

    final participant = state.participants.firstWhere(
      (p) => p.id == participantId,
      orElse: () => state.participants.first,
    );
    final total = state.calculateTotals().firstWhere(
      (t) => t.participantId == participant.id,
    );
    final items = state.itemsForParticipant(participant.id);
    final waLink = includeWhatsappLink
        ? PhoneFormatter.waMeLink(participant.phone)
        : null;

    return switch (template) {
      SettlementMessageTemplate.basic => _buildBasic(
        participantName: participant.name,
        items: items,
        total: total,
        waLink: waLink,
      ),
      SettlementMessageTemplate.compactPlus => _buildCompact(
        participantName: participant.name,
        total: total,
        waLink: waLink,
      ),
      SettlementMessageTemplate.detailedPlus => _buildDetailed(
        participantName: participant.name,
        isPaid: participant.isPaid,
        items: items,
        total: total,
        waLink: waLink,
      ),
      SettlementMessageTemplate.allPlus => _buildAllParticipants(),
    };
  }

  String _buildBasic({
    required String participantName,
    required List<ParticipantItemShare> items,
    required ParticipantTotal total,
    String? waLink,
  }) {
    final buf = StringBuffer();
    buf.writeln('*${l10n.settlementMessageBillPrefix} ${state.bill.title}*');
    buf.writeln('${l10n.settlementMessageFor}: $participantName');
    buf.writeln();
    _writeItems(buf, items);
    buf.writeln();
    _writeTotals(buf, total, emphasizeTotal: true);
    _writeBankInfoIfAny(buf);
    if (waLink != null) {
      buf.writeln();
      buf.writeln(l10n.settlementMessageWhatsappLink(waLink));
    }
    _writePromoFooter(buf);
    return buf.toString();
  }

  String _buildCompact({
    required String participantName,
    required ParticipantTotal total,
    String? waLink,
  }) {
    final buf = StringBuffer();
    buf.writeln('*${l10n.settlementMessageCompactTitle(state.bill.title)}*');
    buf.writeln();
    buf.writeln(l10n.settlementMessageGreeting(participantName));
    buf.writeln('*${currency.format(total.total)}*');
    buf.writeln();
    buf.writeln(
      '${l10n.splitSummarySubtotal}: ${currency.format(total.subtotal)}',
    );
    if (total.tax > 0) {
      buf.writeln('${l10n.splitSummaryTax}: ${currency.format(total.tax)}');
    }
    if (total.service > 0) {
      buf.writeln(
        '${l10n.splitSummaryService}: ${currency.format(total.service)}',
      );
    }
    buf.writeln();
    buf.writeln(l10n.settlementMessageTransferNote);
    _writeBankInfoIfAny(buf);
    if (waLink != null) {
      buf.writeln();
      buf.writeln(l10n.settlementMessageWhatsappLink(waLink));
    }
    _writePromoFooter(buf);
    return buf.toString();
  }

  String _buildDetailed({
    required String participantName,
    required bool isPaid,
    required List<ParticipantItemShare> items,
    required ParticipantTotal total,
    String? waLink,
  }) {
    final buf = StringBuffer();
    buf.writeln('*${l10n.settlementMessageDetailedTitle(state.bill.title)}*');
    buf.writeln('${l10n.settlementMessageFor}: *$participantName*');
    buf.writeln();
    _writeItems(buf, items);
    buf.writeln();
    _writeTotals(buf, total, emphasizeTotal: true);
    buf.writeln(
      '${l10n.settlementMessageStatus}: ${isPaid ? l10n.settlementMessagePaid : l10n.settlementMessageUnpaid}',
    );
    _writeBankInfoIfAny(buf);
    if (waLink != null) {
      buf.writeln();
      buf.writeln(l10n.settlementMessageWhatsappLink(waLink));
    }
    _writePromoFooter(buf);
    return buf.toString();
  }

  String _buildAllParticipants() {
    final totals = state.calculateTotals();
    final totalById = {for (final t in totals) t.participantId: t};
    final outstanding = state.participants
        .where((p) => !p.isPaid)
        .fold<double>(0, (sum, p) => sum + (totalById[p.id]?.total ?? 0));

    final buf = StringBuffer();
    buf.writeln('*${l10n.settlementMessageRecapPrefix} ${state.bill.title}*');
    buf.writeln();
    for (final participant in state.participants) {
      final total = totalById[participant.id]?.total ?? 0;
      final status = participant.isPaid
          ? l10n.settlementMessagePaid
          : l10n.settlementMessageUnpaid;
      buf.writeln('• ${participant.name}: ${currency.format(total)} - $status');
    }
    buf.writeln();
    buf.writeln(
      '${l10n.settlementMessageGrandTotal}: ${currency.format(state.bill.totalAmount)}',
    );
    buf.writeln(
      '${l10n.settlementMessageOutstanding}: ${currency.format(outstanding)}',
    );
    _writeBankInfoIfAny(buf);
    _writePromoFooter(buf);
    return buf.toString();
  }

  void _writeItems(StringBuffer buf, List<ParticipantItemShare> items) {
    if (items.isEmpty) {
      buf.writeln('_${l10n.splitSummaryNoItems}_');
      return;
    }

    buf.writeln('*${l10n.settlementMessageItems}:*');
    for (final share in items) {
      final name = share.item.name.isEmpty
          ? l10n.settlementMessageUnnamedItem
          : share.item.name;
      final shareNote = share.sharedWith > 1
          ? ' (${l10n.settlementMessageSharedWith(share.sharedWith)})'
          : '';
      buf.writeln('• $name$shareNote - ${currency.format(share.share)}');
    }
  }

  void _writeTotals(
    StringBuffer buf,
    ParticipantTotal total, {
    required bool emphasizeTotal,
  }) {
    buf.writeln(
      '${l10n.splitSummarySubtotal}: ${currency.format(total.subtotal)}',
    );
    if (total.tax > 0) {
      buf.writeln('${l10n.splitSummaryTax}: ${currency.format(total.tax)}');
    }
    if (total.service > 0) {
      buf.writeln(
        '${l10n.splitSummaryService}: ${currency.format(total.service)}',
      );
    }
    final totalLine =
        '${l10n.settlementMessageTotal}: ${currency.format(total.total)}';
    buf.writeln(emphasizeTotal ? '*$totalLine*' : totalLine);
  }

  void _writeBankInfoIfAny(StringBuffer buf) {
    final info = bankInfo;
    if (info == null || !info.isComplete) return;
    buf.writeln();
    buf.writeln('*${l10n.transferBankShareTitle}:*');
    buf.writeln('${l10n.transferBankNameLabel}: ${info.bankName.trim()}');
    buf.writeln('${l10n.transferAccountNameLabel}: ${info.accountName.trim()}');
    buf.writeln(
      '${l10n.transferAccountNumberLabel}: ${info.accountNumber.trim()}',
    );
  }

  void _writePromoFooter(StringBuffer buf) {
    buf.writeln();
    buf.writeln(l10n.settlementPromoFooter(_playStoreUrl));
  }
}
