import 'dart:typed_data';

import 'package:bagistruk/core/error/failure.dart';
import 'package:bagistruk/core/error/result.dart';
import 'package:bagistruk/data/providers.dart';
import 'package:bagistruk/domain/entities/ocr_result.dart';
import 'package:bagistruk/presentation/ocr/providers/ocr_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../data/repositories/fake_ocr_repository.dart';

void main() {
  group('OcrNotifier', () {
    test('initial state is OcrIdle', () {
      final container = _createContainer(
        _resultRepo(Result.success(_successResult())),
      );
      final notifier = container.read(ocrProvider.notifier);
      expect(notifier.state, const OcrState.idle());
    });

    test('process sends images and yields success', () async {
      final images = [
        Uint8List.fromList([1, 2, 3]),
      ];
      final fake = _resultRepo(Result.success(_successResult()));
      final container = _createContainer(fake);
      final notifier = container.read(ocrProvider.notifier);

      await notifier.process(
        images,
        hint: 'receipt',
        currency: 'IDR',
        fingerprintHeaders: {'x-v2-sig': 'abc'},
      );

      // Verify forwarding
      expect(fake.capturedImages, equals(images));
      expect(fake.capturedHint, 'receipt');
      expect(fake.capturedCurrency, 'IDR');
      expect(fake.capturedFingerprint, containsPair('x-v2-sig', 'abc'));

      expect(notifier.state, isA<OcrSuccess>());
      expect((notifier.state as OcrSuccess).result.providerUsed, 'gemini');
    });

    test('process transitions through processing state', () async {
      final images = [
        Uint8List.fromList([1]),
      ];
      final fake = _resultRepo(Result.success(_successResult()));
      final container = _createContainer(fake);
      final notifier = container.read(ocrProvider.notifier);

      // Capture state after setting processing but before result
      final states = <OcrState>[];
      container.listen<OcrState>(ocrProvider, (_, next) => states.add(next));

      await notifier.process(images);

      expect(states.any((s) => s == const OcrState.processing(1)), isTrue);
      expect(states.any((s) => s is OcrSuccess), isTrue);
    });

    test('process failure yields OcrFailure', () async {
      final fake = _resultRepo(
        const Result.failure(Failure.server(message: 'OCR failed')),
      );
      final container = _createContainer(fake);
      final notifier = container.read(ocrProvider.notifier);

      await notifier.process([
        Uint8List.fromList([1]),
      ]);

      expect(notifier.state, isA<OcrFailure>());
      final failure = (notifier.state as OcrFailure).failure;
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).message, 'OCR failed');
    });

    test('reset returns to OcrIdle', () async {
      final container = _createContainer(
        _resultRepo(Result.success(_successResult())),
      );
      final notifier = container.read(ocrProvider.notifier);

      await notifier.process([
        Uint8List.fromList([1]),
      ]);
      expect(notifier.state, isA<OcrSuccess>());

      notifier.reset();
      expect(notifier.state, const OcrState.idle());
    });

    test('multiple process calls reset state each time', () async {
      final container = _createContainer(
        _resultRepo(Result.success(_successResult())),
      );
      final notifier = container.read(ocrProvider.notifier);

      await notifier.process([
        Uint8List.fromList([1]),
      ]);
      expect(notifier.state, isA<OcrSuccess>());

      await notifier.process([
        Uint8List.fromList([2]),
      ]);
      expect(notifier.state, isA<OcrSuccess>());
      expect((notifier.state as OcrSuccess).result.providerUsed, 'gemini');
    });

    test('empty image list still processes (server may reject)', () async {
      final fake = _resultRepo(
        const Result.failure(Failure.server(message: 'No images')),
      );
      final container = _createContainer(fake);
      final notifier = container.read(ocrProvider.notifier);

      await notifier.process([]);
      expect(notifier.state, isA<OcrFailure>());
    });
  });
}

OcrResult _successResult() => const OcrResult(
  items: [OcrLineItem(name: 'Nasi Goreng', price: 25000)],
  detectedTotal: 25000,
  providerUsed: 'gemini',
);

FakeOCRRepository _resultRepo(Result<OcrResult> result) =>
    FakeOCRRepository(result);

ProviderContainer _createContainer(FakeOCRRepository repo) => ProviderContainer(
  overrides: [ocrRepositoryProvider.overrideWithValue(repo)],
);
