import 'dart:ui';

import 'package:bagistruk/core/format/device_locale_defaults.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeviceLocaleDefaults.resolveLanguage', () {
    test('null returns en', () {
      expect(DeviceLocaleDefaults.resolveLanguage(null), 'en');
    });

    test('empty list returns en', () {
      expect(DeviceLocaleDefaults.resolveLanguage([]), 'en');
    });

    test('unsupported language returns en', () {
      expect(DeviceLocaleDefaults.resolveLanguage([const Locale('fr')]), 'en');
    });

    test('id locale returns id', () {
      expect(DeviceLocaleDefaults.resolveLanguage([const Locale('id')]), 'id');
    });

    test('en locale returns en', () {
      expect(DeviceLocaleDefaults.resolveLanguage([const Locale('en')]), 'en');
    });

    test('id takes priority when listed after other locales', () {
      expect(
        DeviceLocaleDefaults.resolveLanguage([
          const Locale('fr'),
          const Locale('id'),
          const Locale('en'),
        ]),
        'id',
      );
    });
  });

  group('DeviceLocaleDefaults.resolveCurrency', () {
    test('null returns USD', () {
      expect(DeviceLocaleDefaults.resolveCurrency(null), 'USD');
    });

    test('en_US returns USD', () {
      expect(
        DeviceLocaleDefaults.resolveCurrency([const Locale('en', 'US')]),
        'USD',
      );
    });

    test('id_ID returns IDR', () {
      expect(
        DeviceLocaleDefaults.resolveCurrency([const Locale('id', 'ID')]),
        'IDR',
      );
    });

    test('unknown country returns USD', () {
      expect(
        DeviceLocaleDefaults.resolveCurrency([const Locale('en', 'XX')]),
        'USD',
      );
    });

    test('en_FR returns EUR (Eurozone)', () {
      expect(
        DeviceLocaleDefaults.resolveCurrency([const Locale('en', 'FR')]),
        'EUR',
      );
    });

    test('en_DE returns EUR (Eurozone)', () {
      expect(
        DeviceLocaleDefaults.resolveCurrency([const Locale('en', 'DE')]),
        'EUR',
      );
    });

    test('locale without country code returns USD', () {
      expect(
        DeviceLocaleDefaults.resolveCurrency([const Locale('en')]),
        'USD',
      );
    });
  });
}
