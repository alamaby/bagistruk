import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../../../core/billing/plus_feature_limits.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/bill.dart';
import '../../../domain/entities/deleted_bill.dart';
import '../../credits/providers/ocr_credit_status_provider.dart';
import '../../insights/providers/monthly_spending_insight_provider.dart';

part 'bill_list_notifier.g.dart';

/// Async-loaded list of bills for the current user. Uses [AsyncValue] so the
/// UI gets standard loading / data / error rendering for free.
@riverpod
class BillListNotifier extends _$BillListNotifier {
  @override
  Future<List<Bill>> build() async {
    final repo = ref.watch(billRepositoryProvider);
    final creditStatus = await ref.watch(ocrCreditStatusProvider.future);
    final historyDays = PlusFeatureLimits.historyDays(
      planCode: creditStatus?.planCode,
    );
    if (historyDays <= 0) return const [];

    final createdAfter = PlusFeatureLimits.historyCutoff(
      planCode: creditStatus?.planCode,
    );
    final result = await repo.listBills(createdAfter: createdAfter);
    return switch (result) {
      Success(:final data) => data,
      ResultFailure(:final failure) => throw _FailureException(failure),
    };
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  Future<Result<void>> deleteBill(String id) async {
    final repo = ref.read(billRepositoryProvider);
    final result = await repo.deleteBill(id);
    if (result is Success<void>) {
      ref.invalidate(monthlySpendingInsightProvider);
      await refresh();
    }
    return result;
  }
}

final deletedBillListProvider =
    AutoDisposeAsyncNotifierProvider<
      DeletedBillListNotifier,
      List<DeletedBill>
    >(DeletedBillListNotifier.new);

class DeletedBillListNotifier
    extends AutoDisposeAsyncNotifier<List<DeletedBill>> {
  @override
  Future<List<DeletedBill>> build() async {
    final repo = ref.watch(billRepositoryProvider);
    final creditStatus = await ref.watch(ocrCreditStatusProvider.future);
    if (!(creditStatus?.isPlus ?? false)) return const [];

    final result = await repo.listDeletedBills();
    return switch (result) {
      Success(:final data) => data,
      ResultFailure(:final failure) => throw _FailureException(failure),
    };
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  Future<Result<void>> restoreBill(String id) async {
    final repo = ref.read(billRepositoryProvider);
    final result = await repo.restoreDeletedBill(id);
    if (result is Success<void>) {
      ref.invalidate(billListProvider);
      ref.invalidate(monthlySpendingInsightProvider);
      await refresh();
    }
    return result;
  }
}

/// Internal — repository [Failure] wrapped so [AsyncValue] error channel keeps
/// the typed failure intact instead of stringifying it.
class _FailureException implements Exception {
  _FailureException(this.failure);
  final Failure failure;
  @override
  String toString() => failure.toString();
}
