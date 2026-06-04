import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../../../core/billing/plus_feature_limits.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/bill.dart';
import '../../credits/providers/ocr_credit_status_provider.dart';

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
}

/// Internal — repository [Failure] wrapped so [AsyncValue] error channel keeps
/// the typed failure intact instead of stringifying it.
class _FailureException implements Exception {
  _FailureException(this.failure);
  final Failure failure;
  @override
  String toString() => failure.toString();
}
