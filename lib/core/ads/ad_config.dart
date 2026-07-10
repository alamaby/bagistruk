import 'package:flutter/foundation.dart';

import '../config/env.dart';

enum BannerAdPlacement { scan, history, settings }

class AdConfig {
  const AdConfig._();

  static const _androidTestBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const _iosTestBannerId = 'ca-app-pub-3940256099942544/2934735716';

  static bool get isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static bool get adsEnabled => Env.adsEnabled && isSupportedPlatform;

  static String? bannerAdUnitId(BannerAdPlacement placement) {
    if (!isSupportedPlatform) return null;
    if (defaultTargetPlatform == TargetPlatform.android) {
      return switch (placement) {
        BannerAdPlacement.scan =>
          Env.admobAndroidBannerScanId ?? Env.admobAndroidBannerId ?? _androidTestBannerId,
        BannerAdPlacement.history =>
          Env.admobAndroidBannerHistoryId ?? Env.admobAndroidBannerId ?? _androidTestBannerId,
        BannerAdPlacement.settings =>
          Env.admobAndroidBannerSettingsId ?? Env.admobAndroidBannerId ?? _androidTestBannerId,
      };
    }
    return Env.admobIosBannerId ?? _iosTestBannerId;
  }
}
