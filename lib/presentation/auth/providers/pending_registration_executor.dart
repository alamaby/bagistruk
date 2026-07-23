import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/providers.dart';
import '../../settings/providers/profile_notifier.dart';

part 'pending_registration_executor.g.dart';

@Riverpod(keepAlive: true)
class PendingRegistrationExecutor extends _$PendingRegistrationExecutor {
  bool _running = false;

  @override
  Future<void> build() => Future.value();

  /// Applies any pending registration action that was deferred from the
  /// register screen after email confirmation.
  ///
  /// - `true` means a pending action was found and either applied or
  ///   attempted. The caller can route to the next screen; if a write
  ///   failed the action remains stored so a subsequent callback can
  ///   retry it.
  /// - `false` means there was nothing to do, or the pending action was
  ///   discarded because it was for a different account.
  ///
  /// Identity is matched against the active Supabase session email, not
  /// `profileProvider`, because profile state can be stale right after a
  /// Supabase callback swaps the session. When the current email is
  /// temporarily unavailable the pending action is preserved so a
  /// subsequent call (or the TTL expiry) can clean it up.
  Future<bool> execute() async {
    if (_running) return false;
    _running = true;
    try {
      return await _run();
    } finally {
      _running = false;
    }
  }

  Future<bool> _run() async {
    final prefs = await ref.read(pendingRegistrationPreferencesProvider.future);
    final pending = await prefs.load();
    if (pending == null) return false;

    final currentEmail = ref.read(authRepositoryProvider).currentEmail;
    if (currentEmail == null || currentEmail.isEmpty) {
      AppLogger.warn(
        'PendingRegistrationExecutor: current email unavailable; '
        'keeping pending action for retry',
      );
      return true;
    }

    final normalizedPending = pending.email.trim().toLowerCase();
    final normalizedCurrent = currentEmail.trim().toLowerCase();
    if (normalizedPending != normalizedCurrent) {
      AppLogger.warn(
        'PendingRegistrationExecutor: email mismatch '
        '(pending=$normalizedPending, current=$normalizedCurrent), clearing',
      );
      await prefs.clear();
      return false;
    }

    // Ensure profileProvider has rebuilt against the new session before
    // mutating — `updateMarketingOptIn` and `markWelcomed` patch the
    // notifier state synchronously after the DB write.
    await ref.read(profileProvider.future);
    final profileNotifier = ref.read(profileProvider.notifier);

    if (pending.marketingOptIn) {
      final optRes = await profileNotifier.updateMarketingOptIn(
        optedIn: true,
        source: 'register_form',
        preferredLanguage: pending.preferredLanguage,
      );
      if (optRes is ResultFailure<void>) {
        AppLogger.error(
          'PendingRegistrationExecutor: updateMarketingOptIn failed',
          optRes.failure,
        );
        return true;
      }
    }

    final welcomedRes = await profileNotifier.markWelcomed();
    if (welcomedRes is ResultFailure<void>) {
      AppLogger.error(
        'PendingRegistrationExecutor: markWelcomed failed',
        welcomedRes.failure,
      );
      return true;
    }

    await prefs.clear();
    return true;
  }
}
