import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/result.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/transfer_bank_info.dart';
import '../../auth/providers/auth_providers.dart';

final transferBankInfoProvider = FutureProvider<TransferBankInfo?>((ref) async {
  final authSnap = await ref.watch(authStateProvider.future);
  if (authSnap.userId == null || authSnap.isAnonymous) return null;

  final result = await ref
      .watch(profileRepositoryProvider)
      .getTransferBankInfo();
  return switch (result) {
    Success(:final data) => data,
    ResultFailure(:final failure) => throw Exception(failure.toString()),
  };
});
