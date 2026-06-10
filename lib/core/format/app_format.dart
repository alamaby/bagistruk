import 'dart:ui';

import 'package:intl/intl.dart';

/// App-wide formatters.
class AppFormat {
  const AppFormat._();

  static const String locale = 'en_US';

  static String intlLocaleOf(Locale locale) {
    final country = locale.countryCode;
    return country == null || country.isEmpty
        ? locale.languageCode
        : '${locale.languageCode}_$country';
  }

  static NumberFormat currency([String? localeName]) => NumberFormat.currency(
    locale: localeName ?? locale,
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static DateFormat longDate([String? localeName]) =>
      DateFormat.yMMMMd(localeName ?? locale);

  static DateFormat shortDate([String? localeName]) =>
      DateFormat('dd/MM/yyyy', localeName ?? locale);
}
