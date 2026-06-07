import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/result.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/monthly_spending_insight.dart';
import '../../auth/providers/auth_providers.dart';
import '../../credits/providers/ocr_credit_status_provider.dart';
import '../../settings/providers/profile_notifier.dart';

final monthlySpendingInsightProvider = FutureProvider<MonthlySpendingInsight?>((
  ref,
) async {
  ref.watch(authStateProvider);
  final creditStatus = await ref.watch(ocrCreditStatusProvider.future);
  if (creditStatus?.isPlus != true) return null;
  final profile = await ref.watch(profileProvider.future);

  final result = await ref
      .read(profileRepositoryProvider)
      .getMonthlySpendingInsight(currencyCode: profile.defaultCurrency);
  return switch (result) {
    Success(:final data) => data,
    ResultFailure(:final failure) => throw Exception(failure.toString()),
  };
});
