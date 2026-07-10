import 'package:bagistruk/core/billing/google_play_billing_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GooglePlayBillingCatalog', () {
    test('productIds only expose the client-visible catalog', () {
      expect(
        GooglePlayBillingCatalog.productIds,
        equals({'bagistruk_plus_monthly', 'ocr_pack_50', 'ocr_pack_150', 'ocr_pack_500'}),
      );
    });

    test('purchasableProducts excludes the yearly subscription', () {
      final ids = GooglePlayBillingCatalog.purchasableProducts
          .map((p) => p.id)
          .toSet();
      expect(ids.contains('bagistruk_plus_yearly'), isFalse);
      expect(ids, equals(GooglePlayBillingCatalog.productIds));
    });

    test('products still includes yearly for legacy purchase lookup', () {
      final ids = GooglePlayBillingCatalog.products.map((p) => p.id).toSet();
      expect(ids.contains('bagistruk_plus_yearly'), isTrue);
    });

    test('credit packs expose ascending credit amounts', () {
      final credits = GooglePlayBillingCatalog.creditPacks
          .map((p) => p.credits)
          .toList();
      expect(credits, equals([50, 150, 500]));
    });

    test('apiTypeFor returns correct wire values', () {
      expect(
        GooglePlayBillingCatalog.apiTypeFor(
          GooglePlayBillingProductType.subscription,
        ),
        equals('subscription'),
      );
      expect(
        GooglePlayBillingCatalog.apiTypeFor(
          GooglePlayBillingProductType.inapp,
        ),
        equals('inapp'),
      );
    });

    test('byId resolves yearly even when not in purchasable list', () {
      final product = GooglePlayBillingCatalog.byId('bagistruk_plus_yearly');
      expect(product, isNotNull);
      expect(product?.type, GooglePlayBillingProductType.subscription);
    });
  });
}
