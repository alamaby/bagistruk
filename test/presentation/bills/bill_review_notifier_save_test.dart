import 'package:bagistruk/core/error/failure.dart';
import 'package:bagistruk/core/error/result.dart';
import 'package:bagistruk/data/providers.dart';
import 'package:bagistruk/domain/entities/bill.dart';
import 'package:bagistruk/domain/entities/item.dart';
import 'package:bagistruk/domain/entities/ocr_result.dart';
import 'package:bagistruk/domain/repositories/i_bill_repository.dart';
import 'package:bagistruk/presentation/bills/providers/bill_review_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'bill_review_notifier_save_test.mocks.dart';

@GenerateMocks([IBillRepository])
void main() {
  late MockIBillRepository mockRepo;
  late ProviderContainer container;

  setUpAll(() {
    provideDummy<Result<void>>(const Result.success(null));
    provideDummy<Result<Bill>>(
      Result.success(
        Bill(
          id: '',
          title: '',
          totalAmount: 0,
          currencyCode: 'IDR',
          tax: 0,
          service: 0,
          createdAt: DateTime(2026),
        ),
      ),
    );
    provideDummy<Result<List<Item>>>(const Result.success([]));
  });

  setUp(() {
    mockRepo = MockIBillRepository();
    container = ProviderContainer(
      overrides: [billRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  OcrResult _dummyOcr() => const OcrResult(
    items: [OcrLineItem(name: 'Nasi Goreng', price: 25000, qty: 1)],
    detectedTotal: 25000,
    merchant: 'Warung Test',
    providerUsed: 'gemini',
  );

  BillReviewNotifier _notifier() {
    return container.read(billReviewFamily(_dummyOcr()).notifier);
  }

  group('BillReviewNotifier.save', () {
    test('happy path — ensureSignedIn succeeds → SaveSuccess', () async {
      when(
        mockRepo.ensureSignedIn(),
      ).thenAnswer((_) async => const Result.success(null));
      when(mockRepo.createBill(any)).thenAnswer(
        (_) async => Result.success(
          Bill(
            id: 'bill-1',
            title: 'Warung Test',
            totalAmount: 25000,
            currencyCode: 'IDR',
            tax: 0,
            service: 0,
            createdAt: DateTime(2026),
          ),
        ),
      );
      when(mockRepo.upsertItems(any)).thenAnswer(
        (_) async => const Result.success([
          Item(
            id: 'item-1',
            billId: 'bill-1',
            name: 'Nasi Goreng',
            price: 25000,
            qty: 1,
          ),
        ]),
      );

      final result = await _notifier().save();

      expect(result, isA<SaveSuccess>());
      verify(mockRepo.ensureSignedIn()).called(1);
      verify(mockRepo.createBill(any)).called(1);
      verify(mockRepo.upsertItems(any)).called(1);
    });

    test('session loss — ensureSignedIn fails → SaveError', () async {
      when(mockRepo.ensureSignedIn()).thenAnswer(
        (_) async => const Result.failure(
          Failure.auth('Anonymous sign-in returned no user'),
        ),
      );

      final result = await _notifier().save();

      expect(result, isA<SaveError>());
      expect((result as SaveError).kind, SaveErrorKind.saveBillFailed);
      expect(result.message, contains('Anonymous sign-in returned no user'));
      verify(mockRepo.ensureSignedIn()).called(1);
      verifyNever(mockRepo.createBill(any));
    });

    test('server 42501 — createBill fails after ensureSignedIn', () async {
      when(
        mockRepo.ensureSignedIn(),
      ).thenAnswer((_) async => const Result.success(null));
      when(mockRepo.createBill(any)).thenAnswer(
        (_) async => const Result.failure(
          Failure.server(
            code: 42501,
            message:
                'new row violates row-level security policy for table bills',
          ),
        ),
      );

      final result = await _notifier().save();

      expect(result, isA<SaveError>());
      expect((result as SaveError).kind, SaveErrorKind.saveBillFailed);
      expect(result.message, contains('42501'));
      verify(mockRepo.ensureSignedIn()).called(1);
      verify(mockRepo.createBill(any)).called(1);
      verifyNever(mockRepo.upsertItems(any));
    });
  });
}
