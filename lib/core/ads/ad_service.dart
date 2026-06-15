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

    // In debug builds force the EEA geography so the UMP consent form is
    // actually shown during local testing — without this, developers in
    // non-regulated regions never see the form. No-op in release.
    if (kDebugMode) {
      await ConsentInformation.instance.setConsentDebugSettings(
        ConsentDebugSettings(
          debugGeography: DebugGeography.debugGeographyEea,
          testDeviceIds: const ['TEST-DEVICE-HASH'],
        ),
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
    await ConsentInformation.instance.setTagForUnderAgeOfConsent(isMinor);
  }

  /// Re-triggers the UMP consent form so the user can review or change
  /// their ad privacy choices from a Settings surface. No-op when ads are
  /// disabled or on unsupported platforms.
  static Future<void> showConsentFormIfAvailable() async {
    if (!AdConfig.adsEnabled) return;
    try {
      await ConsentForm.showPrivacyOptionsFormIfRequired((_) {});
    } catch (_) {
      // UMP may not have a form ready (e.g. user is in a non-regulated
      // region) — surface this gracefully so Settings callers do not
      // need a try/catch of their own.
    }
  }
}
