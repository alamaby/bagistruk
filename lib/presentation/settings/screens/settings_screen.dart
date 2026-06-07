import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../core/billing/google_play_billing_catalog.dart';
import '../../../core/error/result.dart';
import '../../../core/router/routes.dart';
import '../../../data/providers.dart';
import '../../../data/services/google_play_billing_service.dart';
import '../../../domain/entities/auth_snapshot.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../../ads/widgets/banner_ad_widget.dart';
import '../../auth/providers/auth_providers.dart';
import '../../credits/providers/ocr_credit_status_provider.dart';
import '../providers/profile_notifier.dart';
import '../providers/settings_actions.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/currency_picker_dialog.dart';
import '../widgets/edit_name_sheet.dart';
import '../widgets/language_picker_dialog.dart';
import '../widgets/theme_picker_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Guard supaya `ensureSignedIn` hanya dipicu sekali per mount, walaupun
  // build dijalankan ulang oleh perubahan state lain.
  bool _ensuringSession = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final authSnap = switch (ref.watch(authStateProvider)) {
      AsyncData<AuthSnapshot>(:final value) => value,
      _ => null,
    };

    // Belum ada session sama sekali (cold start sebelum lazy anon dijalankan).
    // Settings adalah surface read-only ringan (bahasa, tema, mata uang) yang
    // historis selalu bisa diakses — kita pakai jalur lazy anon yang sama
    // dengan scan/save bill supaya UX tidak berubah dari versi sebelumnya:
    // langsung tampilkan settings dengan profil anon ketimbang memaksa user
    // melalui paywall login.
    if (authSnap?.userId == null) {
      if (!_ensuringSession) {
        _ensuringSession = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ref.read(authRepositoryProvider).ensureSignedIn();
        });
      }
      return Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final profileAsync = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: profileAsync.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(profileProvider),
        ),
        data: (profile) => _SettingsBody(profile: profile),
      ),
    );
  }
}

class _SettingsBody extends ConsumerWidget {
  const _SettingsBody({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);
    final isAnon = profile.isAnonymous;
    final creditStatus = switch (ref.watch(ocrCreditStatusProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      children: [
        _SectionHeader(l10n.accountSection),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(
            isAnon
                ? l10n.anonDisplayName
                : (profile.displayName?.trim().isNotEmpty == true
                      ? profile.displayName!
                      : l10n.displayNameFallback),
          ),
          subtitle: Text(isAnon ? l10n.guestAccount : (profile.email ?? '—')),
        ),
        ListTile(
          leading: const Icon(Icons.document_scanner_outlined),
          title: Text(l10n.creditScanTitle),
          subtitle: Text(
            creditStatus == null
                ? l10n.creditStatusLoading
                : l10n.creditStatusRemaining(
                    creditStatus.balance,
                    creditStatus.monthlyAllowance,
                    creditStatus.planCode,
                  ),
          ),
        ),
        _BillingSection(
          isAnonymous: isAnon,
          isPlus: creditStatus?.isPlus ?? false,
        ),
        if (!isAnon)
          ListTile(
            leading: const Icon(Icons.account_balance_outlined),
            title: Text(l10n.transferBankSettingsTitle),
            subtitle: Text(
              (creditStatus?.isPlus ?? false)
                  ? l10n.transferBankSettingsSubtitle
                  : l10n.transferBankSettingsLockedSubtitle,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(Routes.transferBankInfoName),
          ),
        if (!isAnon)
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l10n.changeName),
            onTap: () => _onChangeName(context, ref),
          ),
        if (!isAnon)
          ListTile(
            leading: const Icon(Icons.lock_reset_outlined),
            title: Text(l10n.resetPassword),
            onTap: () => _onResetPassword(context, ref, profile.email ?? ''),
          ),
        ListTile(
          leading: Icon(
            Icons.delete_forever_outlined,
            color: theme.colorScheme.error,
          ),
          title: Text(
            l10n.deleteAccount,
            style: TextStyle(color: theme.colorScheme.error),
          ),
          subtitle: Text(l10n.deleteAccountSubtitle),
          onTap: () => _onDeleteAccount(context, ref),
        ),
        const Divider(),
        _SectionHeader(l10n.preferencesSection),
        ListTile(
          leading: const Icon(Icons.payments_outlined),
          title: Text(l10n.currencyLabel),
          trailing: Text(
            profile.defaultCurrency,
            style: theme.textTheme.bodyMedium,
          ),
          onTap: () => _onPickCurrency(context, ref, profile.defaultCurrency),
        ),
        ListTile(
          leading: const Icon(Icons.language_outlined),
          title: Text(l10n.languageLabel),
          trailing: Text(
            profile.languagePref.toUpperCase(),
            style: theme.textTheme.bodyMedium,
          ),
          onTap: () => _onPickLanguage(context, ref, profile.languagePref),
        ),
        ListTile(
          leading: const Icon(Icons.brightness_6_outlined),
          title: Text(l10n.themeLabel),
          trailing: Text(
            _themeLabel(l10n, profile.themePref),
            style: theme.textTheme.bodyMedium,
          ),
          onTap: () => _onPickTheme(context, ref, profile.themePref),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const BannerAdWidget(),
        ),
        const Divider(),
        _SectionHeader(l10n.aboutTitle),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(l10n.aboutSettingsTile),
          onTap: () => context.pushNamed(Routes.aboutName),
        ),
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: isAnon
              ? FilledButton.icon(
                  icon: const Icon(Icons.person_add_alt_1),
                  onPressed: () => context.pushNamed(Routes.registerName),
                  label: Text(l10n.registerPermanent),
                )
              : FilledButton.icon(
                  icon: const Icon(Icons.logout),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.errorContainer,
                    foregroundColor: theme.colorScheme.onErrorContainer,
                  ),
                  onPressed: () => _onLogout(context, ref),
                  label: Text(l10n.logout),
                ),
        ),
        SizedBox(height: 24.h),
        SizedBox(height: 12.h),
      ],
    );
  }

  String _themeLabel(AppL10n l10n, String pref) => switch (pref) {
    'light' => l10n.themeLight,
    'dark' => l10n.themeDark,
    _ => l10n.themeSystem,
  };

  Future<void> _onChangeName(BuildContext context, WidgetRef ref) async {
    final next = await showEditNameSheet(context, profile.displayName ?? '');
    if (next == null || next.trim().isEmpty) return;
    final res = await ref
        .read(profileProvider.notifier)
        .updateDisplayName(next);
    if (!context.mounted) return;
    if (res is ResultFailure<void>)
      _snack(context, AppL10n.of(context).errorGeneric);
  }

  Future<void> _onResetPassword(
    BuildContext context,
    WidgetRef ref,
    String email,
  ) async {
    final l10n = AppL10n.of(context);
    if (email.isEmpty) return;
    final ok = await showConfirmDialog(
      context,
      title: l10n.resetPasswordConfirmTitle,
      body: l10n.resetPasswordConfirmBody(email),
      confirmLabel: l10n.saveAction,
    );
    if (ok != true || !context.mounted) return;
    final res = await ref
        .read(authRepositoryProvider)
        .resetPasswordForEmail(email);
    if (!context.mounted) return;
    _snack(
      context,
      res is Success<void> ? l10n.resetPasswordSent : l10n.errorGeneric,
    );
  }

  Future<void> _onPickCurrency(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final code = await showCurrencyPickerDialog(context, current);
    if (code == null || code == current) return;
    final res = await ref.read(profileProvider.notifier).updateCurrency(code);
    if (!context.mounted) return;
    if (res is ResultFailure<void>)
      _snack(context, AppL10n.of(context).errorGeneric);
  }

  Future<void> _onPickLanguage(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final code = await showLanguagePickerDialog(context, current);
    if (code == null || code == current) return;
    final res = await ref.read(profileProvider.notifier).updateLanguage(code);
    if (!context.mounted) return;
    if (res is ResultFailure<void>)
      _snack(context, AppL10n.of(context).errorGeneric);
  }

  Future<void> _onPickTheme(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final mode = await showThemePickerDialog(context, current);
    if (mode == null || mode == current) return;
    final res = await ref.read(profileProvider.notifier).updateTheme(mode);
    if (!context.mounted) return;
    if (res is ResultFailure<void>)
      _snack(context, AppL10n.of(context).errorGeneric);
  }

  Future<void> _onLogout(BuildContext context, WidgetRef ref) async {
    final l10n = AppL10n.of(context);
    final ok = await showConfirmDialog(
      context,
      title: l10n.confirmLogoutTitle,
      body: l10n.confirmLogoutBody,
      confirmLabel: l10n.logout,
      destructive: true,
    );
    if (ok != true || !context.mounted) return;
    await performLogout(ref);
    // Router redirect handles navigation back to /scan when authState emits.
  }

  Future<void> _onDeleteAccount(BuildContext context, WidgetRef ref) async {
    final l10n = AppL10n.of(context);
    final firstOk = await showConfirmDialog(
      context,
      title: l10n.deleteAccountConfirmTitle,
      body: l10n.deleteAccountConfirmBody,
      confirmLabel: l10n.deleteAccount,
      destructive: true,
    );
    if (firstOk != true || !context.mounted) return;

    final phraseOk = await _showDeleteAccountPhraseDialog(context);
    if (phraseOk != true || !context.mounted) return;

    _showBlockingProgress(context, l10n.deleteAccountInProgress);
    final res = await performDeleteAccount(ref);
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    if (!context.mounted) return;

    if (res is Success<void>) {
      context.goNamed(Routes.scanName);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.deleteAccountSuccess)));
    } else {
      _snack(context, l10n.errorGeneric);
    }
  }

  Future<bool?> _showDeleteAccountPhraseDialog(BuildContext context) {
    final l10n = AppL10n.of(context);
    final phrase = l10n.deleteAccountConfirmPhrase;
    final controller = TextEditingController();

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            final canDelete = controller.text.trim() == phrase;
            return AlertDialog(
              title: Text(l10n.deleteAccountTypeTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.deleteAccountTypeBody(phrase)),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: phrase,
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) {
                      if (canDelete) Navigator.of(ctx).pop(true);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l10n.cancelAction),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(ctx).colorScheme.errorContainer,
                    foregroundColor: Theme.of(ctx).colorScheme.onErrorContainer,
                  ),
                  onPressed: canDelete
                      ? () => Navigator.of(ctx).pop(true)
                      : null,
                  child: Text(l10n.deleteAccount),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(controller.dispose);
  }

  void _showBlockingProgress(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
              SizedBox(width: 16.w),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _BillingSection extends ConsumerStatefulWidget {
  const _BillingSection({required this.isAnonymous, required this.isPlus});

  final bool isAnonymous;
  final bool isPlus;

  @override
  ConsumerState<_BillingSection> createState() => _BillingSectionState();
}

class _BillingSectionState extends ConsumerState<_BillingSection> {
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;
  List<ProductDetails> _products = const [];
  bool _loading = true;
  bool _busy = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    final billing = ref.read(googlePlayBillingServiceProvider);
    _purchaseSub = billing.purchaseStream.listen(_handlePurchases);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProducts());
  }

  @override
  void dispose() {
    _purchaseSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);
    final plus = _product(GooglePlayBillingCatalog.plusMonthly.id);
    final pack = _product(GooglePlayBillingCatalog.creditPacks.first.id);

    if (widget.isAnonymous) {
      return ListTile(
        leading: const Icon(Icons.workspace_premium_outlined),
        title: Text(l10n.billingTitle),
        subtitle: Text(l10n.billingAnonSubtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.pushNamed(Routes.registerName),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.billingTitle, style: theme.textTheme.titleMedium),
          if (_message != null) ...[
            SizedBox(height: 6.h),
            Text(_message!, style: theme.textTheme.bodySmall),
          ],
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.workspace_premium_outlined),
                onPressed: _canBuy(plus) && !widget.isPlus
                    ? () => _buy(plus!)
                    : null,
                label: Text(
                  widget.isPlus
                      ? l10n.billingPlusActive
                      : _buttonLabel(l10n.billingUpgradePlus, plus),
                ),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.add_card_outlined),
                onPressed: _canBuy(pack) ? () => _buy(pack!) : null,
                label: Text(_buttonLabel(l10n.billingBuyCredits, pack)),
              ),
              IconButton.outlined(
                tooltip: l10n.billingRestorePurchases,
                onPressed: _busy ? null : _restore,
                icon: const Icon(Icons.restore_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _canBuy(ProductDetails? product) =>
      !_loading && !_busy && product != null;

  String _buttonLabel(String fallback, ProductDetails? product) {
    if (_loading) return AppL10n.of(context).billingLoading;
    if (product == null) return fallback;
    return '$fallback ${product.price}';
  }

  ProductDetails? _product(String id) {
    for (final product in _products) {
      if (product.id == id) return product;
    }
    return null;
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      final billing = ref.read(googlePlayBillingServiceProvider);
      final available = await billing.isAvailable();
      if (!available) {
        if (!mounted) return;
        setState(() {
          _products = const [];
          _message = 'Google Play Billing belum tersedia di perangkat ini.';
        });
        return;
      }
      final response = await billing.loadProducts();
      if (!mounted) return;
      setState(() {
        _products = response.productDetails;
        _message = response.notFoundIDs.isEmpty
            ? null
            : 'Beberapa produk belum aktif di Play Console.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _message = 'Produk belum bisa dimuat.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _buy(ProductDetails product) async {
    setState(() {
      _busy = true;
      _message = 'Membuka Google Play...';
    });
    try {
      await ref.read(googlePlayBillingServiceProvider).buy(product);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _message = 'Pembelian belum bisa dimulai.';
      });
    }
  }

  Future<void> _restore() async {
    setState(() {
      _busy = true;
      _message = 'Memulihkan pembelian...';
    });
    try {
      await ref.read(googlePlayBillingServiceProvider).restorePurchases();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _message = 'Pembelian belum bisa dipulihkan.';
      });
    }
  }

  Future<void> _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (!mounted) return;
      if (purchase.status == PurchaseStatus.pending) {
        setState(() {
          _busy = true;
          _message = 'Menunggu pembayaran Google Play...';
        });
        continue;
      }
      if (purchase.status == PurchaseStatus.error) {
        setState(() {
          _busy = false;
          _message = 'Pembelian dibatalkan atau gagal.';
        });
        continue;
      }
      final result = await ref
          .read(googlePlayBillingServiceProvider)
          .verifyAndFinish(purchase);
      if (!mounted) return;
      switch (result) {
        case Success<void>():
          ref.invalidate(ocrCreditStatusProvider);
          setState(() {
            _busy = false;
            _message = 'Pembelian berhasil diproses.';
          });
        case ResultFailure<void>():
          setState(() {
            _busy = false;
            _message = 'Pembelian belum bisa diverifikasi.';
          });
      }
    }
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          SizedBox(height: 12.h),
          Text(message),
          SizedBox(height: 12.h),
          OutlinedButton(
            onPressed: onRetry,
            child: Text(AppL10n.of(context).retry),
          ),
        ],
      ),
    );
  }
}
