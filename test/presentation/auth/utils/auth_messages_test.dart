import 'package:bagistruk/core/error/failure.dart';
import 'package:bagistruk/l10n/generated/app_l10n_en.dart';
import 'package:bagistruk/presentation/auth/utils/auth_messages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppL10nEn();

  group('friendlyAuthMessage', () {
    test('NetworkFailure returns network error message', () {
      final result = friendlyAuthMessage(
        const NetworkFailure('offline'),
        l10n,
      );
      expect(result, l10n.authErrorNetwork);
    });

    test('ServerFailure returns server error with message', () {
      final result = friendlyAuthMessage(
        const ServerFailure(code: 500, message: 'internal'),
        l10n,
      );
      expect(result, l10n.authErrorServer('internal'));
    });

    test('ParsingFailure returns parsing error message', () {
      final result = friendlyAuthMessage(
        const ParsingFailure('bad json'),
        l10n,
      );
      expect(result, l10n.authErrorParsing);
    });

    test('UnknownFailure returns unknown error message', () {
      final result = friendlyAuthMessage(
        UnknownFailure(Exception('boom'), null),
        l10n,
      );
      expect(result, l10n.authErrorUnknown);
    });

    test('AuthFailure delegates to _humanizeAuth', () {
      final result = friendlyAuthMessage(
        const AuthFailure('Invalid login credentials'),
        l10n,
      );
      expect(result, l10n.authErrorInvalidLogin);
    });
  });

  group('_humanizeAuth keyword matching', () {
    test('invalid login → authErrorInvalidLogin', () {
      expect(
        friendlyAuthMessage(const AuthFailure('Invalid login credentials'), l10n),
        l10n.authErrorInvalidLogin,
      );
    });

    test('invalid credentials (lowercase) → authErrorInvalidLogin', () {
      expect(
        friendlyAuthMessage(const AuthFailure('invalid credentials'), l10n),
        l10n.authErrorInvalidLogin,
      );
    });

    test('already registered → authErrorAlreadyRegistered', () {
      expect(
        friendlyAuthMessage(const AuthFailure('Email already registered'), l10n),
        l10n.authErrorAlreadyRegistered,
      );
    });

    test('user already exists → authErrorAlreadyRegistered', () {
      expect(
        friendlyAuthMessage(const AuthFailure('User already exists'), l10n),
        l10n.authErrorAlreadyRegistered,
      );
    });

    test('weak password → authErrorWeakPassword', () {
      expect(
        friendlyAuthMessage(const AuthFailure('Weak password should be longer'), l10n),
        l10n.authErrorWeakPassword,
      );
    });

    test('password should → authErrorWeakPassword', () {
      expect(
        friendlyAuthMessage(const AuthFailure('password should be at least 8'), l10n),
        l10n.authErrorWeakPassword,
      );
    });

    test('email not confirmed → authErrorEmailNotConfirmed', () {
      expect(
        friendlyAuthMessage(const AuthFailure('Email not confirmed'), l10n),
        l10n.authErrorEmailNotConfirmed,
      );
    });

    test('disposable_email → authErrorDisposableEmail', () {
      expect(
        friendlyAuthMessage(const AuthFailure('disposable_email'), l10n),
        l10n.authErrorDisposableEmail,
      );
    });

    test('email_alias_already_used → authErrorEmailAliasUsed', () {
      expect(
        friendlyAuthMessage(const AuthFailure('email_alias_already_used'), l10n),
        l10n.authErrorEmailAliasUsed,
      );
    });

    test('invalid_email → authErrorInvalidEmail', () {
      expect(
        friendlyAuthMessage(const AuthFailure('invalid_email'), l10n),
        l10n.authErrorInvalidEmail,
      );
    });

    test('oauth android → authErrorGoogleSignIn', () {
      expect(
        friendlyAuthMessage(const AuthFailure('OAuth Android configuration error'), l10n),
        l10n.authErrorGoogleSignIn,
      );
    });

    test('google sign-in → authErrorGoogleSignIn', () {
      expect(
        friendlyAuthMessage(const AuthFailure('Google sign-in canceled'), l10n),
        l10n.authErrorGoogleSignIn,
      );
    });

    test('coming soon → authErrorComingSoon', () {
      expect(
        friendlyAuthMessage(const AuthFailure('Coming soon: TBD'), l10n),
        l10n.authErrorComingSoon,
      );
    });

    test('empty raw returns fallback', () {
      expect(
        friendlyAuthMessage(const AuthFailure(''), l10n),
        l10n.authErrorFallback,
      );
    });

    test('no match returns raw as-is', () {
      expect(
        friendlyAuthMessage(const AuthFailure('Some other error'), l10n),
        'Some other error',
      );
    });

    test('case insensitive matching', () {
      expect(
        friendlyAuthMessage(const AuthFailure('MIXED INVALID LOGIN Case'), l10n),
        l10n.authErrorInvalidLogin,
      );
    });
  });
}
