import 'package:bagistruk/data/services/pending_registration_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Keys are duplicated from PendingRegistrationPreferences to act as a
// wire-format guard: if the persisted key names change, this test should
// fail loudly so the migration story is explicit.
const _kEmail = 'pending_registration_email_v1';
const _kMarketing = 'pending_registration_marketing_opt_in_v1';
const _kLanguage = 'pending_registration_language_v1';
const _kCreatedAt = 'pending_registration_created_at_v1';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PendingRegistrationPreferences', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('load returns null when no pending action was saved', () async {
      final prefs = await PendingRegistrationPreferences.create();
      expect(await prefs.load(), isNull);
    });

    test('save then load returns email, marketingOptIn, language', () async {
      final prefs = await PendingRegistrationPreferences.create();
      await prefs.save(
        email: 'user@example.com',
        marketingOptIn: true,
        preferredLanguage: 'id',
      );

      final loaded = await prefs.load();
      expect(loaded, isNotNull);
      expect(loaded!.email, 'user@example.com');
      expect(loaded.marketingOptIn, isTrue);
      expect(loaded.preferredLanguage, 'id');
      expect(loaded.createdAt.difference(DateTime.now().toUtc()).inSeconds,
          lessThan(5));
    });

    test('save with marketingOptIn false round-trips', () async {
      final prefs = await PendingRegistrationPreferences.create();
      await prefs.save(
        email: 'user@example.com',
        marketingOptIn: false,
        preferredLanguage: 'en',
      );

      final loaded = await prefs.load();
      expect(loaded, isNotNull);
      expect(loaded!.marketingOptIn, isFalse);
      expect(loaded.preferredLanguage, 'en');
    });

    test('clear removes all stored keys', () async {
      final prefs = await PendingRegistrationPreferences.create();
      await prefs.save(
        email: 'user@example.com',
        marketingOptIn: true,
        preferredLanguage: 'id',
      );
      expect(await prefs.load(), isNotNull);

      await prefs.clear();

      expect(await prefs.load(), isNull);
      final raw = await SharedPreferences.getInstance();
      expect(raw.getString(_kEmail), isNull);
      expect(raw.getBool(_kMarketing), isNull);
      expect(raw.getString(_kLanguage), isNull);
      expect(raw.getInt(_kCreatedAt), isNull);
    });

    test('expired action returns null and clears storage', () async {
      final eightDaysAgo = DateTime.now().toUtc()
          .subtract(const Duration(days: 8))
          .millisecondsSinceEpoch;
      SharedPreferences.setMockInitialValues({
        _kEmail: 'user@example.com',
        _kMarketing: true,
        _kLanguage: 'id',
        _kCreatedAt: eightDaysAgo,
      });

      final prefs = await PendingRegistrationPreferences.create();
      expect(await prefs.load(), isNull);

      final raw = await SharedPreferences.getInstance();
      expect(raw.getString(_kEmail), isNull);
      expect(raw.getBool(_kMarketing), isNull);
    });

    test('missing createdAt returns null', () async {
      SharedPreferences.setMockInitialValues({
        _kEmail: 'user@example.com',
        _kMarketing: true,
        _kLanguage: 'id',
      });

      final prefs = await PendingRegistrationPreferences.create();
      expect(await prefs.load(), isNull);
    });

    test('fresh action within TTL is preserved', () async {
      final sixDaysAgo = DateTime.now().toUtc()
          .subtract(const Duration(days: 6))
          .millisecondsSinceEpoch;
      SharedPreferences.setMockInitialValues({
        _kEmail: 'user@example.com',
        _kMarketing: true,
        _kLanguage: 'id',
        _kCreatedAt: sixDaysAgo,
      });

      final prefs = await PendingRegistrationPreferences.create();
      final loaded = await prefs.load();
      expect(loaded, isNotNull);
      expect(loaded!.email, 'user@example.com');
    });

    test('missing marketingOptIn defaults to false on load', () async {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      SharedPreferences.setMockInitialValues({
        _kEmail: 'user@example.com',
        _kLanguage: 'id',
        _kCreatedAt: now,
      });

      final prefs = await PendingRegistrationPreferences.create();
      final loaded = await prefs.load();
      expect(loaded, isNotNull);
      expect(loaded!.marketingOptIn, isFalse);
      expect(loaded.preferredLanguage, 'id');
    });
  });
}
