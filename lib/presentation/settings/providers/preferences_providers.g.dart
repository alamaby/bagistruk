// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Active locale derived from [ProfileNotifier]. Defaults to English until the
/// profile row resolves.

@ProviderFor(localePref)
const localePrefProvider = LocalePrefProvider._();

/// Active locale derived from [ProfileNotifier]. Defaults to English until the
/// profile row resolves.

final class LocalePrefProvider
    extends $FunctionalProvider<Locale, Locale, Locale>
    with $Provider<Locale> {
  /// Active locale derived from [ProfileNotifier]. Defaults to English until the
  /// profile row resolves.
  const LocalePrefProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localePrefProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localePrefHash();

  @$internal
  @override
  $ProviderElement<Locale> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Locale create(Ref ref) {
    return localePref(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$localePrefHash() => r'39df0eed7d5146e1f8194b8297b77cf447b7c038';

@ProviderFor(themeModePref)
const themeModePrefProvider = ThemeModePrefProvider._();

final class ThemeModePrefProvider
    extends $FunctionalProvider<ThemeMode, ThemeMode, ThemeMode>
    with $Provider<ThemeMode> {
  const ThemeModePrefProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModePrefProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModePrefHash();

  @$internal
  @override
  $ProviderElement<ThemeMode> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeMode create(Ref ref) {
    return themeModePref(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModePrefHash() => r'3204d49d90e4364ba64a4c48e33d05da7942d1fb';

@ProviderFor(currencyPref)
const currencyPrefProvider = CurrencyPrefProvider._();

final class CurrencyPrefProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const CurrencyPrefProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencyPrefProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencyPrefHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return currencyPref(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currencyPrefHash() => r'2f454e3b3e93892c8d6ff8f168c9024cd1901694';
