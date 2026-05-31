import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed accessor for environment variables loaded from `.env`.
///
/// Why a wrapper: callers should not depend on dotenv directly so the source
/// of secrets can swap (e.g. `--dart-define`, remote config) without touching
/// every call-site.
class Env {
  const Env._();

  static String get supabaseUrl => _required('SUPABASE_URL');
  static String get supabaseAnonKey => _required('SUPABASE_ANON_KEY');
  static String get googleWebClientId => _required('GOOGLE_WEB_CLIENT_ID');
  static String? get googleIosClientId => _optional('GOOGLE_IOS_CLIENT_ID');
  static bool get adsEnabled => _optionalBool('ADS_ENABLED');
  static String? get admobAndroidBannerId =>
      _optional('ADMOB_ANDROID_BANNER_ID');
  static String? get admobIosBannerId => _optional('ADMOB_IOS_BANNER_ID');

  static String _required(String key) {
    final value = dotenv.maybeGet(key);
    if (value == null || value.isEmpty) {
      throw StateError('Missing required env var: $key. See .env.example.');
    }
    return value;
  }

  static String? _optional(String key) {
    final value = dotenv.maybeGet(key);
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static bool _optionalBool(String key) {
    final value = dotenv.maybeGet(key)?.trim().toLowerCase();
    return value == 'true' || value == '1' || value == 'yes';
  }
}
