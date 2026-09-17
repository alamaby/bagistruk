import 'package:bagistruk/core/error/failure.dart';
import 'package:bagistruk/core/error/result.dart';
import 'package:bagistruk/data/providers.dart';
import 'package:bagistruk/domain/entities/shared_bill.dart' as shared_bill;
import 'package:bagistruk/domain/repositories/i_bill_repository.dart';
import 'package:bagistruk/presentation/bills/providers/bill_share_link_notifier.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'bill_share_link_notifier_test.mocks.dart';

@GenerateMocks([IBillRepository])
void main() {
  // Needed for Clipboard.setData inside createAndCopy.
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockIBillRepository mockRepo;
  late ProviderContainer container;
  const billId = 'bill-1';

  setUpAll(() {
    provideDummy<Result<shared_bill.BillShareLink>>(
      Result.success(
        shared_bill.BillShareLink(
          tokenId: 'token-id',
          expiresAt: DateTime.utc(2026, 9, 9),
        ),
      ),
    );
    provideDummy<Result<void>>(const Result.success(null));
    provideDummy<Result<shared_bill.ShareQuota?>>(const Result.success(null));
  });

  setUp(() {
    mockRepo = MockIBillRepository();
    // Session guard runs before every share-link RPC — default to signed in;
    // individual tests override this stub for the failure path.
    when(
      mockRepo.ensureSignedIn(),
    ).thenAnswer((_) async => const Result.success(null));
    container = ProviderContainer(
      overrides: [billRepositoryProvider.overrideWithValue(mockRepo)],
    );
    // Family provider is autoDispose: keep it alive across reads.
    final sub = container.listen(billShareLinkFamily(billId), (_, _) {});
    addTearDown(sub.close);
  });

  tearDown(() {
    container.dispose();
  });

  BillShareLink notifier() =>
      container.read(billShareLinkFamily(billId).notifier);

  void stubCreateSuccess() {
    when(
      mockRepo.createShareToken(
        billId: anyNamed('billId'),
        tokenHash: anyNamed('tokenHash'),
      ),
    ).thenAnswer(
      (_) async => Result.success(
        shared_bill.BillShareLink(
          tokenId: 'token-id',
          expiresAt: DateTime.utc(2026, 9, 9),
        ),
      ),
    );
  }

  group('BillShareLink.createAndCopy', () {
    test('success stores tokenId/expiry/lastLink and returns link', () async {
      stubCreateSuccess();

      final result = await notifier().createAndCopy(billId);

      expect(result.link, startsWith('https://bagistruk.alamaby.com/s/'));
      expect(result.limited, isFalse);
      final state = container.read(billShareLinkFamily(billId)).value;
      expect(state?.tokenId, 'token-id');
      expect(state?.lastLink, result.link);
      // Only the SHA-256 hash travels — never the raw token.
      final captured = verify(
        mockRepo.createShareToken(
          billId: anyNamed('billId'),
          tokenHash: captureAnyNamed('tokenHash'),
        ),
      ).captured;
      expect(captured, hasLength(1));
      final hash = captured.single as String;
      expect(hash, matches(RegExp(r'^[0-9a-f]{64}$')));
      expect(hash.contains(result.link!.split('/').last), isFalse);
    });

    test('Free-limit failure preserves previously loaded state', () async {
      stubCreateSuccess();
      await notifier().createAndCopy(billId);
      final before = container.read(billShareLinkFamily(billId)).value;
      expect(before?.tokenId, 'token-id');

      when(
        mockRepo.createShareToken(
          billId: anyNamed('billId'),
          tokenHash: anyNamed('tokenHash'),
        ),
      ).thenAnswer(
        (_) async => const Result.failure(
          Failure.server(
            code: 400,
            message: 'share_token_limit: free bills allow 1 active link',
          ),
        ),
      );
      final result = await notifier().createAndCopy(billId);

      expect(result.link, isNull);
      expect(result.limited, isTrue);
      // Displayed expiry/revoke survives the failed create.
      final after = container.read(billShareLinkFamily(billId)).value;
      expect(after?.tokenId, 'token-id');
      expect(after?.lastLink, before?.lastLink);
    });

    test('generic failure preserves state and is not limited', () async {
      stubCreateSuccess();
      await notifier().createAndCopy(billId);

      when(
        mockRepo.createShareToken(
          billId: anyNamed('billId'),
          tokenHash: anyNamed('tokenHash'),
        ),
      ).thenAnswer(
        (_) async => const Result.failure(
          Failure.server(code: 500, message: 'boom'),
        ),
      );
      final result = await notifier().createAndCopy(billId);

      expect(result.link, isNull);
      expect(result.limited, isFalse);
      expect(
        container.read(billShareLinkFamily(billId)).value?.tokenId,
        'token-id',
      );
    });

    test('isLimitError matches case-insensitively', () {
      expect(
        BillShareLink.isLimitError(
          const Failure.server(code: 400, message: 'SHARE_TOKEN_LIMIT: x'),
        ),
        isTrue,
      );
      expect(BillShareLink.isLimitError(Exception('boom')), isFalse);
    });

    test('rate-limit failure preserves state and is not limited', () async {
      stubCreateSuccess();
      await notifier().createAndCopy(billId);

      when(
        mockRepo.createShareToken(
          billId: anyNamed('billId'),
          tokenHash: anyNamed('tokenHash'),
        ),
      ).thenAnswer(
        (_) async => const Result.failure(
          Failure.server(
            code: 400,
            message: 'share_token_rate_limited: max 20 links per day',
          ),
        ),
      );
      final result = await notifier().createAndCopy(billId);

      expect(result.link, isNull);
      expect(result.rateLimited, isTrue);
      expect(result.limited, isFalse);
      expect(
        container.read(billShareLinkFamily(billId)).value?.tokenId,
        'token-id',
      );
    });

    test('isRateLimited matches case-insensitively', () {
      expect(
        BillShareLink.isRateLimited(
          const Failure.server(code: 400, message: 'SHARE_TOKEN_RATE_LIMITED'),
        ),
        isTrue,
      );
      expect(
        BillShareLink.isRateLimited(
          const Failure.server(code: 400, message: 'share_token_limit: x'),
        ),
        isFalse,
      );
      expect(BillShareLink.isRateLimited(Exception('boom')), isFalse);
    });

    test('ensures a session before the first RPC', () async {
      stubCreateSuccess();

      await notifier().createAndCopy(billId);

      verify(mockRepo.ensureSignedIn()).called(1);
      verify(
        mockRepo.createShareToken(
          billId: anyNamed('billId'),
          tokenHash: anyNamed('tokenHash'),
        ),
      ).called(1);
    });

    test('sign-in failure surfaces generic failure without RPC', () async {
      when(mockRepo.ensureSignedIn()).thenAnswer(
        (_) async => const Result.failure(Failure.auth('no session')),
      );

      final result = await notifier().createAndCopy(billId);

      expect(result.link, isNull);
      expect(result.limited, isFalse);
      expect(result.rateLimited, isFalse);
      verifyNever(
        mockRepo.createShareToken(
          billId: anyNamed('billId'),
          tokenHash: anyNamed('tokenHash'),
        ),
      );
    });
  });

  group('BillShareLink.recopyOrRotate', () {
    test('known lastLink re-copies without any RPC', () async {
      // Clipboard channel succeeds in this harness.
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (
            call,
          ) async => null);
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance
            .defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null),
      );
      stubCreateSuccess();
      final first = await notifier().createAndCopy(billId);
      clearInteractions(mockRepo);

      final result = await notifier().recopyOrRotate(billId);

      expect(result.link, first.link);
      verifyNever(
        mockRepo.createShareToken(
          billId: anyNamed('billId'),
          tokenHash: anyNamed('tokenHash'),
        ),
      );
      verifyNever(mockRepo.revokeShareToken(any));
    });

    test('unknown lastLink rotates: revoke then fresh create', () async {
      stubCreateSuccess();
      // Reopened session: active link known, raw token forgotten.
      notifier().state = AsyncData(
        BillShareState(tokenId: 'old-token', expiresAt: DateTime.utc(2026, 9, 9)),
      );
      when(
        mockRepo.revokeShareToken(any),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await notifier().recopyOrRotate(billId);

      expect(result.link, startsWith('https://bagistruk.alamaby.com/s/'));
      verify(mockRepo.revokeShareToken('old-token')).called(1);
      verify(
        mockRepo.createShareToken(
          billId: anyNamed('billId'),
          tokenHash: anyNamed('tokenHash'),
        ),
      ).called(1);
      // Panel now shows the fresh link state.
      expect(
        container.read(billShareLinkFamily(billId)).value?.lastLink,
        result.link,
      );
    });
  });

  group('BillShareLink.revoke', () {
    test('success clears state', () async {
      stubCreateSuccess();
      await notifier().createAndCopy(billId);
      when(
        mockRepo.revokeShareToken(any),
      ).thenAnswer((_) async => const Result.success(null));

      final ok = await notifier().revoke('token-id');

      expect(ok, isTrue);
      expect(
        container.read(billShareLinkFamily(billId)).value,
        isNull,
      );
    });

    test('failure returns false', () async {
      when(mockRepo.revokeShareToken(any)).thenAnswer(
        (_) async => const Result.failure(
          Failure.server(code: 500, message: 'boom'),
        ),
      );

      expect(await notifier().revoke('token-id'), isFalse);
    });
  });

  group('BillShareLink.createAndCopy revokedCount', () {
    test('passes through server-reported auto-revoked count', () async {
      when(
        mockRepo.createShareToken(
          billId: anyNamed('billId'),
          tokenHash: anyNamed('tokenHash'),
        ),
      ).thenAnswer(
        (_) async => Result.success(
          shared_bill.BillShareLink(
            tokenId: 'token-id',
            expiresAt: DateTime.utc(2026, 9, 9),
            revokedCount: 2,
          ),
        ),
      );

      final result = await notifier().createAndCopy(billId);

      expect(result.link, isNotNull);
      expect(result.revokedCount, 2);
    });

    test('defaults to zero when the server omits the column', () async {
      stubCreateSuccess();

      final result = await notifier().createAndCopy(billId);

      expect(result.revokedCount, 0);
    });
  });

  group('shareQuotaProvider', () {
    test('returns quota on success', () async {
      when(mockRepo.getShareQuota()).thenAnswer(
        (_) async => const Result.success(
          shared_bill.ShareQuota(isPlus: true, activeCount: 4, maxAllowed: 5),
        ),
      );

      final quota = await container.read(shareQuotaProvider.future);

      expect(quota?.isPlus, isTrue);
      expect(quota?.activeCount, 4);
      expect(quota?.willExpireOld, isFalse);
    });

    test('free quota at cap reports willExpireOld', () async {
      when(mockRepo.getShareQuota()).thenAnswer(
        (_) async => const Result.success(
          shared_bill.ShareQuota(isPlus: false, activeCount: 1, maxAllowed: 1),
        ),
      );

      final quota = await container.read(shareQuotaProvider.future);

      expect(quota?.willExpireOld, isTrue);
    });

    test('failure surfaces as provider error (UI falls back)', () async {
      when(mockRepo.getShareQuota()).thenAnswer(
        (_) async => const Result.failure(Failure.unknown('boom', null)),
      );

      Object? caught;
      try {
        await container.read(shareQuotaProvider.future);
      } catch (e) {
        caught = e;
      }
      expect(caught, isA<Failure>());
    });
  });

  group('BillShareLink family scoping', () {
    test('different bills keep independent state', () async {
      stubCreateSuccess();
      await notifier().createAndCopy(billId);

      expect(
        container.read(billShareLinkFamily(billId)).value?.tokenId,
        'token-id',
      );
      // A second bill starts blank — no stale A→B detail leakage.
      expect(
        container.read(billShareLinkFamily('bill-2')).value,
        isNull,
      );
    });
  });
}
