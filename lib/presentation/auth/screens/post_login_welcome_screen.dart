import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/result.dart';
import '../../../core/router/routes.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../../settings/providers/profile_notifier.dart';

/// One-time screen shown by the router after a non-anonymous user
/// authenticates (currently Google sign-in) and has not been welcomed yet.
/// Collects an explicit marketing email opt-in and stamps `welcomed_at`
/// so the screen is not shown again. Email/password sign-up collects the
/// same opt-in on the register form and calls [ProfileNotifier.markWelcomed]
/// directly, so this screen is bypassed for that flow.
class PostLoginWelcomeScreen extends ConsumerStatefulWidget {
  const PostLoginWelcomeScreen({super.key, this.from});

  /// Location the user was trying to reach before the gate fired. The router
  /// encodes it as a `?from=<path>` query parameter so we can return the
  /// user to the right place after they finish the welcome step.
  final String? from;

  @override
  ConsumerState<PostLoginWelcomeScreen> createState() =>
      _PostLoginWelcomeScreenState();
}

class _PostLoginWelcomeScreenState
    extends ConsumerState<PostLoginWelcomeScreen> {
  bool _marketingOptIn = false;
  bool _submitting = false;

  bool get _busy => _submitting;

  Future<void> _submit() async {
    if (_busy) return;
    setState(() => _submitting = true);
    final notifier = ref.read(profileProvider.notifier);

    // Record the marketing opt-in first (if any). Failing here is reported
    // to the user but we do not stamp welcomed so they can retry on the
    // next tap. The marketing opt-in never silently fails.
    if (_marketingOptIn) {
      final res = await notifier.updateMarketingOptIn(
        optedIn: true,
        source: 'post_login_welcome',
      );
      if (!mounted) return;
      if (res is ResultFailure<void>) {
        _showError(AppL10n.of(context).postLoginWelcomeErrorSave);
        setState(() => _submitting = false);
        return;
      }
    }

    // Stamp welcomed so the screen is not shown again. If this fails the
    // user is stuck on the welcome screen and can retry; we do not
    // navigate.
    final markRes = await notifier.markWelcomed();
    if (!mounted) return;
    if (markRes is ResultFailure<void>) {
      _showError(AppL10n.of(context).postLoginWelcomeErrorSave);
      setState(() => _submitting = false);
      return;
    }

    setState(() => _submitting = false);
    context.go(widget.from ?? Routes.history);
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

    return PopScope(
      // Welcome cannot be skipped. The user has to either tap the marketing
      // switch (or not) and continue, or close the app.
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.postLoginWelcomeTitle),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            children: [
              SizedBox(height: 8.h),
              Text(
                l10n.postLoginWelcomeTitle,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                l10n.postLoginWelcomeBody,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: scheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: SwitchListTile.adaptive(
                  value: _marketingOptIn,
                  onChanged: _busy
                      ? null
                      : (v) => setState(() => _marketingOptIn = v),
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.postLoginWelcomeOptIn,
                    style: TextStyle(fontSize: 14.sp, color: scheme.onSurface),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              FilledButton(
                onPressed: _busy ? null : _submit,
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
                        l10n.postLoginWelcomeContinue,
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
