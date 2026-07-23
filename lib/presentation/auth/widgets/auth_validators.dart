import '../../../l10n/generated/app_l10n.dart';

final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

String? validateEmail(String? value, AppL10n l10n) {
  final v = value?.trim() ?? '';
  if (v.isEmpty) return l10n.authEmailRequired;
  if (!_emailRegex.hasMatch(v)) return l10n.authInvalidEmailFormat;
  return null;
}

String? validatePassword(String? value, AppL10n l10n) {
  final v = value ?? '';
  if (v.isEmpty) return l10n.authPasswordRequired;
  if (v.length < 6) return l10n.authPasswordMinLength;
  return null;
}
