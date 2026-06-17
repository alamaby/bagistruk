/// Helpers for the optional phone number stored on each [Participant].
///
/// The phone is stored verbatim (e.g. `0812 3456 7890`, `+62 812-3456-7890`,
/// or `6281234567890`). When we want a WhatsApp deep-link we have to collapse
/// it to a digits-only international form first — see [waMeLink].
class PhoneFormatter {
  const PhoneFormatter._();

  /// Strips everything that isn't a digit, then prepends the Indonesian
  /// country code (`62`) when the number starts with a leading `0` or `+62`.
  ///
  /// Returns `null` when the result has fewer than 6 digits — the
  /// `participants.phone` CHECK constraint requires at least 6, and a link
  /// with fewer digits will not resolve in WhatsApp anyway.
  static String? normalize(String? raw) {
    if (raw == null) return null;
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return null;
    if (digits.startsWith('0')) {
      return '62${digits.substring(1)}';
    }
    return digits;
  }

  /// Builds a `https://wa.me/<digits>` URL or returns `null` if the phone
  /// is missing / unparseable. WhatsApp requires digits only and a country
  /// code, which is what [normalize] produces.
  static String? waMeLink(String? raw) {
    final digits = normalize(raw);
    if (digits == null || digits.length < 6) return null;
    return 'https://wa.me/$digits';
  }
}
