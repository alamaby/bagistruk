import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/billing/google_play_billing_catalog.dart';
import '../../core/error/exception_mapper.dart';
import '../../core/error/result.dart';
import '../../core/network/supabase_client_provider.dart';

class GooglePlayBillingService {
  GooglePlayBillingService(this._client, {InAppPurchase? inAppPurchase})
    : _iap = inAppPurchase ?? InAppPurchase.instance;

  final SupabaseClient _client;
  final InAppPurchase _iap;

  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  Future<bool> isAvailable() => _iap.isAvailable();

  Future<ProductDetailsResponse> loadProducts() =>
      _iap.queryProductDetails(GooglePlayBillingCatalog.productIds);

  Future<void> buy(ProductDetails details) async {
    final catalogProduct = GooglePlayBillingCatalog.byId(details.id);
    if (catalogProduct == null) {
      throw ArgumentError.value(details.id, 'details.id', 'Unknown product');
    }
    final purchaseParam = PurchaseParam(productDetails: details);
    switch (catalogProduct.type) {
      case GooglePlayBillingProductType.subscription:
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      case GooglePlayBillingProductType.inapp:
        await _iap.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: false,
        );
    }
  }

  Future<void> restorePurchases() => _iap.restorePurchases();

  Future<Result<void>> verifyAndFinish(PurchaseDetails purchase) {
    return guardAsync(() async {
      final catalogProduct = GooglePlayBillingCatalog.byId(purchase.productID);
      if (catalogProduct == null) return;
      if (purchase.status != PurchaseStatus.purchased &&
          purchase.status != PurchaseStatus.restored) {
        return;
      }

      final response = await _client.functions.invoke(
        'verify-google-play-purchase',
        body: {
          'productId': purchase.productID,
          'productType': GooglePlayBillingCatalog.apiTypeFor(
            catalogProduct.type,
          ),
          'purchaseToken': purchase.verificationData.serverVerificationData,
        },
      );
      if (response.status >= 400) {
        throw FunctionException(
          status: response.status,
          details: response.data,
        );
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    });
  }
}

final googlePlayBillingServiceProvider = Provider<GooglePlayBillingService>(
  (ref) => GooglePlayBillingService(ref.watch(supabaseClientProvider)),
);
