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

  static const products = [plusMonthly, plusYearly, ...creditPacks];

  static Set<String> get productIds =>
      products.map((product) => product.id).toSet();

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
