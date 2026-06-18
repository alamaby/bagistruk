// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_fingerprint_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deviceFingerprintService)
const deviceFingerprintServiceProvider = DeviceFingerprintServiceProvider._();

final class DeviceFingerprintServiceProvider
    extends
        $FunctionalProvider<
          DeviceFingerprintService,
          DeviceFingerprintService,
          DeviceFingerprintService
        >
    with $Provider<DeviceFingerprintService> {
  const DeviceFingerprintServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceFingerprintServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceFingerprintServiceHash();

  @$internal
  @override
  $ProviderElement<DeviceFingerprintService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceFingerprintService create(Ref ref) {
    return deviceFingerprintService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceFingerprintService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceFingerprintService>(value),
    );
  }
}

String _$deviceFingerprintServiceHash() =>
    r'6985b908264e9a4f5920a0de5b2d683945fb91af';
