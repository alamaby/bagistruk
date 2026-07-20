import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/ocr_result.dart';

part 'ocr_response_dto.freezed.dart';
part 'ocr_response_dto.g.dart';

DateTime? _nullableDateTimeFromJson(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  return DateTime.tryParse(text);
}

/// Tolerant numeric read for untrusted LLM output. Accepts a number or a
/// numeric string; returns null for null / empty / unparseable. Note: locale
/// thousands-separator correction is the server's job (`normalizePayload`); this
/// only avoids a hard cast crash, so `"5.000"` parses to `5.0` here.
double? _readDoubleOrNull(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) {
    final t = value.trim();
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }
  return null;
}

/// Parses a single line item defensively. Returns null (→ item skipped) when
/// the element is not an object or is missing a usable name/price, so one bad
/// line never discards an otherwise-good receipt.
OcrLineItemDto? _lenientLineItem(Object? raw) {
  if (raw is! Map) return null;
  final name = raw['name']?.toString().trim();
  final price = _readDoubleOrNull(raw['price']);
  if (name == null || name.isEmpty || price == null) return null;
  return OcrLineItemDto(
    name: name,
    price: price,
    qty: _readDoubleOrNull(raw['qty']) ?? 1.0,
  );
}

@freezed
abstract class OcrLineItemDto with _$OcrLineItemDto {
  const OcrLineItemDto._();

  const factory OcrLineItemDto({
    required String name,
    required double price,
    @Default(1.0) double qty,
  }) = _OcrLineItemDto;

  factory OcrLineItemDto.fromJson(Map<String, dynamic> json) =>
      _$OcrLineItemDtoFromJson(json);

  OcrLineItem toEntity() => OcrLineItem(name: name, price: price, qty: qty);
}

@freezed
abstract class OcrResponseDto with _$OcrResponseDto {
  const OcrResponseDto._();

  const factory OcrResponseDto({
    required List<OcrLineItemDto> items,
    double? detectedTotal,
    double? detectedTax,
    double? detectedService,
    String? merchant,
    @JsonKey(fromJson: _nullableDateTimeFromJson) DateTime? receiptDate,
    @Default(0.0) double confidence,
    required String providerUsed,
  }) = _OcrResponseDto;

  factory OcrResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OcrResponseDtoFromJson(json);

  /// Crash-safe parser for the Edge Function response. The body originates from
  /// an LLM, so a strict cast (`json['price'] as num`) throws a `TypeError` on
  /// any imperfection — null price, a stringified number, a missing `items`
  /// key — and the generic exception funnel then discards the *entire* scan
  /// even when most items parsed. This variant reads every field tolerantly and
  /// skips only the malformed line items. Prefer it over [fromJson] at the
  /// transport boundary.
  factory OcrResponseDto.fromJsonLenient(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = <OcrLineItemDto>[];
    if (rawItems is List) {
      for (final e in rawItems) {
        final item = _lenientLineItem(e);
        if (item != null) items.add(item);
      }
    }
    return OcrResponseDto(
      items: items,
      detectedTotal: _readDoubleOrNull(json['detected_total']),
      detectedTax: _readDoubleOrNull(json['detected_tax']),
      detectedService: _readDoubleOrNull(json['detected_service']),
      merchant: json['merchant']?.toString(),
      receiptDate: _nullableDateTimeFromJson(json['receipt_date']),
      confidence: _readDoubleOrNull(json['confidence']) ?? 0.0,
      providerUsed: json['provider_used']?.toString() ?? 'unknown',
    );
  }

  OcrResult toEntity() => OcrResult(
    items: items.map((e) => e.toEntity()).toList(growable: false),
    detectedTotal: detectedTotal,
    detectedTax: detectedTax,
    detectedService: detectedService,
    merchant: merchant,
    receiptDate: receiptDate,
    confidence: confidence,
    providerUsed: providerUsed,
  );
}
