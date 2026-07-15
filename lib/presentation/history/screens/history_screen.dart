import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/billing/plus_feature_limits.dart';
import '../../../core/error/result.dart';
import '../../../core/format/currency_formatter.dart';
import '../../../core/router/routes.dart';
import '../../../domain/entities/bill.dart';
import '../../../domain/entities/bill_payment_status.dart';
import '../../../domain/entities/monthly_spending_insight.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../../../core/ads/ad_config.dart';
import '../../ads/widgets/banner_ad_widget.dart';
import '../../bills/providers/bill_list_notifier.dart';
import '../../credits/providers/ocr_credit_status_provider.dart';
import '../../insights/providers/monthly_spending_insight_provider.dart';
import '../../settings/providers/preferences_providers.dart';
import '../../shared/widgets/loading_view.dart';
import '../../shared/widgets/plus_info_icon.dart';
import '../providers/history_filter_notifier.dart';
import '../utils/history_bill_filter.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final billsAsync = ref.watch(billListProvider);
    final filter = ref.watch(historyFilterProvider);
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
        child: billsAsync.when(
          loading: () => LoadingView(message: l10n.historyLoadingMessage),
          error: (e, _) => _ErrorView(
            message: e.toString(),
            onRetry: () => ref.read(billListProvider.notifier).refresh(),
          ),
          data: (list) {
            final currencies = list.map((b) => b.currencyCode).toSet().toList()
              ..sort();
            final sorted = applyHistoryFilter(list, filter);
            final canSortNominal = nominalSortAvailable(list, filter);

            return RefreshIndicator(
              onRefresh: () async {
                await ref.read(billListProvider.notifier).refresh();
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text(l10n.historyTab),
                    pinned: true,
                    actions: [
                      IconButton(
                        tooltip: l10n.historyFilterTooltip,
                        icon: Badge(
                          isLabelVisible: filter.hasActiveFilters,
                          label: const Text('!'),
                          child: const Icon(Icons.tune),
                        ),
                        onPressed: () => _openFilterSheet(
                          context,
                          ref,
                          currencies,
                          filter,
                          canSortNominal,
                        ),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(child: _SummaryCards(bills: list)),
                  if (filter.hasActiveFilters)
                    SliverToBoxAdapter(
                      child: _ActiveFilterChips(
                        filter: filter,
                        currencies: currencies,
                        onRemoveStatus: () =>
                            ref.read(historyFilterProvider.notifier)
                                .setPaymentStatus(null),
                        onRemoveCurrency: () =>
                            ref.read(historyFilterProvider.notifier)
                                .setCurrencyCode(null),
                        onReset: () =>
                            ref.read(historyFilterProvider.notifier)
                                .reset(),
                      ),
                    ),
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
                  if (filter.hasActiveFilters && list.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _FilteredCountLabel(
                        filteredCount: sorted.length,
                        totalCount: list.length,
                      ),
                    ),
                  if (list.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(),
                    )
                  else if (sorted.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _FilteredEmptyState(
                        onReset: () =>
                            ref.read(historyFilterProvider.notifier)
                                .reset(),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      sliver: SliverList.separated(
                        itemCount: sorted.length,
                        separatorBuilder: (_, _) => SizedBox(height: 8.h),
                        itemBuilder: (context, i) {
                          final bill = sorted[i];
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
                                  _PaymentStatusIcon(
                                    status: bill.paymentStatus,
                                  ),
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
                  const SliverToBoxAdapter(
                    child: BannerAdWidget(
                      placement: BannerAdPlacement.history,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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

  void _openFilterSheet(
    BuildContext context,
    WidgetRef ref,
    List<String> currencies,
    HistoryFilterState currentFilter,
    bool canSortNominal,
  ) {
    final draft = HistoryFilterState(
      sort: currentFilter.sort,
      paymentStatus: currentFilter.paymentStatus,
      currencyCode: currentFilter.currencyCode,
    );

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => _FilterSheet(
        initialFilter: draft,
        currencies: currencies,
        canSortNominal: canSortNominal,
        onApply: (applied) {
          final notifier = ref.read(historyFilterProvider.notifier);
          notifier.setSort(applied.sort);
          notifier.setPaymentStatus(applied.paymentStatus);
          notifier.setCurrencyCode(applied.currencyCode);
        },
      ),
    );
  }
}

class _PaymentStatusIcon extends StatelessWidget {
  const _PaymentStatusIcon({required this.status});

  final BillPaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (status) {
      BillPaymentStatus.settled => const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
      BillPaymentStatus.partial => Icon(
          Icons.checklist,
          color: scheme.tertiary,
        ),
      BillPaymentStatus.unpaid => const Icon(Icons.schedule),
      BillPaymentStatus.unassigned => Icon(
          Icons.people_outline,
          color: scheme.onSurfaceVariant,
        ),
    };
  }
}

class _ActiveFilterChips extends StatelessWidget {
  const _ActiveFilterChips({
    required this.filter,
    required this.currencies,
    required this.onRemoveStatus,
    required this.onRemoveCurrency,
    required this.onReset,
  });

  final HistoryFilterState filter;
  final List<String> currencies;
  final VoidCallback onRemoveStatus;
  final VoidCallback onRemoveCurrency;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final scheme = Theme.of(context).colorScheme;
    final chips = <Widget>[];

    if (filter.paymentStatus != null) {
      chips.add(
        _FilterChip(
          label: _statusLabel(l10n, filter.paymentStatus!),
          onRemoved: onRemoveStatus,
        ),
      );
    }

    if (filter.currencyCode != null) {
      chips.add(
        _FilterChip(
          label: filter.currencyCode!,
          onRemoved: onRemoveCurrency,
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
      child: Row(
        children: [
          Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            children: chips,
          ),
          SizedBox(width: 8.w),
          TextButton.icon(
            icon: Icon(Icons.close, size: 16.r),
            label: Text(
              l10n.historyFilterReset,
              style: TextStyle(fontSize: 12.sp),
            ),
            onPressed: onReset,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: scheme.error,
            ),
          ),
        ],
      ),
    );
  }

  static String _statusLabel(AppL10n l10n, BillPaymentStatus status) =>
      switch (status) {
        BillPaymentStatus.unassigned => l10n.historyStatusUnassigned,
        BillPaymentStatus.unpaid => l10n.historyStatusUnpaid,
        BillPaymentStatus.partial => l10n.historyStatusPartial,
        BillPaymentStatus.settled => l10n.historyStatusSettled,
      };
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.onRemoved});

  final String label;
  final VoidCallback onRemoved;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: scheme.onSecondaryContainer,
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: onRemoved,
            child: Icon(Icons.close, size: 14.r, color: scheme.onSecondaryContainer),
          ),
        ],
      ),
    );
  }
}

class _FilteredCountLabel extends StatelessWidget {
  const _FilteredCountLabel({
    required this.filteredCount,
    required this.totalCount,
  });

  final int filteredCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
      child: Text(
        l10n.historyFilterCount(filteredCount, totalCount),
        style: TextStyle(
          fontSize: 12.sp,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
    required this.initialFilter,
    required this.currencies,
    required this.canSortNominal,
    required this.onApply,
  });

  final HistoryFilterState initialFilter;
  final List<String> currencies;
  final bool canSortNominal;
  final ValueChanged<HistoryFilterState> onApply;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late HistoryFilterState _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 12.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 32.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            l10n.historyFilterTitle,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 16.h),
          _SectionLabel(l10n.historyFilterSort),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _SortChip(
                label: l10n.historySortNewest,
                selected: _draft.sort == HistorySort.newest,
                onSelected: () => setState(() => _draft = _draft.copyWith(sort: HistorySort.newest)),
              ),
              _SortChip(
                label: l10n.historySortOldest,
                selected: _draft.sort == HistorySort.oldest,
                onSelected: () => setState(() => _draft = _draft.copyWith(sort: HistorySort.oldest)),
              ),
              _SortChip(
                label: l10n.historySortTitle,
                selected: _draft.sort == HistorySort.titleAsc,
                onSelected: () => setState(() => _draft = _draft.copyWith(sort: HistorySort.titleAsc)),
              ),
              _SortChip(
                label: l10n.historySortAmountDesc,
                selected: _draft.sort == HistorySort.amountDesc,
                enabled: widget.canSortNominal,
                onSelected: () => setState(() => _draft = _draft.copyWith(sort: HistorySort.amountDesc)),
              ),
              _SortChip(
                label: l10n.historySortAmountAsc,
                selected: _draft.sort == HistorySort.amountAsc,
                enabled: widget.canSortNominal,
                onSelected: () => setState(() => _draft = _draft.copyWith(sort: HistorySort.amountAsc)),
              ),
            ],
          ),
          if (!widget.canSortNominal) ...[
            SizedBox(height: 4.h),
            Text(
              l10n.historySortNominalDisabled,
              style: TextStyle(
                fontSize: 11.sp,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: 16.h),
          _SectionLabel(l10n.historyFilterStatus),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _StatusChoiceChip(
                label: l10n.historyStatusAll,
                selected: _draft.paymentStatus == null,
                onSelected: () => setState(() => _draft = _draft.copyWith(paymentStatus: null)),
              ),
              _StatusChoiceChip(
                label: l10n.historyStatusUnassigned,
                selected: _draft.paymentStatus == BillPaymentStatus.unassigned,
                onSelected: () => setState(() => _draft = _draft.copyWith(paymentStatus: BillPaymentStatus.unassigned)),
              ),
              _StatusChoiceChip(
                label: l10n.historyStatusUnpaid,
                selected: _draft.paymentStatus == BillPaymentStatus.unpaid,
                onSelected: () => setState(() => _draft = _draft.copyWith(paymentStatus: BillPaymentStatus.unpaid)),
              ),
              _StatusChoiceChip(
                label: l10n.historyStatusPartial,
                selected: _draft.paymentStatus == BillPaymentStatus.partial,
                onSelected: () => setState(() => _draft = _draft.copyWith(paymentStatus: BillPaymentStatus.partial)),
              ),
              _StatusChoiceChip(
                label: l10n.historyStatusSettled,
                selected: _draft.paymentStatus == BillPaymentStatus.settled,
                onSelected: () => setState(() => _draft = _draft.copyWith(paymentStatus: BillPaymentStatus.settled)),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _SectionLabel(l10n.historyFilterCurrency),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _StatusChoiceChip(
                label: l10n.historyStatusAll,
                selected: _draft.currencyCode == null,
                onSelected: () => setState(() => _draft = _draft.copyWith(currencyCode: null)),
              ),
              ...widget.currencies.map(
                (c) => _StatusChoiceChip(
                  label: c,
                  selected: _draft.currencyCode == c,
                  onSelected: () => setState(() => _draft = _draft.copyWith(currencyCode: c)),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _draft = const HistoryFilterState()),
                  child: Text(l10n.historyFilterReset),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    widget.onApply(_draft);
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.applyAction),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      label,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: scheme.onSurfaceVariant,
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.selected,
    this.enabled = true,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: enabled ? (_) => onSelected() : null,
      showCheckmark: false,
      selectedColor: scheme.primaryContainer,
      disabledColor: scheme.surfaceContainerHighest,
      labelStyle: TextStyle(
        color: selected
            ? scheme.onPrimaryContainer
            : enabled
                ? null
                : scheme.onSurfaceVariant.withValues(alpha: 0.4),
      ),
    );
  }
}

class _StatusChoiceChip extends StatelessWidget {
  const _StatusChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      selectedColor: scheme.secondaryContainer,
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
                    PlusInfoIcon(
                      title: l10n.monthlyInsightTitle,
                      message: l10n.monthlyInsightLockedSubtitle,
                      iconColor: scheme.onSurfaceVariant,
                    ),
                    _SmallPlusPill(color: scheme.onSurfaceVariant),
                  ],
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
    final details = isPlus
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
                      PlusInfoIcon(
                        title: title,
                        message: details,
                        iconColor: fg,
                      ),
                    ],
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
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: onColor, size: 20.r),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: onColor.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
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

class _FilteredEmptyState extends StatelessWidget {
  const _FilteredEmptyState({required this.onReset});

  final VoidCallback onReset;

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
              Icons.filter_alt_off_outlined,
              size: 56.r,
              color: scheme.onSurfaceVariant,
            ),
            SizedBox(height: 12.h),
            Text(
              l10n.historyFilterEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: scheme.onSurfaceVariant),
            ),
            SizedBox(height: 16.h),
            FilledButton.tonal(
              onPressed: onReset,
              child: Text(l10n.historyFilterReset),
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
