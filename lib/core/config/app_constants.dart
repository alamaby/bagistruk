import 'package:flutter/widgets.dart';

class AppConstants {
  const AppConstants._();

  /// Design baseline: iPhone 12 logical resolution. ScreenUtil scales widgets
  /// from this baseline so the same code renders correctly on the S20 FE
  /// (412×915) and Infinix XPAD (tablet) without per-device branching.
  static const Size designSize = Size(390, 844);

  /// Edge Function name registered in Supabase.
  static const String ocrEdgeFunctionName = 'process-receipt';

  /// External links shown on the About screen. Keep placeholders as '#'
  /// until the final public URLs are ready.
  static const String websiteUrl = 'https://alamaby.gitlab.io/';
  static const String githubUrl = 'https://github.com/alamaby';
  static const String linkedinUrl = 'https://linkedin.com/in/alamaby';
  static const String buyMeACoffeeUrl = 'https://buymeacoffee.com/alamaby';
  static const String saweriaUrl = 'https://saweria.co/alamaby';
  static const String patreonUrl = 'https://patreon.com/alamaby';

  /// Long-edge target for OCR uploads. Anything larger only inflates token
  /// cost without improving extraction accuracy in our spike tests.
  static const int ocrMaxImageEdgePx = 1600;

  /// Default share weight when a participant claims one item alone.
  static const double defaultShareWeight = 1.0;

  /// Confidence di bawah ini → tampilkan chip peringatan ke user supaya
  /// double-check angka secara manual.
  static const double ocrLowConfidenceThreshold = 0.8;

  /// Selisih maksimum antara total hitungan client vs `detected_total` LLM
  /// sebelum menampilkan banner mismatch. 1.0 menyerap rounding kecil
  /// (LLM kadang bulatkan ke ratusan).
  static const double billTotalMismatchTolerance = 1.0;

  /// ISO 4217 currencies yang seharusnya integer (tidak punya subunit
  /// seperti cents). Dipakai sebagai client safety net: jika harga hasil
  /// OCR untuk currency ini punya pecahan, kemungkinan besar pemisah ribuan
  /// salah ditafsirkan sebagai desimal — tampilkan banner peringatan agar
  /// user verifikasi sebelum simpan.
  static const Set<String> zeroDecimalCurrencies = {
    'IDR',
    'JPY',
    'KRW',
    'VND',
    'CLP',
    'ISK',
    'HUF',
    'TWD',
  };
}
