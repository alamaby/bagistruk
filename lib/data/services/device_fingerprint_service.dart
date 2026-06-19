import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/app_logger.dart';

part 'device_fingerprint_service.g.dart';

/// Header names sent to the `process-receipt` Edge Function so it can
/// compute a v2 anti-abuse fingerprint. Centralized as constants so the
/// Flutter client and the Edge Function stay in lockstep — if you rename
/// a header here, update `anonymousDeviceKeyHash` in
/// `supabase/functions/process-receipt/index.ts` accordingly.
class DeviceFingerprintHeaders {
  const DeviceFingerprintHeaders._();
  static const String androidVersion = 'x-android-version';
  static const String androidSdk = 'x-android-sdk';
  static const String androidBrand = 'x-android-brand';
  static const String androidModel = 'x-android-model';
  static const String androidHardware = 'x-android-hardware';
  static const String screenWidth = 'x-screen-width';
  static const String screenHeight = 'x-screen-height';
  static const String screenDpi = 'x-screen-dpi';
  static const String timezone = 'x-timezone';
}

/// Builds a privacy-preserving device fingerprint payload for the
/// anonymous anti-abuse gate in `process-receipt`.
///
/// All values are coarse, non-PII signals (Android release/SDK/brand/
/// model/hardware, screen size in logical pixels, device pixel ratio,
/// and the device's configured IANA-ish time zone name). They feed an
/// HMAC on the server — nothing here is persisted raw. The salt is
/// held server-side in `ANTI_BOT_FINGERPRINT_SALT`.
///
/// Android device info is fetched once per process and cached (it does
/// not change for a given install). Timezone, screen dimensions, and
/// DPI are read on every call so a user rotating the device, plugging
/// into an external display, or travelling across time zones still gets
/// a consistent snapshot of the *current* configuration.
class DeviceFingerprintService {
  Map<String, String>? _androidCache;

  /// Returns the fingerprint headers for the current device. [context]
  /// is needed for screen dimensions and DPI via MediaQuery; pass the
  /// caller's [BuildContext] (typically a screen or a [Builder]). Null
  /// is tolerated — in that case the screen signals are omitted but
  /// Android info and timezone still flow through.
  Future<Map<String, String>> collectHeaders({BuildContext? context}) async {
    final headers = <String, String>{};

    // Timezone: stable per device configuration, cheap, read fresh so
    // a user moving between zones or hitting DST still gets a current
    // value rather than a stale one from app launch.
    headers[DeviceFingerprintHeaders.timezone] = DateTime.now().timeZoneName;

    if (context != null) {
      // MediaQuery.size gives logical pixels (post-DPR), which is what
      // most fingerprinting heuristics use because it is stable across
      // physical resolution changes (e.g. foldable inner display).
      final mediaQuery = MediaQuery.of(context);
      headers[DeviceFingerprintHeaders.screenWidth] = mediaQuery.size.width
          .toStringAsFixed(0);
      headers[DeviceFingerprintHeaders.screenHeight] = mediaQuery.size.height
          .toStringAsFixed(0);
      headers[DeviceFingerprintHeaders.screenDpi] = mediaQuery.devicePixelRatio
          .toStringAsFixed(2);
    }

    final androidHeaders = _androidCache ??= await _readAndroidHeaders();
    headers.addAll(androidHeaders);

    return headers;
  }

  Future<Map<String, String>> _readAndroidHeaders() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      // iOS / desktop / web — leave the Android headers empty so the
      // Edge Function still gets a v2 hash with the v1 signals only.
      return const {};
    }
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      return {
        DeviceFingerprintHeaders.androidVersion: info.version.release,
        DeviceFingerprintHeaders.androidSdk: info.version.sdkInt.toString(),
        DeviceFingerprintHeaders.androidBrand: info.brand,
        DeviceFingerprintHeaders.androidModel: info.model,
        DeviceFingerprintHeaders.androidHardware: info.hardware,
      };
    } catch (error, stack) {
      // Reading device info is best-effort. The Edge Function still has
      // IP + UA + accept-language as a v1 fallback, so a failed read
      // here does not break OCR — it just weakens the fingerprint for
      // this one request.
      AppLogger.warn(
        'DeviceFingerprintService: failed to read Android info',
        error,
        stack,
      );
      return const {};
    }
  }
}

@Riverpod(keepAlive: true)
DeviceFingerprintService deviceFingerprintService(Ref ref) =>
    DeviceFingerprintService();
