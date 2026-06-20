import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/format/phone_formatter.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/transfer_bank_info.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../providers/split_notifier.dart';
import 'settlement_message_builder.dart';

/// Canonical share launcher for per-participant settlement messages.
///
/// Opens WhatsApp directly when [participant] has a parseable phone number,
/// otherwise falls back to the native OS share sheet. Both paths share the
/// same [SettlementMessageBuilder] so the message format stays consistent
/// whether invoked from Bill Details or Split Summary.
Future<void> launchSettlementShare({
  required BuildContext context,
  required Participant participant,
  required SplitState state,
  required NumberFormat currency,
  required AppL10n l10n,
  required SettlementMessageTemplate template,
  required String subject,
  TransferBankInfo? bankInfo,
}) async {
  try {
    final message =
        SettlementMessageBuilder(
          state: state,
          currency: currency,
          l10n: l10n,
          bankInfo: bankInfo,
        ).build(
          template: template,
          participantId: participant.id,
          includeWhatsappLink: false,
        );
    final waLink = PhoneFormatter.waMeLink(participant.phone);
    if (waLink != null) {
      final uri = Uri.parse('$waLink?text=${Uri.encodeComponent(message)}');
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      await Share.share(message, subject: subject);
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.splitShareFailed)));
    }
  }
}
