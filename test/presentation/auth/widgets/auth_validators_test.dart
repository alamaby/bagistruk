import 'package:bagistruk/presentation/auth/widgets/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateEmail', () {
    test('null returns empty error', () {
      expect(validateEmail(null), 'Email wajib diisi');
    });

    test('empty string returns empty error', () {
      expect(validateEmail(''), 'Email wajib diisi');
    });

    test('whitespace only returns empty error', () {
      expect(validateEmail('   '), 'Email wajib diisi');
    });

    test('no @ sign returns format error', () {
      expect(validateEmail('foo'), 'Format email tidak valid');
    });

    test('no dot in domain returns format error', () {
      expect(validateEmail('foo@bar'), 'Format email tidak valid');
    });

    test('valid email returns null', () {
      expect(validateEmail('foo@bar.com'), isNull);
    });

    test('trimmed valid email returns null', () {
      expect(validateEmail('  user@example.com  '), isNull);
    });

    test('special chars in local part accepted by regex', () {
      expect(validateEmail('a.b+c@x.y'), isNull);
    });

    test('no local part returns format error (boundary)', () {
      expect(validateEmail('@x.com'), 'Format email tidak valid');
    });

    test('trailing dot in domain returns format error (boundary)', () {
      expect(validateEmail('a@b.'), 'Format email tidak valid');
    });

    test('very long email does not crash (security)', () {
      final longLocal = 'a' * 10000;
      final result = validateEmail('$longLocal@x.com');
      expect(result, isNull);
    });
  });

  group('validatePassword', () {
    test('null returns empty error', () {
      expect(validatePassword(null), 'Password wajib diisi');
    });

    test('empty string returns empty error', () {
      expect(validatePassword(''), 'Password wajib diisi');
    });

    test('5 chars returns length error', () {
      expect(validatePassword('12345'), 'Password minimal 6 karakter');
    });

    test('6 chars returns null', () {
      expect(validatePassword('123456'), isNull);
    });

    test('longer password returns null', () {
      expect(validatePassword('longerpassword'), isNull);
    });

    test('very long password does not crash (security)', () {
      final longPass = 'a' * 10000;
      expect(validatePassword(longPass), isNull);
    });
  });
}
