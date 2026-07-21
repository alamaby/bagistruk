import 'package:bagistruk/domain/entities/ocr_credit_status.dart';
import 'package:bagistruk/l10n/generated/app_l10n.dart';
import 'package:bagistruk/presentation/credits/providers/ocr_credit_status_provider.dart';
import 'package:bagistruk/presentation/history/providers/history_list_notifier.dart';
import 'package:bagistruk/presentation/history/screens/history_screen.dart';
import 'package:bagistruk/presentation/insights/providers/monthly_spending_insight_provider.dart';
import 'package:bagistruk/presentation/settings/providers/preferences_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _emptyHistoryState = HistoryListState(isLoadingInitial: false);

final _historyListOverride =
    historyListProvider.overrideWithValue(_emptyHistoryState);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    dotenv.testLoad(mergeWith: {
      'ADS_ENABLED': 'false',
      'ADMOB_ANDROID_BANNER_HISTORY_ID': 'test',
      'SUPABASE_URL': 'http://test',
      'SUPABASE_ANON_KEY': 'test',
      'GOOGLE_WEB_CLIENT_ID': 'test',
    });
  });

  group('HistoryScreen banner', () {
    Widget buildApp({
      required OcrCreditStatus? creditStatus,
      Locale locale = const Locale('id'),
    }) {
      return ProviderScope(
        overrides: [
          _historyListOverride,
          ocrCreditStatusProvider.overrideWithValue(
            AsyncValue.data(creditStatus),
          ),
          currencyPrefProvider.overrideWithValue('IDR'),
          monthlySpendingInsightProvider.overrideWithValue(
            AsyncValue.data(null),
          ),
        ],
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          home: ScreenUtilInit(
            designSize: const Size(393, 852),
            child: const HistoryScreen(),
          ),
        ),
      );
    }

    final plusStatus = OcrCreditStatus(
      planCode: 'plus',
      balance: 10,
      monthlyAllowance: 50,
      adsEnabled: false,
      plusFeaturesEnabled: true,
    );
    final freeStatus = OcrCreditStatus(
      planCode: 'free',
      balance: 5,
      monthlyAllowance: 10,
      adsEnabled: true,
      plusFeaturesEnabled: false,
    );

    testWidgets('Plus sees banner with close button when not dismissed',
        (tester) async {
      await tester.pumpWidget(buildApp(creditStatus: plusStatus));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Riwayat Plus'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('Plus banner renders immediately before provider resolves',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(buildApp(creditStatus: plusStatus));
      await tester.pump();

      expect(find.text('Riwayat Plus'), findsOneWidget);
    });

    testWidgets('Plus tap close hides banner', (tester) async {
      await tester.pumpWidget(buildApp(creditStatus: plusStatus));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Riwayat Plus'), findsNothing);
    });

    testWidgets('Plus banner hidden when persisted dismissed', (tester) async {
      SharedPreferences.setMockInitialValues({
        'history_plus_banner_dismissed_v1': true,
      });
      await tester.pumpWidget(buildApp(creditStatus: plusStatus));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Riwayat Plus'), findsNothing);
    });

    testWidgets('Free banner always visible with upgrade CTA',
        (tester) async {
      await tester.pumpWidget(buildApp(creditStatus: freeStatus));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Riwayat Free'), findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium_outlined), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('Free banner visible with CTA even with persisted dismiss',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'history_plus_banner_dismissed_v1': true,
      });
      await tester.pumpWidget(buildApp(creditStatus: freeStatus));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Riwayat Free'), findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium_outlined), findsOneWidget);
    });
  });

  group('HistoryScreen banner English locale', () {
    Widget buildApp({
      required OcrCreditStatus? creditStatus,
    }) {
      return ProviderScope(
        overrides: [
          _historyListOverride,
          ocrCreditStatusProvider.overrideWithValue(
            AsyncValue.data(creditStatus),
          ),
          currencyPrefProvider.overrideWithValue('USD'),
          monthlySpendingInsightProvider.overrideWithValue(
            AsyncValue.data(null),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          home: ScreenUtilInit(
            designSize: const Size(393, 852),
            child: const HistoryScreen(),
          ),
        ),
      );
    }

    final plusStatus = OcrCreditStatus(
      planCode: 'plus',
      balance: 10,
      monthlyAllowance: 50,
      adsEnabled: false,
      plusFeaturesEnabled: true,
    );
    final freeStatus = OcrCreditStatus(
      planCode: 'free',
      balance: 5,
      monthlyAllowance: 10,
      adsEnabled: true,
      plusFeaturesEnabled: false,
    );

    testWidgets('Plus shows Plus history banner and close button',
        (tester) async {
      await tester.pumpWidget(buildApp(creditStatus: plusStatus));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Plus history'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('Free shows Free history banner and upgrade CTA',
        (tester) async {
      await tester.pumpWidget(buildApp(creditStatus: freeStatus));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Free history'), findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium_outlined), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('Free banner persists in English with persisted dismiss',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'history_plus_banner_dismissed_v1': true,
      });
      await tester.pumpWidget(buildApp(creditStatus: freeStatus));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Free history'), findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium_outlined), findsOneWidget);
    });
  });
}
