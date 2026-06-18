import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';

class AdService {
  const AdService._();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized || !AdConfig.adsEnabled) return;
    _initialized = true;

    // In debug builds, register the test device so the AdMob SDK serves
    // test creatives. Note: in google_mobile_ads v8 there is no public
    // API to force the EEA geography — the consent form will only show
    // on devices whose actual region is regulated. No-op in release.
    if (kDebugMode) {
      await MobileAds.instance.updateRequestConfiguration(
        // Empty list lets AdMob auto-detect debug devices via the
        // `adb shell setprop debug.firebase.analytics.app` flag or by
        // the device's build flavor. Supplying a placeholder string
        // like `'TEST-DEVICE-HASH'` makes the SDK try to look it up,
        // fail, and log spurious warnings at every ad request.
        RequestConfiguration(testDeviceIds: const <String>[]),
      );
    }

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

  /// Updates the UMP underage tag. Call this whenever `profile.isAdult`
  /// changes (e.g. after the user finishes the legal acceptance flow and
  /// checks the "I am 18+" box). When the user is a minor, UMP skips
  /// personalized ad requests and the AdMob SDK only serves contextual
  /// (non-personalized) ads.
  static Future<void> setUserIsMinor(bool isMinor) async {
    if (!AdConfig.adsEnabled) return;
    // google_mobile_ads v8 exposes the UMP TFUA enum via the
    // `TagForUnderAgeOfConsent` constants (1 = under age, 0 = not).
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        tagForUnderAgeOfConsent:
            isMinor ? TagForUnderAgeOfConsent.yes : TagForUnderAgeOfConsent.no,
      ),
    );
  }

  /// Re-triggers the UMP consent form so the user can review or change
  /// their ad privacy choices from a Settings surface. No-op when ads are
  /// disabled or on unsupported platforms.
  static Future<void> showConsentFormIfAvailable() async {
    if (!AdConfig.adsEnabled) return;
    try {
      // v8 exposes the privacy options form via the static
      // `showPrivacyOptionsForm` (no separate `load` step required).
      await ConsentForm.showPrivacyOptionsForm((_) {});
    } catch (_) {
      // UMP may not have a form ready (e.g. user is in a non-regulated
      // region) — surface this gracefully so Settings callers do not
      // need a try/catch of their own.
    }
  }
}
