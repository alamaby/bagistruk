import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/config/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/providers.dart';
import 'domain/entities/auth_snapshot.dart';
import 'l10n/generated/app_l10n.dart';
import 'presentation/auth/providers/auth_providers.dart';
import 'presentation/settings/providers/preferences_providers.dart';

class BagiStrukApp extends ConsumerStatefulWidget {
  const BagiStrukApp({super.key});

  @override
  ConsumerState<BagiStrukApp> createState() => _BagiStrukAppState();
}

class _BagiStrukAppState extends ConsumerState<BagiStrukApp>
    with WidgetsBindingObserver {
  DateTime? _lastActiveTouch;
  String? _lastActiveTouchUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _touchLastActive());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _touchLastActive();
    }
  }

  Future<void> _touchLastActive() async {
    final userId = ref.read(authRepositoryProvider).currentUserId;
    if (userId == null) return;

    final now = DateTime.now();
    final previous = _lastActiveTouch;
    if (_lastActiveTouchUserId == userId &&
        previous != null &&
        now.difference(previous) < AppConstants.lastActiveTouchInterval) {
      return;
    }
    _lastActiveTouch = now;
    _lastActiveTouchUserId = userId;
    await ref.read(profileRepositoryProvider).touchLastActive();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (_, next) {
      final snap = switch (next) {
        AsyncData<AuthSnapshot>(:final value) => value,
        _ => null,
      };
      if (snap?.userId != null) {
        _touchLastActive();
      }
    });

    return ScreenUtilInit(
      designSize: AppConstants.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        final router = ref.watch(appRouterProvider);
        final locale = ref.watch(localePrefProvider);
        final themeMode = ref.watch(themeModePrefProvider);
        return MaterialApp.router(
          title: 'BagiStruk',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          routerConfig: router,
          locale: locale,
          supportedLocales: AppL10n.supportedLocales,
          localizationsDelegates: AppL10n.localizationsDelegates,
        );
      },
    );
  }
}
