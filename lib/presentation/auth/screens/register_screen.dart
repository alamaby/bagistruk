import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/result.dart';
import '../../../core/router/routes.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/providers.dart';
import '../../../l10n/generated/app_l10n.dart';
import '../utils/auth_messages.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_validators.dart';
import '../widgets/google_sign_in_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _googleLoading = false;
  bool _marketingOptIn = false;

  bool get _busy => _loading || _googleLoading;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    final repo = ref.read(authRepositoryProvider);

    // Lazy session bootstrap: `signUp()` aliases `linkEmail()` which calls
    // `_auth.updateUser(...)` — that API requires an existing session.
    // On a fresh install with no persisted session, ensure we have an
    // anonymous one first so the update can run. Idempotent: if a
    // session already exists (anon or email), this is a no-op.
    final ensured = await repo.ensureSignedIn();
    if (ensured is ResultFailure<String>) {
      AppLogger.error('RegisterScreen: ensureSignedIn failed', ensured.failure);
      if (!mounted) return;
      setState(() => _loading = false);
      _showError(friendlyAuthMessage(ensured.failure, AppL10n.of(context)));
      return;
    }

    final res = await repo.signUp(
      email: _email.text.trim(),
      password: _password.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    switch (res) {
      case Success():
        // Defer marketing opt-in and welcome marker until the user
        // actually confirms their email. Save the user's intent locally
        // so it can be applied after email confirmation. The router
        // callback consumes this pending action when it processes the
        // confirmation deep link. This avoids writing `welcomed_at`
        // and `marketing_email_opt_in_at` for unconfirmed accounts.
        //
        // Capture the values before any async gap so we don't reach
        // for `context` after `await` and don't lose the user's intent
        // if the screen unmounts.
        final rawEmail = _email.text.trim();
        final marketingOptIn = _marketingOptIn;
        final preferredLanguage =
            Localizations.localeOf(context).languageCode;
        try {
          final pendingPrefs = await ref
              .read(pendingRegistrationPreferencesProvider.future);
          await pendingPrefs.save(
            email: rawEmail,
            marketingOptIn: marketingOptIn,
            preferredLanguage: preferredLanguage,
          );
        } catch (e, st) {
          // Pending action save is best-effort. Account creation has
          // already succeeded; failing to stash the register-form intent
          // locally just means the welcome gate will pick the user up
          // after confirmation instead of the executor. Surface the
          // failure for observability but don't trap the user.
          AppLogger.error(
            'RegisterScreen: failed to save pending registration action',
            e,
            st,
          );
        }
        if (!mounted) return;
        final email = Uri.encodeQueryComponent(rawEmail);
        context.go('${Routes.verifyEmail}?email=$email');
      case ResultFailure(:final failure):
        _showError(friendlyAuthMessage(failure, AppL10n.of(context)));
    }
  }

  Future<void> _googleSignIn() async {
    if (_busy) return;
    setState(() => _googleLoading = true);
    final repo = ref.read(authRepositoryProvider);
    final res = await repo.signInWithGoogle();
    if (!mounted) return;
    setState(() => _googleLoading = false);
    switch (res) {
      case Success():
        context.go(Routes.history);
      case ResultFailure(:final failure):
        _showError(friendlyAuthMessage(failure, AppL10n.of(context)));
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.registerTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.registerBackToScanTooltip,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.scan);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: _busy ? null : () => context.go(Routes.scan),
            child: Text(l10n.registerSkip),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              children: [
                SizedBox(height: 16.h),
                Text(
                  l10n.registerHeading,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.registerSubtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 32.h),
                AuthTextField(
                  controller: _email,
                  label: l10n.authFieldEmail,
                  icon: Icons.email_outlined,
                  hint: l10n.loginEmailHint,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) => validateEmail(v, l10n),
                  autofillHints: const [
                    AutofillHints.email,
                    AutofillHints.username,
                  ],
                ),
                SizedBox(height: 16.h),
                AuthTextField(
                  controller: _password,
                  label: l10n.authFieldPassword,
                  icon: Icons.lock_outline,
                  hint: l10n.registerPasswordHint,
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  validator: (v) => validatePassword(v, l10n),
                  onSubmitted: (_) => _submit(),
                  autofillHints: const [AutofillHints.newPassword],
                ),
                SizedBox(height: 12.h),
                SwitchListTile.adaptive(
                  value: _marketingOptIn,
                  onChanged: _busy
                      ? null
                      : (v) => setState(() => _marketingOptIn = v),
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.registerMarketingOptIn,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Padding(
                  // Align the secondary link with the switch label, which
                  // starts ~56dp from the leading edge (icon + padding).
                  padding: EdgeInsets.only(left: 56.w, top: 2.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: _busy
                          ? null
                          : () => context.pushNamed(Routes.privacyPolicyName),
                      child: Text(
                        l10n.legalAcceptanceReadPrivacy,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: scheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                FilledButton(
                  onPressed: _busy ? null : _submit,
                  child: _loading
                      ? SizedBox(
                          height: 20.r,
                          width: 20.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(
                              scheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          l10n.registerTitle,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(child: Divider(color: scheme.outlineVariant)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        l10n.loginOr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: scheme.outlineVariant)),
                  ],
                ),
                SizedBox(height: 20.h),
                GoogleSignInButton(
                  enabled: !_busy,
                  loading: _googleLoading,
                  onPressed: _googleSignIn,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.registerHaveAccount,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: _busy ? null : () => context.go(Routes.login),
                      child: Text(
                        l10n.registerLoginLink,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
