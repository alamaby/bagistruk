import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/billing/google_play_billing_catalog.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/error/result.dart';
import '../../../core/format/app_format.dart';
import '../../../core/router/routes.dart';
import '../../../data/providers.dart';
import '../../../data/services/google_play_billing_service.dart';
import '../../../domain/entities/auth_snapshot.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../../../core/ads/ad_config.dart';
import '../../../core/ads/ad_service.dart';
import '../../ads/widgets/banner_ad_widget.dart';
import '../providers/ad_privacy_options_provider.dart';
import '../../auth/providers/auth_providers.dart';
import '../../credits/providers/ocr_credit_status_provider.dart';
import '../../shared/widgets/plus_info_icon.dart';
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

  static String _entitlementExpiryLabel(
    AppL10n l10n,
    String? source,
    String date,
  ) {
    return switch (source) {
      'google_play_subscription' => l10n.creditPlusExpiresAt(date),
      'trial_plus' => l10n.creditTrialExpiresAt(date),
      _ => '',
    };
  }

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
          subtitle: creditStatus == null
              ? Text(l10n.creditStatusLoading)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.creditStatusRemaining(
                      creditStatus.balance,
                      creditStatus.monthlyAllowance,
                      creditStatus.planCode,
                    )),
                    if (creditStatus.entitlementExpiresAt != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        _entitlementExpiryLabel(
                          l10n,
                          creditStatus.entitlementSource,
                          AppFormat.longDate(
                            AppFormat.intlLocaleOf(
                              Localizations.localeOf(context),
                            ),
                          ).format(
                            creditStatus.entitlementExpiresAt!.toLocal(),
                          ),
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
        ),
        _BillingSection(
          isAnonymous: isAnon,
          isPlus: creditStatus?.isPlus ?? false,
        ),
        if (!isAnon)
          ListTile(
            leading: const _PlusFeatureLeadingIcon(
              icon: Icons.account_balance_outlined,
            ),
            title: Text(l10n.transferBankSettingsTitle),
            subtitle: Text(
              (creditStatus?.isPlus ?? false)
                  ? l10n.transferBankSettingsSubtitle
                  : l10n.plusOnlyShort,
            ),
            trailing: _SettingsTileTrailing(
              infoTitle: l10n.transferBankSettingsTitle,
              infoMessage: l10n.transferBankSettingsLockedSubtitle,
              showInfo: !(creditStatus?.isPlus ?? false),
            ),
            onTap: () => context.pushNamed(Routes.transferBankInfoName),
          ),
        if (!isAnon)
          ListTile(
            leading: const _PlusFeatureLeadingIcon(
              icon: Icons.restore_from_trash_outlined,
            ),
            title: Text(l10n.deletedBillsTitle),
            subtitle: Text(
              (creditStatus?.isPlus ?? false)
                  ? l10n.deletedBillsSettingsSubtitle
                  : l10n.plusOnlyShort,
            ),
            trailing: _SettingsTileTrailing(
              infoTitle: l10n.deletedBillsTitle,
              infoMessage: l10n.deletedBillsSettingsLockedSubtitle,
              showInfo: !(creditStatus?.isPlus ?? false),
            ),
            onTap: () => context.pushNamed(Routes.deletedBillsName),
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
        if (!isAnon)
          ListTile(
            leading: const Icon(Icons.mark_email_read_outlined),
            title: Text(l10n.settingsMarketingOptIn),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settingsMarketingOptInSubtitle),
                const SizedBox(height: 2),
                Text(
                  l10n.settingsMarketingOptInWebHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: Switch.adaptive(
              value: profile.marketingEmailOptIn,
              onChanged: (v) async {
                final res = await ref
                    .read(profileProvider.notifier)
                    .updateMarketingOptIn(
                      optedIn: v,
                      source: 'settings_toggle',
                    );
                if (context.mounted && res is ResultFailure<void>) {
                  _snack(context, AppL10n.of(context).errorGeneric);
                }
              },
            ),
          ),
        _AdPrivacyTile(),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: Text(l10n.onboardingSettingsTile),
          onTap: () => context.push('${Routes.onboarding}?mode=replay'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const BannerAdWidget(placement: BannerAdPlacement.settings),
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

class _SettingsTileTrailing extends StatelessWidget {
  const _SettingsTileTrailing({
    required this.infoTitle,
    required this.infoMessage,
    required this.showInfo,
  });

  final String infoTitle;
  final String infoMessage;
  final bool showInfo;

  @override
  Widget build(BuildContext context) {
    if (!showInfo) return const Icon(Icons.chevron_right);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlusInfoIcon(title: infoTitle, message: infoMessage),
        const Icon(Icons.chevron_right),
      ],
    );
  }
}

class _PlusFeatureLeadingIcon extends StatelessWidget {
  const _PlusFeatureLeadingIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 40.r,
      height: 40.r,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(alignment: Alignment.centerLeft, child: Icon(icon)),
          Positioned(
            right: 2.r,
            bottom: 2.r,
            child: Container(
              padding: EdgeInsets.all(2.r),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.surface, width: 1.5.r),
              ),
              child: Icon(
                Icons.workspace_premium_outlined,
                size: 13.r,
                color: scheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
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
  String? _processingProductId;
  bool _restoring = false;
  String? _globalMessage;
  final Map<String, String> _rowMessage = {};

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

    if (widget.isAnonymous) {
      return ListTile(
        leading: const Icon(Icons.workspace_premium_outlined),
        title: Text(l10n.billingTitle),
        subtitle: Text(l10n.billingAnonSubtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.pushNamed(Routes.registerName),
      );
    }

    final plus = _product(GooglePlayBillingCatalog.plusMonthly.id);
    final packs = _purchasableCreditPacks();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PlusSubscriptionCard(
            product: plus,
            isPlus: widget.isPlus,
            loading: _loading,
            busy: _processingProductId == plus?.id,
            message: plus == null ? _globalMessage : null,
            onSubscribe: plus == null || widget.isPlus
                ? null
                : () => _buy(plus),
            onManage: widget.isPlus ? _openPlaySubscriptions : null,
          ),
          if (packs.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _CreditTopUpCard(
              products: packs,
              loading: _loading,
              processingId: _processingProductId,
              rowMessage: _rowMessage,
              onBuy: _buy,
            ),
          ] else if (!_loading && _globalMessage == null)
            const SizedBox.shrink(),
          SizedBox(height: 8.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              icon: const Icon(Icons.restore_outlined),
              onPressed: _restoring ? null : _restore,
              label: Text(l10n.billingRestorePurchases),
            ),
          ),
          if (_globalMessage != null && _processingProductId == null) ...[
            SizedBox(height: 4.h),
            Text(
              _globalMessage!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  List<ProductDetails> _purchasableCreditPacks() {
    final ids = GooglePlayBillingCatalog.creditPacks
        .map((p) => p.id)
        .toSet();
    return _products.where((p) => ids.contains(p.id)).toList();
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
      _globalMessage = null;
      _rowMessage.clear();
    });
    try {
      final billing = ref.read(googlePlayBillingServiceProvider);
      final available = await billing.isAvailable();
      if (!available) {
        if (!mounted) return;
        setState(() {
          _products = const [];
          _globalMessage = AppL10n.of(context).billingUnavailable;
        });
        return;
      }
      final response = await billing.loadProducts();
      if (!mounted) return;
      setState(() {
        _products = response.productDetails;
      });
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _globalMessage = AppL10n.of(context).billingProductsLoadFailed,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _buy(ProductDetails product) async {
    setState(() {
      _processingProductId = product.id;
      _rowMessage[product.id] = AppL10n.of(context).billingOpeningPlay;
    });
    try {
      await ref.read(googlePlayBillingServiceProvider).buy(product);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _processingProductId = null;
        _rowMessage[product.id] =
            AppL10n.of(context).billingPurchaseStartFailed;
      });
    }
  }

  Future<void> _restore() async {
    setState(() {
      _restoring = true;
      _globalMessage = AppL10n.of(context).billingRestoringPurchases;
    });
    try {
      await ref.read(googlePlayBillingServiceProvider).restorePurchases();
    } catch (_) {
      if (!mounted) return;
      setState(() => _globalMessage = AppL10n.of(context).billingRestoreFailed);
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  Future<void> _openPlaySubscriptions() async {
    final url = Uri.parse(
      'https://play.google.com/store/account/subscriptions?package='
      '${Uri.encodeComponent(AppConstants.androidPackageName)}',
    );
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppL10n.of(context);
    final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.billingManageOpenFailed)),
      );
    }
  }

  Future<void> _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (!mounted) return;
      if (purchase.status == PurchaseStatus.pending) {
        setState(() {
          _processingProductId = purchase.productID;
          _rowMessage[purchase.productID] =
              AppL10n.of(context).billingPaymentPending;
        });
        continue;
      }
      if (purchase.status == PurchaseStatus.error) {
        setState(() {
          _processingProductId = null;
          _rowMessage[purchase.productID] =
              AppL10n.of(context).billingPurchaseFailed;
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
            _processingProductId = null;
            _rowMessage.remove(purchase.productID);
            _globalMessage = AppL10n.of(context).billingPurchaseSuccess;
          });
        case ResultFailure<void>():
          setState(() {
            _processingProductId = null;
            _rowMessage[purchase.productID] =
                AppL10n.of(context).billingPurchaseVerifyFailed;
          });
      }
    }
  }
}

class _PlusSubscriptionCard extends StatelessWidget {
  const _PlusSubscriptionCard({
    required this.product,
    required this.isPlus,
    required this.loading,
    required this.busy,
    required this.message,
    required this.onSubscribe,
    required this.onManage,
  });

  final ProductDetails? product;
  final bool isPlus;
  final bool loading;
  final bool busy;
  final String? message;
  final VoidCallback? onSubscribe;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final canBuy = product != null && !isPlus && !loading && !busy;
    return _BillingCard(
      title: l10n.billingPlusCardTitle,
      badge: isPlus ? l10n.billingPlusActive : l10n.billingPlanFree,
      badgeTone: isPlus ? _BadgeTone.active : _BadgeTone.neutral,
      benefits: [
        l10n.billingPlusBenefitCredits,
        l10n.billingPlusBenefitNoAds,
        l10n.billingPlusBenefitFeatures,
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isPlus && onManage != null)
            OutlinedButton.icon(
              icon: const Icon(Icons.open_in_new),
              onPressed: onManage,
              label: Text(l10n.billingManageSubscription),
            )
          else
            FilledButton.icon(
              icon: const Icon(Icons.workspace_premium_outlined),
              onPressed: canBuy ? onSubscribe : null,
              label: Text(
                loading && product == null
                    ? l10n.billingLoading
                    : l10n.billingUpgradePlusWithPrice(
                        product?.price ?? '',
                      ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
              ),
            ),
          if (message != null) ...[
            SizedBox(height: 8.h),
            Text(
              message!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CreditTopUpCard extends StatelessWidget {
  const _CreditTopUpCard({
    required this.products,
    required this.loading,
    required this.processingId,
    required this.rowMessage,
    required this.onBuy,
  });

  final List<ProductDetails> products;
  final bool loading;
  final String? processingId;
  final Map<String, String> rowMessage;
  final void Function(ProductDetails) onBuy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return _BillingCard(
      title: l10n.billingTopUpCardTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final product in products) ...[
            _CreditPackRow(
              product: product,
              busy: processingId == product.id,
              message: rowMessage[product.id],
              onBuy: () => onBuy(product),
            ),
            if (product != products.last) Divider(height: 24.h),
          ],
          if (loading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Center(
                child: Text(
                  l10n.billingLoading,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CreditPackRow extends StatelessWidget {
  const _CreditPackRow({
    required this.product,
    required this.busy,
    required this.message,
    required this.onBuy,
  });

  final ProductDetails product;
  final bool busy;
  final String? message;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final catalog = GooglePlayBillingCatalog.byId(product.id);
    final credits = catalog?.credits ?? 0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.billingCreditPackTitle(credits),
                style: theme.textTheme.titleSmall,
              ),
              if (message != null) ...[
                SizedBox(height: 2.h),
                Text(
                  message!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          product.price,
          style: theme.textTheme.titleSmall,
        ),
        SizedBox(width: 12.w),
        FilledButton.tonalIcon(
          icon: const Icon(Icons.add_card_outlined),
          onPressed: busy ? null : onBuy,
          label: Text(l10n.billingBuyAction),
        ),
      ],
    );
  }
}

enum _BadgeTone { active, neutral }

class _BillingCard extends StatelessWidget {
  const _BillingCard({
    required this.title,
    required this.child,
    this.badge,
    this.badgeTone = _BadgeTone.neutral,
    this.benefits = const [],
  });

  final String title;
  final String? badge;
  final _BadgeTone badgeTone;
  final List<String> benefits;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isActive = badgeTone == _BadgeTone.active;
    final badgeColor = isActive ? scheme.primary : scheme.surfaceContainerHigh;
    final badgeFg =
        isActive ? scheme.onPrimary : scheme.onSurfaceVariant;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (badge != null) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    badge!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: badgeFg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (benefits.isNotEmpty) ...[
            SizedBox(height: 10.h),
            for (final benefit in benefits) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 16.r,
                      color: scheme.primary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      benefit,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
            ],
          ],
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

class _AdPrivacyTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final required = switch (ref.watch(adPrivacyOptionsRequiredProvider)) {
      AsyncData(:final value) => value,
      _ => false,
    };
    if (!required) return const SizedBox.shrink();
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);
    return ListTile(
      leading: const Icon(Icons.privacy_tip_outlined),
      title: Text(l10n.adPrivacyChoicesTitle),
      subtitle: Text(
        l10n.adPrivacyChoicesSubtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: () => AdService.showConsentFormIfAvailable(),
    );
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
