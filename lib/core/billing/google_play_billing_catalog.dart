enum GooglePlayBillingProductType { subscription, inapp }

class GooglePlayBillingProduct {
  const GooglePlayBillingProduct({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.credits,
  });

  final String id;
  final GooglePlayBillingProductType type;
  final String title;
  final String description;
  final int? credits;
}

class GooglePlayBillingCatalog {
  const GooglePlayBillingCatalog._();

  static const plusMonthly = GooglePlayBillingProduct(
    id: 'bagistruk_plus_monthly',
    type: GooglePlayBillingProductType.subscription,
    title: 'BagiStruk Plus',
    description: '60 credit/bulan, tanpa iklan, dan fitur Plus.',
  );

  static const plusYearly = GooglePlayBillingProduct(
    id: 'bagistruk_plus_yearly',
    type: GooglePlayBillingProductType.subscription,
    title: 'BagiStruk Plus Tahunan',
    description: 'Benefit Plus dengan pembayaran tahunan.',
  );

  static const creditPacks = [
    GooglePlayBillingProduct(
      id: 'ocr_pack_50',
      type: GooglePlayBillingProductType.inapp,
      title: '50 credit OCR',
      description: 'Top-up 50 credit scan OCR.',
      credits: 50,
    ),
    GooglePlayBillingProduct(
      id: 'ocr_pack_150',
      type: GooglePlayBillingProductType.inapp,
      title: '150 credit OCR',
      description: 'Top-up 150 credit scan OCR.',
      credits: 150,
    ),
    GooglePlayBillingProduct(
      id: 'ocr_pack_500',
      type: GooglePlayBillingProductType.inapp,
      title: '500 credit OCR',
      description: 'Top-up 500 credit scan OCR.',
      credits: 500,
    ),
  ];

  /// All known products, including those hidden from the client UI.
  /// `verifyAndFinish()` may still receive a `ProductDetails.id` for a
  /// legacy purchase (for example `bagistruk_plus_yearly` bought by an
  /// older app build) and must be able to look the product up to drive
  /// the correct API type when calling the verifier.
  static const products = [plusMonthly, plusYearly, ...creditPacks];

  /// Products the client is allowed to query from Google Play and to
  /// render in the Billing UI. Yearly subscription is intentionally
  /// hidden until the operator is ready to launch it; hiding it from the
  /// client catalog also prevents a misleading "some products not
  /// active" banner when the Play Console product is not yet created.
  static const purchasableProducts = [plusMonthly, ...creditPacks];

  /// Product IDs that the Billing UI will request from Google Play and
  /// that `buy()` is allowed to start. Keep this strictly equal to
  /// `purchasableProducts.map((p) => p.id)` to avoid drift.
  static const Set<String> productIds = {
    'bagistruk_plus_monthly',
    'ocr_pack_50',
    'ocr_pack_150',
    'ocr_pack_500',
  };

  static GooglePlayBillingProduct? byId(String id) {
    for (final product in products) {
      if (product.id == id) return product;
    }
    return null;
  }

  static String apiTypeFor(GooglePlayBillingProductType type) => switch (type) {
    GooglePlayBillingProductType.subscription => 'subscription',
    GooglePlayBillingProductType.inapp => 'inapp',
  };
}
