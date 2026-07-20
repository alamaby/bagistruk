/// Currency minor-unit helpers. Pure Dart (no Flutter, no Supabase, no
/// Riverpod) so it stays trivially unit-testable, usable from the domain
/// layer, and reusable on a server (e.g. inside an Edge Function audit).
///
/// This is the single source of truth for which ISO 4217 currencies have no
/// minor unit (no "cents"). [AppConstants.zeroDecimalCurrencies] re-exports
/// this set so the client keeps one canonical list; keep it in sync with the
/// server-side `ZERO_DECIMAL_CURRENCIES` set in the Edge Function.
class Money {
  const Money._();

  /// ISO 4217 currencies whose smallest unit is a whole number (no sub-unit
  /// such as cents). Amounts in these currencies must never carry a fractional
  /// part — e.g. a 3-way split of Rp 100.000 is 33.333 / 33.333 / 33.334, not
  /// 33.333,33.
  static const Set<String> zeroDecimalCurrencies = {
    'IDR',
    'KHR',
    'LAK',
    'MMK',
    'VND',
    'JPY',
    'KRW',
    'CLP',
    'ISK',
    'HUF',
    'TWD',
  };

  /// Number of decimal digits in [currencyCode]'s minor unit: 0 for
  /// zero-decimal currencies (IDR, JPY, …), 2 otherwise (USD, EUR, …).
  static int minorUnitDigits(String currencyCode) =>
      zeroDecimalCurrencies.contains(currencyCode.toUpperCase()) ? 0 : 2;

  /// Rounds [value] to the smallest payable unit of [currencyCode]. IDR is
  /// rounded to whole rupiah; USD to the cent. This is what money math must use
  /// instead of a hardcoded 2-decimal (or hardcoded whole-unit) rounding, both
  /// of which are wrong for half of the currencies the app supports.
  static double roundToCurrency(double value, String currencyCode) {
    final factor = minorUnitDigits(currencyCode) == 0 ? 1.0 : 100.0;
    return (value * factor).roundToDouble() / factor;
  }
}
