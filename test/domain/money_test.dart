import 'package:bagistruk/domain/services/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money.minorUnitDigits', () {
    test('zero-decimal currencies have 0 digits', () {
      for (final c in ['IDR', 'JPY', 'KRW', 'VND', 'idr']) {
        expect(Money.minorUnitDigits(c), 0, reason: c);
      }
    });

    test('regular currencies have 2 digits', () {
      for (final c in ['USD', 'EUR', 'MYR', 'SGD', 'usd']) {
        expect(Money.minorUnitDigits(c), 2, reason: c);
      }
    });
  });

  group('Money.roundToCurrency', () {
    test('IDR rounds to whole rupiah', () {
      expect(Money.roundToCurrency(33333.33, 'IDR'), 33333.0);
      expect(Money.roundToCurrency(33333.67, 'IDR'), 33334.0);
    });

    test('USD rounds to the cent', () {
      expect(Money.roundToCurrency(12.505, 'USD'), 12.51);
      expect(Money.roundToCurrency(12.504, 'USD'), 12.50);
    });

    test('is case-insensitive on the currency code', () {
      expect(Money.roundToCurrency(10.5, 'idr'), 11.0);
    });
  });
}
