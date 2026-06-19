import 'dart:ui';

import 'currency_formatter.dart';

/// Resolves app-wide default language and currency from the device locale.
///
/// Only called during fresh-install bootstrap — user preferences stored in the
/// DB always take precedence once they exist.
class DeviceLocaleDefaults {
  const DeviceLocaleDefaults._();

  /// Map of ISO 3166-1 alpha-2 country codes to the currency code used in
  /// this app. Covers all entries in [CurrencyFormatter.definitions].
  static const Map<String, String> _countryToCurrency = <String, String>{
    'ID': 'IDR',
    'BN': 'BND',
    'KH': 'KHR',
    'LA': 'LAK',
    'MY': 'MYR',
    'MM': 'MMK',
    'PH': 'PHP',
    'SG': 'SGD',
    'TH': 'THB',
    'VN': 'VND',
    'IN': 'INR',
    'JP': 'JPY',
    'CN': 'CNY',
    'US': 'USD',
    'GB': 'GBP',
    'RU': 'RUB',
    'BR': 'BRL',
    'MX': 'MXN',
    'AU': 'AUD',
    'SA': 'SAR',
    // Eurozone countries — keep the most common source locales.
    'ES': 'EUR',
    'FR': 'EUR',
    'DE': 'EUR',
    'IT': 'EUR',
    'PT': 'EUR',
    'NL': 'EUR',
    'BE': 'EUR',
    'AT': 'EUR',
    'IE': 'EUR',
    'FI': 'EUR',
    'GR': 'EUR',
    'PL': 'EUR',
  };

  /// Resolves the language code for the app from the device locales.
  ///
  /// Returns `'id'` for Indonesian, `'en'` for English, and defaults to `'en'`
  /// for every other language.
  static String resolveLanguage(List<Locale>? deviceLocales) {
    if (deviceLocales == null) return 'en';
    for (final locale in deviceLocales) {
      final code = locale.languageCode;
      if (code == 'id') return 'id';
      if (code == 'en') return 'en';
    }
    return 'en';
  }

  /// Resolves the currency code from the device locale's country code.
  ///
  /// Falls back to `'USD'` when the country is unknown or the resulting
  /// currency is not in [CurrencyFormatter.supportedSet].
  static String resolveCurrency(List<Locale>? deviceLocales) {
    if (deviceLocales == null) return 'USD';
    for (final locale in deviceLocales) {
      final country = locale.countryCode;
      if (country != null && country.isNotEmpty) {
        final code = _countryToCurrency[country.toUpperCase()];
        if (code != null && CurrencyFormatter.supportedSet.contains(code)) {
          return code;
        }
      }
    }
    return 'USD';
  }

  /// Convenience: resolve both defaults from the platform dispatcher.
  static ({String language, String currency}) fromPlatform() {
    final locales = PlatformDispatcher.instance.locales;
    return (
      language: resolveLanguage(locales),
      currency: resolveCurrency(locales),
    );
  }
}
