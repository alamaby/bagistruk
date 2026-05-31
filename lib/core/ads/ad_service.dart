import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';

class AdService {
  const AdService._();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized || !AdConfig.adsEnabled) return;
    _initialized = true;

    await _requestConsent();
    await MobileAds.instance.initialize();
  }

  static Future<void> _requestConsent() async {
    final params = ConsentRequestParameters();
    final completer = Completer<void>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        try {
          await _loadAndShowConsentFormIfRequired();
        } finally {
          if (!completer.isCompleted) completer.complete();
        }
      },
      (_) {
        if (!completer.isCompleted) completer.complete();
      },
    );

    await completer.future;
  }

  static Future<void> _loadAndShowConsentFormIfRequired() async {
    await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
  }
}
