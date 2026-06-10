import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/format/currency_formatter.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/entities/transfer_bank_info.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../../credits/providers/ocr_credit_status_provider.dart';
import '../../settings/providers/transfer_bank_info_provider.dart';
import '../providers/split_notifier.dart';
import '../utils/settlement_message_builder.dart';
import 'participant_avatar.dart';

/// Bottom-sheet summary listing per-participant items, proportional tax/
/// service, and total. Each row has Copy and Share buttons — Share opens the
/// native OS share sheet so the user can route the breakdown to any app
/// (WhatsApp, Telegram, Email, SMS, etc.).
class SplitSummarySheet extends ConsumerWidget {
  const SplitSummarySheet({super.key, required this.state});

  final SplitState state;

  static Future<void> show(BuildContext context, SplitState state) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => SplitSummarySheet(state: state),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final currency = CurrencyFormatter.of(state.bill.currencyCode);
    final totals = state.calculateTotals();
    final byId = {for (final t in totals) t.participantId: t};
    final creditStatus = switch (ref.watch(ocrCreditStatusProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final isPlus = creditStatus?.isPlus ?? false;
    final bankInfo = isPlus
        ? switch (ref.watch(transferBankInfoProvider)) {
            AsyncData(:final value) => value,
            _ => null,
          }
        : null;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollCtrl) => Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
        child: ListView(
          controller: scrollCtrl,
          children: [
            Text(
              l10n.splitSummaryTitle,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4.h),
            Text(
              state.bill.title,
              style: TextStyle(
                fontSize: 13.sp,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            SizedBox(height: 16.h),
            for (final p in state.participants)
              _ParticipantSummaryCard(
                participant: p,
                items: state.itemsForParticipant(p.id),
                total: byId[p.id]!,
                bill: state,
                currency: currency,
                l10n: l10n,
                isPlus: isPlus,
                bankInfo: bankInfo,
              ),
          ],
        ),
      ),
    );
  }
}

class _ParticipantSummaryCard extends StatelessWidget {
  const _ParticipantSummaryCard({
    required this.participant,
    required this.items,
    required this.total,
    required this.bill,
    required this.currency,
    required this.l10n,
    required this.isPlus,
    required this.bankInfo,
  });

  final Participant participant;
  final List<ParticipantItemShare> items;
  final ParticipantTotal total;
  final SplitState bill;
  final NumberFormat currency;
  final AppL10n l10n;
  final bool isPlus;
  final TransferBankInfo? bankInfo;

  SettlementMessageBuilder get _messageBuilder => SettlementMessageBuilder(
    state: bill,
    currency: currency,
    l10n: l10n,
    bankInfo: bankInfo,
  );

  Future<void> _shareSystem(BuildContext context) async {
    try {
      final template = await _chooseTemplate(context, l10n.splitSummaryShare);
      if (template == null) return;
      await Share.share(
        _messageBuilder.build(
          template: template,
          participantId: participant.id,
        ),
        subject:
            '${l10n.settlementMessageBillPrefix} ${bill.bill.title} - ${participant.name}',
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.splitShareFailed)));
      }
    }
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    final template = await _chooseTemplate(context, l10n.splitSummaryCopy);
    if (template == null) return;
    await Clipboard.setData(
      ClipboardData(
        text: _messageBuilder.build(
          template: template,
          participantId: participant.id,
        ),
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.splitSummaryCopied)));
    }
  }

  Future<SettlementMessageTemplate?> _chooseTemplate(
    BuildContext context,
    String title,
  ) async {
    if (!isPlus) return SettlementMessageTemplate.basic;

    return showModalBottomSheet<SettlementMessageTemplate>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 8.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            _TemplateTile(
              icon: Icons.notes_outlined,
              title: l10n.settlementTemplateBasic,
              onTap: () =>
                  Navigator.of(ctx).pop(SettlementMessageTemplate.basic),
            ),
            _TemplateTile(
              icon: Icons.short_text,
              title: l10n.settlementTemplateCompact,
              isPlus: true,
              onTap: () =>
                  Navigator.of(ctx).pop(SettlementMessageTemplate.compactPlus),
            ),
            _TemplateTile(
              icon: Icons.format_list_bulleted,
              title: l10n.settlementTemplateDetailed,
              isPlus: true,
              onTap: () =>
                  Navigator.of(ctx).pop(SettlementMessageTemplate.detailedPlus),
            ),
            _TemplateTile(
              icon: Icons.groups_outlined,
              title: l10n.settlementTemplateAll,
              isPlus: true,
              onTap: () =>
                  Navigator.of(ctx).pop(SettlementMessageTemplate.allPlus),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ParticipantAvatar(
                id: participant.id,
                name: participant.name,
                size: 40,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  participant.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                currency.format(total.total),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Text(
                l10n.splitSummaryNoItems,
                style: TextStyle(fontSize: 13.sp, color: scheme.outline),
              ),
            )
          else
            for (final s in items)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        s.item.name.isEmpty
                            ? l10n.settlementMessageUnnamedItem
                            : s.item.name,
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ),
                    if (s.sharedWith > 1)
                      Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: Text(
                          '÷${s.sharedWith}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: scheme.outline,
                          ),
                        ),
                      ),
                    Text(
                      currency.format(s.share),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          if (total.tax > 0 || total.service > 0) ...[
            SizedBox(height: 8.h),
            Divider(height: 1, color: scheme.outlineVariant),
            SizedBox(height: 8.h),
            _SummaryLine(
              label: l10n.splitSummarySubtotal,
              value: currency.format(total.subtotal),
            ),
            if (total.tax > 0)
              _SummaryLine(
                label: l10n.splitSummaryTax,
                value: currency.format(total.tax),
              ),
            if (total.service > 0)
              _SummaryLine(
                label: l10n.splitSummaryService,
                value: currency.format(total.service),
              ),
          ],
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _copyToClipboard(context),
                  icon: const Icon(Icons.content_copy, size: 18),
                  label: Text(l10n.splitSummaryCopy),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(40.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => _shareSystem(context),
                  icon: const Icon(Icons.share, size: 18),
                  label: Text(l10n.splitSummaryShare),
                  style: FilledButton.styleFrom(
                    minimumSize: Size.fromHeight(40.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (!isPlus) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.workspace_premium_outlined,
                  size: 16.r,
                  color: scheme.onSurfaceVariant,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    l10n.settlementTemplatePlusLocked,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TemplateTile extends StatelessWidget {
  const _TemplateTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isPlus = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isPlus;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: isPlus
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                'Plus',
                style: TextStyle(
                  color: scheme.onPrimaryContainer,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
