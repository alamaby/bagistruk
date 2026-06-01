import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/result.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/ocr_credit_status.dart';
import '../../auth/providers/auth_providers.dart';

final ocrCreditStatusProvider = FutureProvider<OcrCreditStatus?>((ref) async {
  ref.watch(authStateProvider);
  final auth = ref.watch(authRepositoryProvider);
  if (auth.currentUserId == null) return null;

  final result = await ref.read(profileRepositoryProvider).getOcrCreditStatus();
  return switch (result) {
    Success(:final data) => data,
    ResultFailure(:final failure) => throw Exception(failure.toString()),
  };
});
