import '../../core/config/app_constants.dart';
import '../entities/ocr_result.dart';

class OcrScaleNormalizer {
  const OcrScaleNormalizer._();

  /// Safety-net heuristics for zero-decimal currencies (IDR, JPY, VND, etc.).
  ///
  /// When a receipt total recognised by the LLM is ≥ 1000 but individual line
  /// item prices appear suspiciously small (each < 1000), the thousands
  /// separator may have been interpreted as a decimal point. This method tries
  /// scaling item prices (and optionally tax/service) by ×1000 and picks the
  /// combination that brings the calculated grand total closest to the
  /// detected total, provided the improvement exceeds a tolerance threshold.
  static OcrResult normalizeZeroDecimalScale(OcrResult ocr, String currency) {
    if (!AppConstants.zeroDecimalCurrencies.contains(currency)) return ocr;
    final detectedTotal = ocr.detectedTotal;
    if (detectedTotal == null || detectedTotal < 1000) return ocr;

    double subtotal(List<OcrLineItem> items) =>
        items.fold<double>(0, (sum, it) => sum + it.price * it.qty);

    final tax = ocr.detectedTax ?? 0;
    final service = ocr.detectedService ?? 0;
    final currentDiff = (subtotal(ocr.items) + tax + service - detectedTotal)
        .abs();
    final tolerance = detectedTotal * 0.01 > 1 ? detectedTotal * 0.01 : 1.0;

    final itemPricesLookSmall =
        ocr.items.isNotEmpty &&
        ocr.items.every((it) => it.price > 0 && it.price.abs() < 1000);
    final taxLooksSmall = tax > 0 && tax.abs() < 1000;
    final serviceLooksSmall = service > 0 && service.abs() < 1000;

    _ScaleCandidate? best;
    for (final scaleItems in [false, true]) {
      if (scaleItems && !itemPricesLookSmall) continue;
      for (final scaleTax in [false, true]) {
        if (scaleTax && !taxLooksSmall) continue;
        for (final scaleService in [false, true]) {
          if (scaleService && !serviceLooksSmall) continue;
          if (!scaleItems && !scaleTax && !scaleService) continue;

          final candidateItems = scaleItems
              ? ocr.items
                    .map((it) => it.copyWith(price: it.price * 1000))
                    .toList(growable: false)
              : ocr.items;
          final candidateTax = ocr.detectedTax == null
              ? null
              : ocr.detectedTax! * (scaleTax ? 1000 : 1);
          final candidateService = ocr.detectedService == null
              ? null
              : ocr.detectedService! * (scaleService ? 1000 : 1);
          final grand =
              subtotal(candidateItems) +
              (candidateTax ?? 0) +
              (candidateService ?? 0);
          final diff = (grand - detectedTotal).abs();
          if (best == null || diff < best.diff) {
            best = _ScaleCandidate(
              items: candidateItems,
              detectedTax: candidateTax,
              detectedService: candidateService,
              diff: diff,
            );
          }
        }
      }
    }

    if (best == null || best.diff > tolerance || best.diff >= currentDiff) {
      return ocr;
    }

    return ocr.copyWith(
      items: best.items,
      detectedTax: best.detectedTax,
      detectedService: best.detectedService,
    );
  }
}

class _ScaleCandidate {
  const _ScaleCandidate({
    required this.items,
    required this.detectedTax,
    required this.detectedService,
    required this.diff,
  });

  final List<OcrLineItem> items;
  final double? detectedTax;
  final double? detectedService;
  final double diff;
}
