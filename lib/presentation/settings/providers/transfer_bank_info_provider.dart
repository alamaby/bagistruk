import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/result.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/transfer_bank_info.dart';

final transferBankInfoProvider = FutureProvider<TransferBankInfo?>((ref) async {
  final result = await ref
      .watch(profileRepositoryProvider)
      .getTransferBankInfo();
  return switch (result) {
    Success(:final data) => data,
    ResultFailure(:final failure) => throw Exception(failure.toString()),
  };
});
