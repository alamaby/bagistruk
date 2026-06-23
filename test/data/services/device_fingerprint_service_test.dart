import 'package:bagistruk/data/services/device_fingerprint_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('DeviceFingerprintHeaders constants', () {
    test('wire format stable for Edge Function lockstep', () {
      expect(DeviceFingerprintHeaders.androidVersion, 'x-android-version');
      expect(DeviceFingerprintHeaders.androidSdk, 'x-android-sdk');
      expect(DeviceFingerprintHeaders.androidBrand, 'x-android-brand');
      expect(DeviceFingerprintHeaders.androidModel, 'x-android-model');
      expect(DeviceFingerprintHeaders.androidHardware, 'x-android-hardware');
      expect(DeviceFingerprintHeaders.screenWidth, 'x-screen-width');
      expect(DeviceFingerprintHeaders.screenHeight, 'x-screen-height');
      expect(DeviceFingerprintHeaders.screenDpi, 'x-screen-dpi');
      expect(DeviceFingerprintHeaders.timezone, 'x-timezone');
    });
  });

  group('DeviceFingerprintService.collectHeaders (non-Android)', () {
    late DeviceFingerprintService service;

    setUp(() {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      service = DeviceFingerprintService();
    });

    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });

    test('returns map with timezone key', () async {
      final headers = await service.collectHeaders();
      expect(headers, contains(DeviceFingerprintHeaders.timezone));
    });

    test('timezone value is non-empty', () async {
      final headers = await service.collectHeaders();
      expect(
        headers[DeviceFingerprintHeaders.timezone],
        isNotEmpty,
      );
    });

    test('no Android headers on iOS', () async {
      final headers = await service.collectHeaders();
      expect(headers, isNot(contains(DeviceFingerprintHeaders.androidVersion)));
      expect(headers, isNot(contains(DeviceFingerprintHeaders.androidSdk)));
      expect(headers, isNot(contains(DeviceFingerprintHeaders.androidBrand)));
    });

    test('no screen headers when context is null', () async {
      final headers = await service.collectHeaders();
      expect(headers, isNot(contains(DeviceFingerprintHeaders.screenWidth)));
      expect(headers, isNot(contains(DeviceFingerprintHeaders.screenHeight)));
      expect(headers, isNot(contains(DeviceFingerprintHeaders.screenDpi)));
    });

    test('all values are non-empty strings', () async {
      final headers = await service.collectHeaders();
      for (final entry in headers.entries) {
        expect(entry.value, isNotEmpty, reason: 'header ${entry.key}');
      }
    });
  });
}
