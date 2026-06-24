import 'package:bagistruk/domain/entities/ocr_result.dart';
import 'package:bagistruk/domain/services/ocr_scale_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OcrScaleNormalizer.normalizeZeroDecimalScale', () {
    test('non-zero-decimal currency returns unchanged', () {
      final ocr = OcrResult(
        items: [OcrLineItem(name: 'Item', price: 1.5)],
        detectedTotal: 1000,
        providerUsed: 'test',
      );
      final result = OcrScaleNormalizer.normalizeZeroDecimalScale(ocr, 'USD');
      expect(result.items.single.price, 1.5);
    });

    test('null detectedTotal returns unchanged', () {
      final ocr = OcrResult(
        items: [OcrLineItem(name: 'Item', price: 1.5)],
        detectedTotal: null,
        providerUsed: 'test',
      );
      final result = OcrScaleNormalizer.normalizeZeroDecimalScale(ocr, 'IDR');
      expect(result.items.single.price, 1.5);
    });

    test('detectedTotal < 1000 returns unchanged', () {
      final ocr = OcrResult(
        items: [OcrLineItem(name: 'Item', price: 1.5)],
        detectedTotal: 500,
        providerUsed: 'test',
      );
      final result = OcrScaleNormalizer.normalizeZeroDecimalScale(ocr, 'IDR');
      expect(result.items.single.price, 1.5);
    });

    test('item prices scaled by 1000 when candidate improves match', () {
      final ocr = OcrResult(
        items: [OcrLineItem(name: 'Nasi Goreng', price: 25, qty: 1)],
        detectedTotal: 25000,
        providerUsed: 'test',
      );
      final result = OcrScaleNormalizer.normalizeZeroDecimalScale(ocr, 'IDR');
      expect(result.items.single.price, 25000);
    });

    test('tax and service also scaled when they improve match', () {
      final ocr = OcrResult(
        items: [OcrLineItem(name: 'Nasi Goreng', price: 25, qty: 1)],
        detectedTax: 2.5,
        detectedService: 1.5,
        detectedTotal: 29000,
        providerUsed: 'test',
      );
      final result = OcrScaleNormalizer.normalizeZeroDecimalScale(ocr, 'IDR');
      expect(result.items.single.price, 25000);
      expect(result.detectedTax, 2500);
      expect(result.detectedService, 1500);
    });

    test(
      'unchanged when current diff is already better than any candidate',
      () {
        // Items already sum close to detectedTotal, no scaling needed.
        final ocr = OcrResult(
          items: [OcrLineItem(name: 'Item', price: 25000, qty: 1)],
          detectedTotal: 25000,
          providerUsed: 'test',
        );
        final result = OcrScaleNormalizer.normalizeZeroDecimalScale(ocr, 'IDR');
        expect(result.items.single.price, 25000);
      },
    );

    test('unchanged when candidate diff exceeds tolerance', () {
      // Items sum to 30, detected total is 100000. Scaling items → 30000,
      // still far from 100000. Tolerance = 1000 (1% of 100000). 100000-30000
      // = 70000 > 1000, so unchanged.
      final ocr = OcrResult(
        items: [OcrLineItem(name: 'Item', price: 30, qty: 1)],
        detectedTotal: 100000,
        providerUsed: 'test',
      );
      final result = OcrScaleNormalizer.normalizeZeroDecimalScale(ocr, 'IDR');
      expect(result.items.single.price, 30);
    });

    test('handles multiple items correctly', () {
      final ocr = OcrResult(
        items: [
          OcrLineItem(name: 'A', price: 25, qty: 2),
          OcrLineItem(name: 'B', price: 10, qty: 1),
        ],
        detectedTotal: 60000,
        providerUsed: 'test',
      );
      final result = OcrScaleNormalizer.normalizeZeroDecimalScale(ocr, 'IDR');
      expect(result.items[0].price, 25000);
      expect(result.items[0].qty, 2);
      expect(result.items[1].price, 10000);
    });

    test('empty items list returns unchanged', () {
      final ocr = OcrResult(
        items: [],
        detectedTotal: 1000,
        providerUsed: 'test',
      );
      final result = OcrScaleNormalizer.normalizeZeroDecimalScale(ocr, 'IDR');
      expect(result.items, isEmpty);
    });
  });
}
