import 'package:flutter_test/flutter_test.dart';

import '../../../lib/domain/entities/ocr_credit_status.dart';

void main() {
  group('entitlementExpiresAt', () {
    test('returns subscriptionExpiresAt for google_play_subscription', () {
      final expiry = DateTime.utc(2026, 7, 12);
      final status = OcrCreditStatus(
        planCode: 'plus',
        balance: 60,
        monthlyAllowance: 60,
        adsEnabled: false,
        plusFeaturesEnabled: true,
        entitlementSource: 'google_play_subscription',
        subscriptionExpiresAt: expiry,
      );
      expect(status.entitlementExpiresAt, expiry);
    });

    test('returns trialEndsAt for trial_plus', () {
      final expiry = DateTime.utc(2026, 8, 11);
      final status = OcrCreditStatus(
        planCode: 'plus',
        balance: 60,
        monthlyAllowance: 60,
        adsEnabled: false,
        plusFeaturesEnabled: true,
        entitlementSource: 'trial_plus',
        trialEndsAt: expiry,
      );
      expect(status.entitlementExpiresAt, expiry);
    });

    test('returns null for free plan', () {
      final status = OcrCreditStatus(
        planCode: 'free',
        balance: 20,
        monthlyAllowance: 20,
        adsEnabled: true,
        plusFeaturesEnabled: false,
        entitlementSource: 'system_free',
      );
      expect(status.entitlementExpiresAt, isNull);
    });

    test('returns null for anonymous plan', () {
      final status = OcrCreditStatus(
        planCode: 'anonymous',
        balance: 5,
        monthlyAllowance: 5,
        adsEnabled: true,
        plusFeaturesEnabled: false,
        entitlementSource: 'anonymous',
      );
      expect(status.entitlementExpiresAt, isNull);
    });

    test('returns null for unknown entitlement source on plus plan', () {
      final status = OcrCreditStatus(
        planCode: 'plus',
        balance: 60,
        monthlyAllowance: 60,
        adsEnabled: false,
        plusFeaturesEnabled: true,
        entitlementSource: 'unknown_source',
        subscriptionExpiresAt: DateTime.utc(2026, 7, 12),
      );
      expect(status.entitlementExpiresAt, isNull);
    });
  });

  group('fromJson', () {
    test('parses google_play_subscription with subscription_expires_at', () {
      final json = {
        'plan_code': 'plus',
        'balance': 60,
        'monthly_allowance': 60,
        'current_period_end': '2026-07-12T00:00:00Z',
        'subscription_expires_at': '2026-08-01T00:00:00Z',
        'ads_enabled': false,
        'plus_features_enabled': true,
        'entitlement_source': 'google_play_subscription',
        'trial_ends_at': null,
        'anonymous_device_used': 0,
        'anonymous_device_limit': 0,
      };
      final status = OcrCreditStatus.fromJson(json);
      expect(status.entitlementSource, 'google_play_subscription');
      expect(status.subscriptionExpiresAt, DateTime.utc(2026, 8, 1));
      expect(status.trialEndsAt, isNull);
      expect(status.entitlementExpiresAt, DateTime.utc(2026, 8, 1));
    });

    test('parses trial_plus with trial_ends_at', () {
      final json = {
        'plan_code': 'plus',
        'balance': 60,
        'monthly_allowance': 60,
        'current_period_end': '2026-07-12T00:00:00Z',
        'subscription_expires_at': null,
        'ads_enabled': false,
        'plus_features_enabled': true,
        'entitlement_source': 'trial_plus',
        'trial_ends_at': '2026-08-11T00:00:00Z',
        'anonymous_device_used': 0,
        'anonymous_device_limit': 0,
      };
      final status = OcrCreditStatus.fromJson(json);
      expect(status.entitlementSource, 'trial_plus');
      expect(status.trialEndsAt, DateTime.utc(2026, 8, 11));
      expect(status.subscriptionExpiresAt, isNull);
      expect(status.entitlementExpiresAt, DateTime.utc(2026, 8, 11));
    });

    test('parses free plan with null expiry fields', () {
      final json = {
        'plan_code': 'free',
        'balance': 20,
        'monthly_allowance': 20,
        'current_period_end': null,
        'subscription_expires_at': null,
        'ads_enabled': true,
        'plus_features_enabled': false,
        'entitlement_source': 'system_free',
        'trial_ends_at': null,
        'anonymous_device_used': 0,
        'anonymous_device_limit': 0,
      };
      final status = OcrCreditStatus.fromJson(json);
      expect(status.entitlementSource, 'system_free');
      expect(status.subscriptionExpiresAt, isNull);
      expect(status.trialEndsAt, isNull);
      expect(status.entitlementExpiresAt, isNull);
    });
  });
}
