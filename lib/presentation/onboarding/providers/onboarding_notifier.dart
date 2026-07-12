import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/error/result.dart';
import '../../../data/providers.dart';
import '../../settings/providers/profile_notifier.dart';
import '../onboarding.dart';

part 'onboarding_notifier.g.dart';

@Riverpod(keepAlive: true)
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  bool build() {
    final profile = ref.watch(profileProvider).value;
    return profile?.onboardingCompletedAt != null;
  }

  /// Persists completion timestamp for first-run. Does nothing on replay.
  Future<Result<void>> completeOnboarding() async {
    final repo = ref.read(profileRepositoryProvider);
    final res = await repo.markOnboardingCompleted(
      version: Onboarding.version,
    );
    if (res is Success<void>) {
      ref.invalidate(profileProvider);
    }
    return res;
  }
}
