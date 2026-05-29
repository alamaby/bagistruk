import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/auth_snapshot.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../../auth/providers/auth_providers.dart';
import '../widgets/paywall_bottom_sheet.dart';

class MainShellScreen extends ConsumerWidget {
  const MainShellScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const int _historyIndex = 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onSelect(context, ref, index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.document_scanner_outlined),
            selectedIcon: const Icon(Icons.document_scanner),
            label: l10n.scanTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.historyTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.settingsTab,
          ),
        ],
      ),
    );
  }

  void _onSelect(BuildContext context, WidgetRef ref, int index) {
    if (index == _historyIndex && !_isSignedIn(ref)) {
      showPaywallSheet(context);
      return;
    }
    // Tab Settings tidak lagi di-gate di sini. SettingsScreen sendiri yang
    // melakukan lazy `ensureSignedIn()` saat belum ada session, sehingga
    // pengguna anonymous (atau cold start sebelum anon dibuat) tetap dapat
    // mengakses preferensi seperti perilaku sebelumnya.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  AuthSnapshot? _snapshot(WidgetRef ref) =>
      switch (ref.read(authStateProvider)) {
        AsyncData<AuthSnapshot>(:final value) => value,
        _ => null,
      };

  bool _isSignedIn(WidgetRef ref) {
    final snap = _snapshot(ref);
    return snap?.userId != null && !(snap?.isAnonymous ?? true);
  }
}
