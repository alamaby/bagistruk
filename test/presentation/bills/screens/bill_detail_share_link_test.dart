import 'package:bagistruk/domain/entities/bill.dart';
import 'package:bagistruk/domain/entities/ocr_credit_status.dart';
import 'package:bagistruk/domain/entities/shared_bill.dart' as shared_bill;
import 'package:bagistruk/presentation/bills/providers/bill_detail_notifier.dart'
    show BillDetailNotifier, BillDetailState, billDetailFamily;
import 'package:bagistruk/presentation/bills/providers/bill_share_link_notifier.dart'
    show
        BillShareLink,
        BillShareState,
        ShareLinkResult,
        billShareLinkFamily,
        shareQuotaProvider;
import 'package:bagistruk/presentation/bills/screens/bill_detail_screen.dart';
import 'package:bagistruk/presentation/credits/providers/ocr_credit_status_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/widget_test_harness.dart';

const _freeStatus = OcrCreditStatus(
  planCode: 'free',
  balance: 5,
  monthlyAllowance: 10,
  adsEnabled: true,
  plusFeaturesEnabled: false,
);

const _plusStatus = OcrCreditStatus(
  planCode: 'plus',
  balance: 100,
  monthlyAllowance: 100,
  adsEnabled: false,
  plusFeaturesEnabled: true,
);

const _freeQuotaEmpty = shared_bill.ShareQuota(
  isPlus: false,
  activeCount: 0,
  maxAllowed: 1,
);

const _freeQuotaFull = shared_bill.ShareQuota(
  isPlus: false,
  activeCount: 1,
  maxAllowed: 1,
);

const _plusQuotaRoom = shared_bill.ShareQuota(
  isPlus: true,
  activeCount: 4,
  maxAllowed: 5,
);

const _plusQuotaFull = shared_bill.ShareQuota(
  isPlus: true,
  activeCount: 5,
  maxAllowed: 5,
);

BillDetailState _detailState() => BillDetailState(
  bill: Bill(
    id: 'bill-1',
    title: 'Bukber',
    totalAmount: 110000,
    createdAt: DateTime.utc(2026, 9, 2),
  ),
  items: const [],
  participants: const [],
  assignments: const [],
);

class _FakeBillDetail extends BillDetailNotifier {
  _FakeBillDetail(this._state);

  final BillDetailState _state;

  @override
  Future<BillDetailState> build(String billId) async => _state;
}

class _FakeBillShareLink extends BillShareLink {
  _FakeBillShareLink(this._link, {this.revokedCount = 0});

  final BillShareState? _link;
  final int revokedCount;
  int createCalls = 0;
  int recopyCalls = 0;

  @override
  Future<BillShareState?> build(String billId) async => _link;

  @override
  Future<void> load(String billId) async {
    // No-op: screen initState calls load(); the Supabase client backing
    // the real implementation is unavailable in widget tests.
  }

  @override
  Future<ShareLinkResult> createAndCopy(String billId) async {
    createCalls++;
    return ShareLinkResult.created(
      'https://bagistruk.alamaby.com/s/tok123',
      revokedCount: revokedCount,
    );
  }

  @override
  Future<ShareLinkResult> recopyOrRotate(String billId) async {
    recopyCalls++;
    return ShareLinkResult.created(
      'https://bagistruk.alamaby.com/s/tok456',
      revokedCount: 1,
    );
  }
}

Future<_FakeBillShareLink> _pumpSection(
  WidgetTester tester, {
  BillShareState? link,
  AsyncValue<shared_bill.ShareQuota?> quota = const AsyncData(_freeQuotaEmpty),
  OcrCreditStatus creditStatus = _freeStatus,
  int revokedCount = 0,
}) async {
  final fake = _FakeBillShareLink(link, revokedCount: revokedCount);
  setTestViewport(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        billDetailFamily.overrideWith(() => _FakeBillDetail(_detailState())),
        ocrCreditStatusProvider.overrideWithValue(AsyncData(creditStatus)),
        billShareLinkFamily.overrideWith(() => fake),
        shareQuotaProvider.overrideWithValue(quota),
      ],
      child: buildTestApp(child: const BillDetailScreen(billId: 'bill-1')),
    ),
  );
  await tester.pumpAndSettle();
  return fake;
}

Future<void> _tapCopyLink(WidgetTester tester) async {
  final copy = find.text('Copy link');
  await tester.ensureVisible(copy);
  await tester.pumpAndSettle();
  await tester.tap(copy);
  await tester.pumpAndSettle();
}

void main() {
  group('_ShareLinkSection visible (kill switch on)', () {
    testWidgets('no link shows free quota note + create button', (
      tester,
    ) async {
      await _pumpSection(tester, link: null);

      expect(
        find.text('Free: 1 active link. A new link disables the old one.'),
        findsOneWidget,
      );
      expect(find.text('Copy link'), findsOneWidget);
    });

    testWidgets('plus quota shows usage note', (tester) async {
      await _pumpSection(
        tester,
        link: null,
        quota: const AsyncData(_plusQuotaRoom),
        creditStatus: _plusStatus,
      );

      expect(find.text('Plus: 4 of 5 links used.'), findsOneWidget);
    });

    testWidgets('active link shows countdown + revoke control', (tester) async {
      final expiresAt = DateTime.now().add(const Duration(days: 3, hours: 2));
      await _pumpSection(
        tester,
        link: BillShareState(tokenId: 't', expiresAt: expiresAt),
      );

      expect(find.text('Expires in 3 days'), findsOneWidget);
      expect(find.byTooltip('Disable link'), findsOneWidget);
    });

    testWidgets('expired link offers a fresh create', (tester) async {
      final expiresAt = DateTime.now().subtract(const Duration(minutes: 5));
      await _pumpSection(
        tester,
        link: BillShareState(tokenId: 't', expiresAt: expiresAt),
      );

      expect(find.text('This link is expired or invalid.'), findsOneWidget);
      expect(find.text('Copy link'), findsOneWidget);
    });
  });

  group('pre-create warnings', () {
    testWidgets('free at cap warns; cancel aborts, continue creates', (
      tester,
    ) async {
      final fake = await _pumpSection(
        tester,
        link: null,
        quota: const AsyncData(_freeQuotaFull),
      );

      await _tapCopyLink(tester);
      expect(find.text('Disable the old link?'), findsOneWidget);
      expect(find.text('Continue & copy'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(fake.createCalls, 0);
      expect(find.text('Disable the old link?'), findsNothing);

      await _tapCopyLink(tester);
      await tester.tap(find.text('Continue & copy'));
      await tester.pumpAndSettle();
      expect(fake.createCalls, 1);
    });

    testWidgets('free with room creates without dialog', (tester) async {
      final fake = await _pumpSection(tester, link: null);

      await _tapCopyLink(tester);

      expect(find.text('Disable the old link?'), findsNothing);
      expect(fake.createCalls, 1);
    });

    testWidgets('plus below cap creates without dialog', (tester) async {
      final fake = await _pumpSection(
        tester,
        link: null,
        quota: const AsyncData(_plusQuotaRoom),
        creditStatus: _plusStatus,
      );

      await _tapCopyLink(tester);

      expect(find.text('5-link limit reached'), findsNothing);
      expect(fake.createCalls, 1);
    });

    testWidgets('plus at cap warns about FIFO eviction', (tester) async {
      final fake = await _pumpSection(
        tester,
        link: null,
        quota: const AsyncData(_plusQuotaFull),
        creditStatus: _plusStatus,
      );

      await _tapCopyLink(tester);

      expect(find.text('5-link limit reached'), findsOneWidget);
      await tester.tap(find.text('Continue & copy'));
      await tester.pumpAndSettle();
      expect(fake.createCalls, 1);
    });

    testWidgets('unknown quota still warns free users (fail-safe)', (
      tester,
    ) async {
      final fake = await _pumpSection(
        tester,
        link: null,
        quota: AsyncError<shared_bill.ShareQuota?>(
          Exception('offline'),
          StackTrace.empty,
        ),
      );

      await _tapCopyLink(tester);

      expect(find.text('Disable the old link?'), findsOneWidget);
      await tester.tap(find.text('Continue & copy'));
      await tester.pumpAndSettle();
      expect(fake.createCalls, 1);
    });

    testWidgets('revoked older links are reported in the snackbar', (
      tester,
    ) async {
      await _pumpSection(
        tester,
        link: null,
        quota: const AsyncData(_freeQuotaFull),
        revokedCount: 1,
      );

      await _tapCopyLink(tester);
      await tester.tap(find.text('Continue & copy'));
      await tester.pumpAndSettle();

      expect(
        find.text('Link copied. Old link disabled (Free: 1 active link).'),
        findsOneWidget,
      );
    });

    testWidgets('rotating warns and reports the replacement', (
      tester,
    ) async {
      // Reopened session: active link known, raw token forgotten.
      final fake = await _pumpSection(
        tester,
        link: BillShareState(
          tokenId: 't',
          expiresAt: DateTime.now().add(const Duration(days: 2)),
        ),
      );

      final recopy = find.byTooltip('Copy link');
      await tester.ensureVisible(recopy);
      await tester.pumpAndSettle();
      await tester.tap(recopy);
      await tester.pumpAndSettle();

      expect(find.text('Replace the current link?'), findsOneWidget);
      await tester.tap(find.text('Continue & copy'));
      await tester.pumpAndSettle();

      expect(fake.recopyCalls, 1);
      expect(
        find.text('Link replaced. The old link no longer works.'),
        findsOneWidget,
      );
    });
  });
}
