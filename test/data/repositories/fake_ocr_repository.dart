import 'dart:typed_data';

import 'package:bagistruk/core/error/result.dart';
import 'package:bagistruk/domain/entities/ocr_result.dart';
import 'package:bagistruk/domain/repositories/i_ocr_repository.dart';

class FakeOCRRepository implements IOCRRepository {
  FakeOCRRepository(this._result);

  final Result<OcrResult> _result;
  List<Uint8List>? capturedImages;
  String? capturedHint;
  String? capturedCurrency;
  Map<String, String>? capturedFingerprint;

  @override
  Future<Result<OcrResult>> processReceipt(
    List<Uint8List> imagesBytes, {
    String? hint,
    String? currency,
    Map<String, String>? fingerprintHeaders,
  }) async {
    capturedImages = imagesBytes;
    capturedHint = hint;
    capturedCurrency = currency;
    capturedFingerprint = fingerprintHeaders;
    return _result;
  }
}
