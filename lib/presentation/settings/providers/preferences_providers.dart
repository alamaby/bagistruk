import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'profile_notifier.dart';

part 'preferences_providers.g.dart';

/// Active locale derived from [ProfileNotifier]. Defaults to English until the
/// profile row resolves.
@Riverpod(keepAlive: true)
Locale localePref(Ref ref) {
  final profile = ref.watch(profileProvider);
  final code = profile.value?.languagePref ?? 'en';
  return Locale(code);
}

@Riverpod(keepAlive: true)
ThemeMode themeModePref(Ref ref) {
  final profile = ref.watch(profileProvider);
  final pref = profile.value?.themePref ?? 'system';
  return switch (pref) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}

@Riverpod(keepAlive: true)
String currencyPref(Ref ref) {
  final profile = ref.watch(profileProvider);
  return profile.value?.defaultCurrency ?? 'IDR';
}
