/// Runtime app configuration sourced from the `app_config` table. Currently
/// carries legal document version numbers; designed to be extended with
/// feature flags or remote-toggleable settings without a code release.
class AppConfig {
  const AppConfig({required this.termsVersion, required this.privacyVersion});

  /// Conservative fallback used when the `app_config` table cannot be read
  /// (network error, RLS denial, missing rows). Version `1` matches the
  /// initial seed so a fresh install sees a working gate even offline.
  static const AppConfig fallback = AppConfig(
    termsVersion: 1,
    privacyVersion: 1,
  );

  final int termsVersion;
  final int privacyVersion;

  /// Parses the rows returned by `select key, value from app_config`. Unknown
  /// keys fall back to `1`; malformed values fall back to `1`. The app does
  /// not crash on a missing or misconfigured config row.
  factory AppConfig.fromRows(List<Map<String, dynamic>> rows) {
    int parse(String key) {
      final match = rows
          .where((r) => r['key'] == key)
          .map((r) => r['value'])
          .firstOrNull;
      if (match is num) return match.toInt();
      if (match is String) return int.tryParse(match) ?? 1;
      return 1;
    }

    return AppConfig(
      termsVersion: parse('legal.terms_version'),
      privacyVersion: parse('legal.privacy_version'),
    );
  }

  AppConfig copyWith({int? termsVersion, int? privacyVersion}) => AppConfig(
    termsVersion: termsVersion ?? this.termsVersion,
    privacyVersion: privacyVersion ?? this.privacyVersion,
  );
}
