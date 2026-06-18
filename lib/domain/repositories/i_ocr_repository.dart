import 'dart:typed_data';

import '../../core/error/result.dart';
import '../entities/ocr_result.dart';

abstract interface class IOCRRepository {
  /// [imagesBytes] are raw bytes of one or more receipt photos. The repository
  /// is responsible for downscaling/encoding before invoking the Edge Function.
  ///
  /// [currency] (ISO 4217) memberi tahu server konvensi locale yang dipakai
  /// LLM saat membaca angka pada struk. Null → server default (IDR).
  ///
  Future<Result<OcrResult>> processReceipt(
    List<Uint8List> imagesBytes, {
    String? hint,
    String? currency,
    Map<String, String>? fingerprintHeaders,
  });
}
