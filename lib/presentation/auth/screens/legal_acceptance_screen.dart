import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/result.dart';
import '../../../core/router/routes.dart';
import '../../../data/providers.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../../settings/providers/profile_notifier.dart';

/// First-run gate that requires the user to actively opt in to the current
/// Terms of Service and Privacy Policy before any other route is reachable.
/// The router redirects here whenever
/// `profile.acceptedTermsVersion` / `acceptedPrivacyVersion` do not match
/// the current versions in `app_config`; the screen stamps the new
/// versions and returns the user to [from] (defaults to [Routes.scan]).
class LegalAcceptanceScreen extends ConsumerStatefulWidget {
  const LegalAcceptanceScreen({super.key, this.from});

  /// Location the user was trying to reach before the gate fired. The router
  /// encodes it as a `?from=<path>` query parameter so we can return the
  /// user to the right place after they accept.
  final String? from;

  @override
  ConsumerState<LegalAcceptanceScreen> createState() =>
      _LegalAcceptanceScreenState();
}

class _LegalAcceptanceScreenState extends ConsumerState<LegalAcceptanceScreen> {
  bool _termsChecked = false;
  bool _privacyChecked = false;
  bool _ageChecked = false;
  bool _submitting = false;

  bool get _busy => _submitting;
  bool get _canSubmit =>
      _termsChecked && _privacyChecked && _ageChecked && !_busy;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() => _submitting = true);
    final res = await ref
        .read(profileProvider.notifier)
        .recordLegalAcceptance();
    if (!mounted) return;
    setState(() => _submitting = false);
    switch (res) {
      case Success():
        // Stamp the adult-age declaration so AdMob/UMP can move the user
        // out of the conservative default (is_adult=FALSE = non-personalized
        // ads) once they confirm they are old enough.
        if (_ageChecked) {
          await ref.read(profileProvider.notifier).setIsAdult(isAdult: true);
        }
        if (!mounted) return;
        context.go(widget.from ?? Routes.scan);
      case ResultFailure():
        if (!mounted) return;
        _showError(AppL10n.of(context).legalAcceptanceErrorSave);
    }
  }

  void _showError(String message) {
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: scheme.errorContainer,
          content: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: scheme.onErrorContainer,
                size: 20.r,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: scheme.onErrorContainer,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final scheme = Theme.of(context).colorScheme;

    // If appConfigProvider is still loading on first frame (network blip on
    // cold start), show a spinner rather than a half-rendered form. The
    // notifier falls back to version 1 in `AppConfig.fallback` so the form
    // becomes interactive as soon as the load resolves.
    final cfgAsync = ref.watch(appConfigProvider);
    if (cfgAsync is! AsyncData) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.legalAcceptanceAppBarTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      // The legal gate cannot be skipped; the user must accept both
      // documents or close the app. Swiping back / pressing the system
      // back button is intentionally blocked.
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.legalAcceptanceAppBarTitle),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            children: [
              SizedBox(height: 8.h),
              Text(
                l10n.legalAcceptanceTitle,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                l10n.legalAcceptanceIntro,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 4.h,
                children: [
                  TextButton.icon(
                    onPressed: _busy
                        ? null
                        : () => context.pushNamed(Routes.termsOfServiceName),
                    icon: const Icon(Icons.description_outlined, size: 18),
                    label: Text(l10n.legalAcceptanceReadTerms),
                  ),
                  TextButton.icon(
                    onPressed: _busy
                        ? null
                        : () => context.pushNamed(Routes.privacyPolicyName),
                    icon: const Icon(Icons.privacy_tip_outlined, size: 18),
                    label: Text(l10n.legalAcceptanceReadPrivacy),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              _ConsentCheckbox(
                value: _termsChecked,
                onChanged: _busy
                    ? null
                    : (v) => setState(() => _termsChecked = v ?? false),
                label: l10n.legalAcceptanceAgreeTerms,
              ),
              _ConsentCheckbox(
                value: _privacyChecked,
                onChanged: _busy
                    ? null
                    : (v) => setState(() => _privacyChecked = v ?? false),
                label: l10n.legalAcceptanceAgreePrivacy,
              ),
              _ConsentCheckbox(
                value: _ageChecked,
                onChanged: _busy
                    ? null
                    : (v) => setState(() => _ageChecked = v ?? false),
                label: l10n.legalAcceptanceAgreeAge,
              ),
              SizedBox(height: 24.h),
              FilledButton(
                onPressed: _canSubmit ? _submit : null,
                child: _submitting
                    ? SizedBox(
                        height: 20.r,
                        width: 20.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(scheme.onPrimary),
                        ),
                      )
                    : Text(
                        l10n.legalAcceptanceContinue,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsentCheckbox extends StatelessWidget {
  const _ConsentCheckbox({
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Material 3 CheckboxListTile has a lot of built-in padding that
          // fights the ListView layout here, so a tight Row with Checkbox
          // + Text is more predictable for a 2-checkbox consent form.
          SizedBox(
            height: 32.r,
            width: 32.r,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: GestureDetector(
              // Make the whole row tappable (not just the checkbox), which
              // is the standard mobile UX for consent forms.
              behavior: HitTestBehavior.opaque,
              onTap: onChanged == null ? null : () => onChanged!(!value),
              child: Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
