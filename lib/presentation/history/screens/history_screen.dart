import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/billing/plus_feature_limits.dart';
import '../../../core/error/result.dart';
import '../../../core/format/currency_formatter.dart';
import '../../../core/router/routes.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/bill.dart';
import '../../../domain/entities/monthly_spending_insight.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../../ads/widgets/banner_ad_widget.dart';
import '../../bills/providers/bill_list_notifier.dart';
import '../../credits/providers/ocr_credit_status_provider.dart';
import '../../insights/providers/monthly_spending_insight_provider.dart';
import '../../settings/providers/preferences_providers.dart';
import '../../shared/widgets/loading_view.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final bills = ref.watch(billListProvider);
    final creditStatusAsync = ref.watch(ocrCreditStatusProvider);
    final creditStatus = switch (creditStatusAsync) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final defaultCurrency = ref.watch(currencyPrefProvider);
    final insightCurrency = CurrencyFormatter.of(defaultCurrency);
    final planCode = creditStatus?.planCode;
    final isPlus = creditStatus?.isPlus ?? false;
    final historyDays = PlusFeatureLimits.historyDays(planCode: planCode);
    final hasHistoryAccess = historyDays > 0;
    final monthlyInsight = ref.watch(monthlySpendingInsightProvider);

    return Scaffold(
      body: SafeArea(
        child: bills.when(
          loading: () => LoadingView(message: l10n.historyLoadingMessage),
          error: (e, _) => _ErrorView(
            message: e.toString(),
            onRetry: () => ref.read(billListProvider.notifier).refresh(),
          ),
          data: (list) => RefreshIndicator(
            onRefresh: () => ref.read(billListProvider.notifier).refresh(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text(l10n.historyTab),
                  pinned: true,
                  actions: [
                    IconButton(
                      tooltip: l10n.historySignOutTooltip,
                      icon: const Icon(Icons.logout),
                      onPressed: () => _signOut(context, ref),
                    ),
                  ],
                ),
                SliverToBoxAdapter(child: _SummaryCards(bills: list)),
                SliverToBoxAdapter(
                  child: _HistoryAccessBanner(
                    isPlus: isPlus,
                    hasHistoryAccess: hasHistoryAccess,
                    days: historyDays,
                  ),
                ),
                if (hasHistoryAccess && list.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _MonthlyInsightSection(
                      isPlus: isPlus,
                      insight: monthlyInsight,
                      currency: insightCurrency,
                    ),
                  ),
                if (list.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    sliver: SliverList.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, _) => SizedBox(height: 8.h),
                      itemBuilder: (context, i) {
                        final bill = list[i];
                        final currency = CurrencyFormatter.of(
                          bill.currencyCode,
                        );
                        return Card(
                          child: ListTile(
                            title: Text(bill.title),
                            subtitle: Text(currency.format(bill.totalAmount)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: l10n.deleteBillAction,
                                  onPressed: () => _deleteBill(
                                    context,
                                    ref,
                                    bill,
                                    currency.format(bill.totalAmount),
                                  ),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                                bill.isSettled
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : const Icon(Icons.chevron_right),
                              ],
                            ),
                            onTap: () => context.pushNamed(
                              Routes.billDetailName,
                              pathParameters: {'billId': bill.id},
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                const SliverToBoxAdapter(child: BannerAdWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final l10n = AppL10n.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
    await repo.signInAnonymously();
    if (!context.mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.historySignedOut),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteBill(
    BuildContext context,
    WidgetRef ref,
    Bill bill,
    String formattedTotal,
  ) async {
    final l10n = AppL10n.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteBillConfirmTitle),
        content: Text(l10n.deleteBillConfirmBody(bill.title, formattedTotal)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.errorContainer,
              foregroundColor: Theme.of(ctx).colorScheme.onErrorContainer,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.deleteBillAction),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    final result = await ref
        .read(billListProvider.notifier)
        .deleteBill(bill.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result is Success<void> ? l10n.deleteBillSuccess : l10n.errorGeneric,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _MonthlyInsightSection extends StatelessWidget {
  const _MonthlyInsightSection({
    required this.isPlus,
    required this.insight,
    required this.currency,
  });

  final bool isPlus;
  final AsyncValue<MonthlySpendingInsight?> insight;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    if (!isPlus) {
      return _InsightShell(
        locked: true,
        child: _LockedInsightPreview(currency: currency),
      );
    }

    return insight.when(
      loading: () => _InsightShell(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              SizedBox(
                width: 18.r,
                height: 18.r,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12.w),
              Text(
                AppL10n.of(context).monthlyInsightLoading,
                style: TextStyle(fontSize: 13.sp),
              ),
            ],
          ),
        ),
      ),
      error: (_, _) => _InsightShell(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            AppL10n.of(context).monthlyInsightError,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      data: (data) {
        if (data == null || !data.isPlus) {
          return _InsightShell(
            locked: true,
            child: _LockedInsightPreview(currency: currency),
          );
        }
        return _InsightShell(
          child: _MonthlyInsightCard(insight: data, currency: currency),
        );
      },
    );
  }
}

class _InsightShell extends StatelessWidget {
  const _InsightShell({required this.child, this.locked = false});

  final Widget child;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: locked ? scheme.surfaceContainerHigh : scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: child,
      ),
    );
  }
}

class _LockedInsightPreview extends StatelessWidget {
  const _LockedInsightPreview({required this.currency});

  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.insights_outlined, color: scheme.onSurfaceVariant),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.monthlyInsightTitle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _SmallPlusPill(color: scheme.onSurfaceVariant),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  l10n.monthlyInsightLockedSubtitle,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12.sp,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 12.h),
                _BlurredMetricRow(currency: currency),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          IconButton.filledTonal(
            tooltip: l10n.historyUpgradeCta,
            onPressed: () => context.goNamed(Routes.settingsName),
            icon: const Icon(Icons.workspace_premium_outlined),
          ),
        ],
      ),
    );
  }
}

class _MonthlyInsightCard extends StatelessWidget {
  const _MonthlyInsightCard({required this.insight, required this.currency});

  final MonthlySpendingInsight insight;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final scheme = Theme.of(context).colorScheme;
    final month = DateFormat.MMMM().format(insight.monthStart);
    final mom = insight.monthOverMonthPercent;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: scheme.primary, size: 22.r),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  l10n.monthlyInsightTitle,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _SmallPlusPill(color: scheme.primary),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            l10n.monthlyInsightMonth(month),
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12.sp),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: l10n.monthlyInsightTotal,
                  value: currency.format(insight.totalAmount),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _MetricTile(
                  label: l10n.monthlyInsightAverage,
                  value: currency.format(insight.averageBillAmount),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: l10n.monthlyInsightBills,
                  value: '${insight.billCount}',
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _MetricTile(
                  label: l10n.monthlyInsightOutstanding,
                  value: currency.format(insight.outstandingAmount),
                ),
              ),
            ],
          ),
          if (mom != null) ...[
            SizedBox(height: 12.h),
            _MonthComparison(percent: mom),
          ],
          if (insight.monthlyTrend.isNotEmpty) ...[
            SizedBox(height: 14.h),
            _TrendBars(points: insight.monthlyTrend, currency: currency),
          ],
          if (insight.topMerchants.isNotEmpty) ...[
            SizedBox(height: 14.h),
            Text(
              l10n.monthlyInsightTopMerchants,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6.h),
            ...insight.topMerchants.map(
              (m) => _MerchantRow(merchant: m, currency: currency),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 11.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _MonthComparison extends StatelessWidget {
  const _MonthComparison({required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isUp = percent > 0;
    final isFlat = percent.abs() < 0.01;
    final icon = isFlat
        ? Icons.trending_flat
        : isUp
        ? Icons.trending_up
        : Icons.trending_down;
    final label = isFlat
        ? l10n.monthlyInsightNoChange
        : isUp
        ? l10n.monthlyInsightIncrease(percent.abs().toStringAsFixed(1))
        : l10n.monthlyInsightDecrease(percent.abs().toStringAsFixed(1));

    return Row(
      children: [
        Icon(icon, color: scheme.primary, size: 18.r),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _TrendBars extends StatelessWidget {
  const _TrendBars({required this.points, required this.currency});

  final List<MonthlySpendingTrendPoint> points;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxAmount = points.fold<double>(
      0,
      (max, p) => p.totalAmount > max ? p.totalAmount : max,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: points
          .map((point) {
            final ratio = maxAmount <= 0 ? 0.04 : point.totalAmount / maxAmount;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    Tooltip(
                      message: currency.format(point.totalAmount),
                      child: Container(
                        height: (52.h * ratio.clamp(0.04, 1)).toDouble(),
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      DateFormat.MMM().format(point.monthStart),
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}

class _MerchantRow extends StatelessWidget {
  const _MerchantRow({required this.merchant, required this.currency});

  final MerchantSpendingInsight merchant;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              merchant.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.sp),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            currency.format(merchant.totalAmount),
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallPlusPill extends StatelessWidget {
  const _SmallPlusPill({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Plus',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          'Plus',
          style: TextStyle(
            color: color,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _BlurredMetricRow extends StatelessWidget {
  const _BlurredMetricRow({required this.currency});

  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            label: AppL10n.of(context).monthlyInsightTotal,
            value: currency.format(0),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _MetricTile(
            label: AppL10n.of(context).monthlyInsightBills,
            value: '--',
          ),
        ),
      ],
    );
  }
}

class _HistoryAccessBanner extends StatelessWidget {
  const _HistoryAccessBanner({
    required this.isPlus,
    required this.hasHistoryAccess,
    required this.days,
  });

  final bool isPlus;
  final bool hasHistoryAccess;
  final int days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final scheme = Theme.of(context).colorScheme;
    final bg = isPlus ? scheme.primaryContainer : scheme.surfaceContainerHigh;
    final fg = isPlus ? scheme.onPrimaryContainer : scheme.onSurfaceVariant;
    final title = isPlus
        ? l10n.historyWindowPlus
        : hasHistoryAccess
        ? l10n.historyWindowFree
        : l10n.historyWindowAnonymous;
    final subtitle = isPlus
        ? l10n.historyWindowSubtitle(days)
        : hasHistoryAccess
        ? l10n.historyWindowFreeSubtitle(
            PlusFeatureLimits.freeHistoryDays,
            PlusFeatureLimits.plusHistoryDays,
          )
        : l10n.historyWindowAnonymousSubtitle;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: fg.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Icon(
              isPlus
                  ? Icons.workspace_premium
                  : hasHistoryAccess
                  ? Icons.history_toggle_off_outlined
                  : Icons.lock_outline,
              color: fg,
              size: 22.r,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 4.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: fg,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (isPlus)
                        Semantics(
                          label: 'Plus',
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: fg.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              'Plus',
                              style: TextStyle(
                                color: fg,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(color: fg, fontSize: 12.sp, height: 1.3),
                  ),
                ],
              ),
            ),
            if (!isPlus) ...[
              SizedBox(width: 8.w),
              IconButton.filledTonal(
                tooltip: l10n.historyUpgradeCta,
                onPressed: () => context.goNamed(Routes.settingsName),
                icon: const Icon(Icons.workspace_premium_outlined),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.bills});

  final List<Bill> bills;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final scheme = Theme.of(context).colorScheme;
    final totalBills = bills.length;
    final outstanding = <String, double>{};
    for (final bill in bills.where((b) => !b.isSettled)) {
      outstanding.update(
        bill.currencyCode,
        (value) => value + bill.totalAmount,
        ifAbsent: () => bill.totalAmount,
      );
    }
    final outstandingText = _formatOutstanding(outstanding);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: l10n.historyTotalBills,
              value: '$totalBills',
              icon: Icons.receipt_long_outlined,
              color: scheme.primaryContainer,
              onColor: scheme.onPrimaryContainer,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _StatCard(
              label: l10n.historyOutstanding,
              value: outstandingText,
              icon: Icons.account_balance_wallet_outlined,
              color: scheme.tertiaryContainer,
              onColor: scheme.onTertiaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatOutstanding(Map<String, double> totalsByCurrency) {
    if (totalsByCurrency.isEmpty) {
      return CurrencyFormatter.of('IDR').format(0);
    }
    final entries = totalsByCurrency.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return entries
        .map((entry) => CurrencyFormatter.of(entry.key).format(entry.value))
        .join('\n');
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.onColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: onColor, size: 22.r),
          SizedBox(height: 10.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: onColor.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: onColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 56.r,
              color: scheme.onSurfaceVariant,
            ),
            SizedBox(height: 12.h),
            Text(
              l10n.historyEmptyMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 48.r,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            FilledButton.tonal(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}
