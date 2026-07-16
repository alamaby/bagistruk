import 'package:bagistruk/presentation/history/providers/history_plus_banner_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('HistoryPlusBannerNotifier', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is false (not dismissed)', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final state = await container.read(historyPlusBannerProvider.future);
      expect(state, false);
    });

    test('dismiss sets state to true', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(historyPlusBannerProvider.future);
      await container.read(historyPlusBannerProvider.notifier).dismiss();
      final state = await container.read(historyPlusBannerProvider.future);
      expect(state, true);
    });

    test('dismiss persists across provider rebuilds', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(historyPlusBannerProvider.future);
      await container.read(historyPlusBannerProvider.notifier).dismiss();

      container.invalidate(historyPlusBannerProvider);
      final state = await container.read(historyPlusBannerProvider.future);
      expect(state, true);
    });

    test('reads persisted true from SharedPreferences on first build', () async {
      SharedPreferences.setMockInitialValues({
        'history_plus_banner_dismissed_v1': true,
      });
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final state = await container.read(historyPlusBannerProvider.future);
      expect(state, true);
    });

    test('dismiss safe before build completes (race regression)', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(historyPlusBannerProvider.notifier).dismiss();
      final state = await container.read(historyPlusBannerProvider.future);
      expect(state, true);
    });
  });
}
