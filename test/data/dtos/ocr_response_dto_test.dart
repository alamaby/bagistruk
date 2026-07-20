import 'package:bagistruk/data/dtos/ocr_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OcrResponseDto.fromJsonLenient', () {
    test('parses a well-formed response', () {
      final dto = OcrResponseDto.fromJsonLenient({
        'items': [
          {'name': 'Nasi Goreng', 'price': 25000, 'qty': 1},
          {'name': 'Es Teh', 'price': 5000},
        ],
        'detected_total': 30000,
        'detected_tax': 0,
        'merchant': 'Warung Test',
        'confidence': 0.9,
        'provider_used': 'gemini',
      });

      expect(dto.items.length, 2);
      expect(dto.items[1].qty, 1.0); // default when absent
      expect(dto.detectedTotal, 30000);
      expect(dto.confidence, 0.9);
      expect(dto.providerUsed, 'gemini');
    });

    test('skips malformed items instead of discarding the whole scan', () {
      final dto = OcrResponseDto.fromJsonLenient({
        'items': [
          {'name': 'Good', 'price': 10000},
          {'name': 'Missing price', 'price': null}, // skipped
          {'price': 500}, // no name → skipped
          'not-an-object', // skipped
          {'name': 'Also good', 'price': 7500},
        ],
        'provider_used': 'gemini',
      });

      expect(dto.items.length, 2);
      expect(dto.items.map((e) => e.name), ['Good', 'Also good']);
    });

    test('accepts a stringified numeric price without throwing', () {
      final dto = OcrResponseDto.fromJsonLenient({
        'items': [
          {'name': 'Kopi', 'price': '15000'},
        ],
        'provider_used': 'openrouter',
      });

      expect(dto.items.single.price, 15000.0);
    });

    test('tolerates a missing items key → empty list, no throw', () {
      final dto = OcrResponseDto.fromJsonLenient({'provider_used': 'gemini'});
      expect(dto.items, isEmpty);
      expect(dto.detectedTotal, isNull);
      expect(dto.confidence, 0.0);
    });

    test('tolerates missing provider_used → "unknown"', () {
      final dto = OcrResponseDto.fromJsonLenient({
        'items': [
          {'name': 'X', 'price': 1},
        ],
      });
      expect(dto.providerUsed, 'unknown');
    });

    test('null numeric fields do not throw', () {
      final dto = OcrResponseDto.fromJsonLenient({
        'items': [
          {'name': 'X', 'price': 1000},
        ],
        'detected_total': null,
        'detected_tax': null,
        'detected_service': null,
        'confidence': null,
        'provider_used': 'gemini',
      });
      expect(dto.detectedTotal, isNull);
      expect(dto.detectedTax, isNull);
      expect(dto.detectedService, isNull);
      expect(dto.confidence, 0.0);
    });
  });
}
