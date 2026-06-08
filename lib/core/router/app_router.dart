import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers.dart';
import '../../domain/entities/auth_snapshot.dart';
import '../../domain/entities/ocr_result.dart';
import '../../presentation/auth/providers/auth_providers.dart';
import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/auth/screens/register_screen.dart';
import '../../presentation/auth/screens/verify_email_screen.dart';
import '../../presentation/auth/screens/verify_otp_screen.dart';
import '../../presentation/bills/screens/bill_detail_screen.dart';
import '../../presentation/bills/screens/deleted_bills_screen.dart';
import '../../presentation/bills/screens/bill_review_screen.dart';
import '../../presentation/bills/screens/bill_split_screen.dart';
import '../../presentation/history/screens/history_screen.dart';
import '../../presentation/ocr/screens/receipt_capture_screen.dart';
import '../../presentation/about/screens/about_screen.dart';
import '../../presentation/about/screens/privacy_policy_screen.dart';
import '../../presentation/about/screens/terms_of_service_screen.dart';
import '../../presentation/settings/screens/settings_screen.dart';
import '../../presentation/settings/screens/transfer_bank_info_screen.dart';
import '../../presentation/shell/screens/main_shell_screen.dart';
import '../error/result.dart';
import 'routes.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refresh = _AuthRefreshNotifier();
  ref.listen(authStateProvider, (_, _) => refresh.bump());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Routes.scan,
    refreshListenable: refresh,
    redirect: (context, state) async {
      // Supabase email-link callback. Persist the callback session explicitly
      // before routing so email confirmation does not leave the app in the
      // previous anonymous session.
      final rawLoc = state.uri.toString();
      if (rawLoc.contains('access_token=') ||
          rawLoc.contains('refresh_token=') ||
          rawLoc.contains('code=') ||
          rawLoc.contains('type=email_change') ||
          rawLoc.contains('type=signup') ||
          rawLoc.contains('type=recovery') ||
          rawLoc.contains('error_description=')) {
        final result = await ref
            .read(authRepositoryProvider)
            .recoverSessionFromUri(state.uri);
        if (result is Success<void>) return Routes.history;
        return Routes.scan;
      }

      // Treat unknown state (first frame before stream emits) as anonymous —
      // bootstrap signs in anonymously before runApp, so this fallback avoids
      // flashing a logged-in screen while the stream is still warming up.
      final snap = switch (ref.read(authStateProvider)) {
        AsyncData<AuthSnapshot>(:final value) => value,
        _ => null,
      };
      final isAnon = snap?.isAnonymous ?? true;
      final isSignedIn = snap?.userId != null && !isAnon;

      final loc = state.matchedLocation;
      final goingToProtected = loc.startsWith(Routes.history);
      final onAuthScreen =
          loc == Routes.login ||
          loc == Routes.register ||
          loc == Routes.verifyEmail ||
          loc == Routes.verifyOtp;

      if (goingToProtected && !isSignedIn) {
        return '${Routes.login}?reason=save_history';
      }
      if (onAuthScreen && isSignedIn) {
        // Honor an explicit `from=<path>` (set by the paywall sheet so users
        // who triggered login from e.g. the Settings tab return there instead
        // of being bounced to /history).
        final from = state.uri.queryParameters['from'];
        if (from != null && from.isNotEmpty) return from;
        return Routes.history;
      }
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.scan,
                name: Routes.scanName,
                builder: (context, state) => const ReceiptCaptureScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.history,
                name: Routes.historyName,
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                name: Routes.settingsName,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.transferBankInfo,
        name: Routes.transferBankInfoName,
        builder: (context, state) => const TransferBankInfoScreen(),
      ),
      GoRoute(
        path: Routes.billReview,
        name: Routes.billReviewName,
        builder: (context, state) =>
            BillReviewScreen(ocr: state.extra! as OcrResult),
      ),
      GoRoute(
        path: Routes.billSplit,
        name: Routes.billSplitName,
        builder: (context, state) =>
            BillSplitScreen(billId: state.pathParameters['billId']!),
      ),
      GoRoute(
        path: Routes.billDetail,
        name: Routes.billDetailName,
        builder: (context, state) =>
            BillDetailScreen(billId: state.pathParameters['billId']!),
      ),
      GoRoute(
        path: Routes.deletedBills,
        name: Routes.deletedBillsName,
        builder: (context, state) => const DeletedBillsScreen(),
      ),
      GoRoute(
        path: Routes.login,
        name: Routes.loginName,
        builder: (context, state) => LoginScreen(
          reason: state.uri.queryParameters['reason'],
          from: state.uri.queryParameters['from'],
        ),
      ),
      GoRoute(
        path: Routes.register,
        name: Routes.registerName,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.verifyEmail,
        name: Routes.verifyEmailName,
        builder: (context, state) =>
            VerifyEmailScreen(email: state.uri.queryParameters['email'] ?? ''),
      ),
      GoRoute(
        path: Routes.verifyOtp,
        name: Routes.verifyOtpName,
        builder: (context, state) => VerifyOtpScreen(
          email: state.uri.queryParameters['email'] ?? '',
          from: state.uri.queryParameters['from'],
        ),
      ),
      GoRoute(
        path: Routes.about,
        name: Routes.aboutName,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: Routes.privacyPolicy,
        name: Routes.privacyPolicyName,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: Routes.termsOfService,
        name: Routes.termsOfServiceName,
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
    ],
  );
}

class _AuthRefreshNotifier extends ChangeNotifier {
  void bump() => notifyListeners();
}
