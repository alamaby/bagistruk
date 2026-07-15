import 'package:flutter_test/flutter_test.dart';

import '../../../lib/core/billing/plus_feature_limits.dart';

void main() {
  group('historyDays', () {
    test('anonymous returns 0', () {
      expect(PlusFeatureLimits.historyDays(planCode: null), 0);
      expect(PlusFeatureLimits.historyDays(planCode: 'anonymous'), 0);
    });

    test('free returns 30', () {
      expect(PlusFeatureLimits.historyDays(planCode: 'free'), 30);
    });

    test('plus returns 365', () {
      expect(PlusFeatureLimits.historyDays(planCode: 'plus'), 365);
    });
  });

  group('historyCutoff', () {
    test('returns null for anonymous', () {
      expect(PlusFeatureLimits.historyCutoff(planCode: null), isNull);
    });

    test('returns correct date for free', () {
      final now = DateTime.utc(2026, 7, 15, 12, 0, 0);
      final cutoff = PlusFeatureLimits.historyCutoff(
        planCode: 'free',
        now: now,
      );
      expect(
        cutoff,
        DateTime.utc(2026, 6, 15, 12, 0, 0),
      );
    });

    test('returns correct date for plus', () {
      final now = DateTime.utc(2026, 7, 15, 12, 0, 0);
      final cutoff = PlusFeatureLimits.historyCutoff(
        planCode: 'plus',
        now: now,
      );
      expect(
        cutoff,
        DateTime.utc(2025, 7, 15, 12, 0, 0),
      );
    });
  });
}
