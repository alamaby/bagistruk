import 'package:shared_preferences/shared_preferences.dart';

class HistoryPlusBannerPreferences {
  HistoryPlusBannerPreferences._(this._prefs);

  static const _key = 'history_plus_banner_dismissed_v1';

  final SharedPreferences _prefs;

  static Future<HistoryPlusBannerPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return HistoryPlusBannerPreferences._(prefs);
  }

  bool isDismissed() => _prefs.getBool(_key) ?? false;

  Future<void> dismiss() => _prefs.setBool(_key, true);
}
