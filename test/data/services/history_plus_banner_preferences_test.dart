import 'package:bagistruk/data/services/history_plus_banner_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('HistoryPlusBannerPreferences', () {
    late HistoryPlusBannerPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await HistoryPlusBannerPreferences.create();
    });

    test('isDismissed returns false by default', () {
      expect(prefs.isDismissed(), false);
    });

    test('dismiss sets dismiss state to true', () async {
      await prefs.dismiss();
      expect(prefs.isDismissed(), true);
    });

    test('isDismissed returns true after dismiss across same instance', () async {
      expect(prefs.isDismissed(), false);
      await prefs.dismiss();
      expect(prefs.isDismissed(), true);
      expect(prefs.isDismissed(), true);
    });
  });
}
