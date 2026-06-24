import 'package:bagistruk/presentation/bills/providers/bill_review_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BillReviewState.subtotal', () {
    test('empty items returns 0', () {
      final state = _state(items: []);
      expect(state.subtotal, 0);
    });

    test('sums price * qty', () {
      final state = _state(
        items: [_item(price: 10, qty: 2), _item(price: 5, qty: 3)],
      );
      expect(state.subtotal, 35);
    });
  });

  group('BillReviewState.grandTotal', () {
    test('equals subtotal + tax + service', () {
      final state = _state(items: [_item(price: 100)], tax: 10, service: 5);
      expect(state.grandTotal, 115);
    });
  });

  group('BillReviewState.hasMismatch', () {
    test('null detectedTotal returns false', () {
      final state = _state(detectedTotal: null);
      expect(state.hasMismatch, isFalse);
    });

    test('diff <= tolerance returns false', () {
      final state = _state(
        items: [_item(price: 100)],
        tax: 0,
        service: 0,
        detectedTotal: 100.5,
      );
      expect(state.hasMismatch, isFalse);
    });

    test('diff > tolerance returns true', () {
      final state = _state(
        items: [_item(price: 100)],
        tax: 0,
        service: 0,
        detectedTotal: 200,
      );
      expect(state.hasMismatch, isTrue);
    });

    test('edge case exactly at tolerance boundary returns false', () {
      final state = _state(
        items: [_item(price: 100)],
        tax: 0,
        service: 0,
        detectedTotal: 101,
      );
      expect(state.hasMismatch, isFalse);
    });
  });

  group('BillReviewState.suspectThousandsBug', () {
    test('non-zero-decimal currency returns false even with fractional', () {
      final state = _state(items: [_item(price: 1.5)], currency: 'USD');
      expect(state.suspectThousandsBug, isFalse);
    });

    test('zero-decimal currency with fractional item returns true', () {
      final state = _state(items: [_item(price: 1.5)], currency: 'IDR');
      expect(state.suspectThousandsBug, isTrue);
    });

    test('zero-decimal currency with fractional tax returns true', () {
      final state = _state(
        items: [_item(price: 10)],
        tax: 0.5,
        currency: 'JPY',
      );
      expect(state.suspectThousandsBug, isTrue);
    });

    test('zero-decimal currency with fractional service returns true', () {
      final state = _state(
        items: [_item(price: 10)],
        service: 0.25,
        currency: 'VND',
      );
      expect(state.suspectThousandsBug, isTrue);
    });

    test('zero-decimal currency with all integer values returns false', () {
      final state = _state(
        items: [_item(price: 10), _item(price: 25)],
        tax: 3,
        service: 2,
        currency: 'IDR',
      );
      expect(state.suspectThousandsBug, isFalse);
    });

    test('JPY, KHR, VND are all zero-decimal', () {
      for (final c in ['JPY', 'KHR', 'VND']) {
        final state = _state(items: [_item(price: 1.5)], currency: c);
        expect(
          state.suspectThousandsBug,
          isTrue,
          reason: '$c should be zero-decimal',
        );
      }
    });

    test('default currency is IDR (zero-decimal)', () {
      final state = _state(items: [_item(price: 1.5)]);
      expect(state.suspectThousandsBug, isTrue);
    });
  });
}

BillReviewItem _item({double price = 0, double qty = 1}) =>
    BillReviewItem(localId: 'id', name: 'Item', price: price, qty: qty);

BillReviewState _state({
  List<BillReviewItem> items = const [],
  double tax = 0,
  double service = 0,
  double? detectedTotal,
  String currency = 'IDR',
}) => BillReviewState(
  title: 'Test',
  items: items,
  tax: tax,
  service: service,
  detectedTotal: detectedTotal,
  confidence: 1.0,
  currency: currency,
);
