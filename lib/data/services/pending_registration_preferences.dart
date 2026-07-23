import 'package:shared_preferences/shared_preferences.dart';

class PendingRegistrationPreferences {
  PendingRegistrationPreferences._(this._prefs);

  static const _emailKey = 'pending_registration_email_v1';
  static const _marketingKey = 'pending_registration_marketing_opt_in_v1';
  static const _languageKey = 'pending_registration_language_v1';
  static const _createdAtKey = 'pending_registration_created_at_v1';
  static const _maxAge = Duration(days: 7);

  final SharedPreferences _prefs;

  static Future<PendingRegistrationPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PendingRegistrationPreferences._(prefs);
  }

  /// Loads any pending registration action. If a stored action is older
  /// than the TTL, this method clears the storage and returns null.
  Future<PendingRegistrationAction?> load() async {
    final email = _prefs.getString(_emailKey);
    if (email == null || email.isEmpty) return null;
    final createdAtMillis = _prefs.getInt(_createdAtKey);
    if (createdAtMillis == null) return null;
    final createdAt =
        DateTime.fromMillisecondsSinceEpoch(createdAtMillis, isUtc: true);
    if (DateTime.now().toUtc().difference(createdAt) > _maxAge) {
      await clear();
      return null;
    }
    return PendingRegistrationAction(
      email: email,
      marketingOptIn: _prefs.getBool(_marketingKey) ?? false,
      preferredLanguage: _prefs.getString(_languageKey) ?? 'en',
      createdAt: createdAt,
    );
  }

  Future<void> save({
    required String email,
    required bool marketingOptIn,
    required String preferredLanguage,
  }) async {
    final now = DateTime.now().toUtc();
    await _prefs.setString(_emailKey, email);
    await _prefs.setBool(_marketingKey, marketingOptIn);
    await _prefs.setString(_languageKey, preferredLanguage);
    await _prefs.setInt(_createdAtKey, now.millisecondsSinceEpoch);
  }

  /// Awaits every `SharedPreferences.remove()` so callers can rely on
  /// the pending action being fully wiped before they proceed.
  Future<void> clear() async {
    await Future.wait<void>([
      _prefs.remove(_emailKey),
      _prefs.remove(_marketingKey),
      _prefs.remove(_languageKey),
      _prefs.remove(_createdAtKey),
    ]);
  }
}

class PendingRegistrationAction {
  const PendingRegistrationAction({
    required this.email,
    required this.marketingOptIn,
    required this.preferredLanguage,
    required this.createdAt,
  });

  final String email;
  final bool marketingOptIn;
  final String preferredLanguage;
  final DateTime createdAt;
}
