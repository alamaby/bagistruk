import 'package:intl/intl.dart';

class CurrencyDefinition {
  const CurrencyDefinition({
    required this.code,
    required this.displayName,
    required this.locale,
    required this.symbol,
    required this.decimalDigits,
  });

  final String code;
  final String displayName;
  final String locale;
  final String symbol;
  final int decimalDigits;
}

/// Currency formatting per ISO-4217 code.
///
/// Keep this registry aligned with DB constraints and the Edge Function's
/// zero-decimal list when adding currencies.
class CurrencyFormatter {
  const CurrencyFormatter._();

  static const List<CurrencyDefinition> definitions = <CurrencyDefinition>[
    CurrencyDefinition(
      code: 'IDR',
      displayName: 'Indonesian Rupiah (IDR)',
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ),
    CurrencyDefinition(
      code: 'BND',
      displayName: 'Brunei Dollar (BND)',
      locale: 'ms_BN',
      symbol: r'B$',
      decimalDigits: 2,
    ),
    CurrencyDefinition(
      code: 'KHR',
      displayName: 'Cambodian Riel (KHR)',
      locale: 'km_KH',
      symbol: 'KHR ',
      decimalDigits: 0,
    ),
    CurrencyDefinition(
      code: 'LAK',
      displayName: 'Lao Kip (LAK)',
      locale: 'lo_LA',
      symbol: '₭',
      decimalDigits: 0,
    ),
    CurrencyDefinition(
      code: 'MYR',
      displayName: 'Malaysian Ringgit (MYR)',
      locale: 'ms_MY',
      symbol: 'RM ',
      decimalDigits: 2,
    ),
    CurrencyDefinition(
      code: 'MMK',
      displayName: 'Myanmar Kyat (MMK)',
      locale: 'my_MM',
      symbol: 'K ',
      decimalDigits: 0,
    ),
    CurrencyDefinition(
      code: 'PHP',
      displayName: 'Philippine Peso (PHP)',
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    ),
    CurrencyDefinition(
      code: 'SGD',
      displayName: 'Singapore Dollar (SGD)',
      locale: 'en_SG',
      symbol: r'S$',
      decimalDigits: 2,
    ),
    CurrencyDefinition(
      code: 'THB',
      displayName: 'Thai Baht (THB)',
      locale: 'th_TH',
      symbol: '฿',
      decimalDigits: 2,
    ),
    CurrencyDefinition(
      code: 'VND',
      displayName: 'Vietnamese Dong (VND)',
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    ),
    CurrencyDefinition(
      code: 'INR',
      displayName: 'Indian Rupee (INR)',
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    ),
    CurrencyDefinition(
      code: 'JPY',
      displayName: 'Japanese Yen (JPY)',
      locale: 'ja_JP',
      symbol: '¥',
      decimalDigits: 0,
    ),
    CurrencyDefinition(
      code: 'CNY',
      displayName: 'Chinese Yuan (CNY)',
      locale: 'zh_CN',
      symbol: '¥',
      decimalDigits: 2,
    ),
    CurrencyDefinition(
      code: 'USD',
      displayName: 'US Dollar (USD)',
      locale: 'en_US',
      symbol: r'$',
      decimalDigits: 2,
    ),
    CurrencyDefinition(
      code: 'AUD',
      displayName: 'Australian Dollar (AUD)',
      locale: 'en_AU',
      symbol: r'A$',
      decimalDigits: 2,
    ),
    CurrencyDefinition(
      code: 'SAR',
      displayName: 'Saudi Riyal (SAR)',
      locale: 'ar_SA',
      symbol: 'ر.س ',
      decimalDigits: 2,
    ),
  ];

  static List<String> get supported =>
      definitions.map((definition) => definition.code).toList(growable: false);

  static Set<String> get supportedSet => supported.toSet();

  static CurrencyDefinition definitionOf(String code) {
    final normalized = code.trim().toUpperCase();
    return definitions.firstWhere(
      (definition) => definition.code == normalized,
      orElse: () => definitions.first,
    );
  }

  static NumberFormat of(String code) {
    final definition = definitionOf(code);
    return NumberFormat.currency(
      locale: definition.locale,
      symbol: definition.symbol,
      decimalDigits: definition.decimalDigits,
    );
  }

  /// Long display name shown in the picker dialog. Kept here so the screen
  /// does not need to maintain a parallel mapping.
  static String displayName(String code) => definitionOf(code).displayName;
}
