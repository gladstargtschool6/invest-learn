import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';

enum EntitlementState { free, premiumActive, premiumPending, premiumCancelled, premiumExpired }

class PremiumConfig {
  static const monthlyId = 'ai_coaching_premium_monthly';
  static const annualId = 'ai_coaching_premium_annual';
  static const verifyEndpoint = String.fromEnvironment('PREMIUM_VERIFY_ENDPOINT', defaultValue: '');
  static const accountToken = String.fromEnvironment('ACCOUNT_TOKEN', defaultValue: '');
}

class PremiumService extends ChangeNotifier {
  final InAppPurchase billing;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  ProductDetails? monthly;
  ProductDetails? annual;
  EntitlementState state = EntitlementState.free;
  String? message;
  bool loading = false;

  PremiumService({InAppPurchase? billing}) : billing = billing ?? InAppPurchase.instance {
    _subscription = this.billing.purchaseStream.listen(_onPurchases, onError: (_) {
      state = EntitlementState.free;
      message = 'Google Play is temporarily unavailable. Please try again.';
      notifyListeners();
    });
    loadProducts();
  }

  Future<void> loadProducts() async {
    loading = true; notifyListeners();
    final available = await billing.isAvailable();
    if (!available) { message = 'Google Play Billing is unavailable on this device.'; loading = false; notifyListeners(); return; }
    final response = await billing.queryProductDetails({PremiumConfig.monthlyId, PremiumConfig.annualId});
    monthly = response.productDetails.where((p) => p.id == PremiumConfig.monthlyId).cast<ProductDetails?>().firstOrNull;
    annual = response.productDetails.where((p) => p.id == PremiumConfig.annualId).cast<ProductDetails?>().firstOrNull;
    if (response.notFoundIDs.isNotEmpty) message = 'Premium plans are not configured in Google Play yet.';
    loading = false; notifyListeners();
  }

  Future<void> buy(ProductDetails product) async {
    message = null; loading = true; notifyListeners();
    final param = GooglePlayPurchaseParam(productDetails: product);
    await billing.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restore() => billing.restorePurchases();

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) { state = EntitlementState.premiumPending; message = 'Your payment is pending Google Play confirmation.'; notifyListeners(); continue; }
      if (purchase.status == PurchaseStatus.error) { state = EntitlementState.free; message = purchase.error?.message ?? 'The purchase could not be completed.'; notifyListeners(); continue; }
      if (purchase.status == PurchaseStatus.canceled) { state = EntitlementState.free; message = 'Purchase cancelled.'; notifyListeners(); continue; }
      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        final verified = await _verifyWithBackend(purchase);
        state = verified ? EntitlementState.premiumActive : EntitlementState.premiumPending;
        message = verified ? 'Premium AI Coaching is now active.' : 'Payment received. Premium will unlock after account verification.';
        notifyListeners();
      }
      if (purchase.pendingCompletePurchase) await billing.completePurchase(purchase);
    }
  }

  Future<bool> _verifyWithBackend(PurchaseDetails purchase) async {
    // Never unlock Premium from the client receipt alone. The backend must call
    // Google Play Developer API and persist entitlement against the user account.
    if (PremiumConfig.verifyEndpoint.isEmpty || PremiumConfig.accountToken.isEmpty) return false;
    final response = await http.post(Uri.parse(PremiumConfig.verifyEndpoint), headers: {'content-type': 'application/json', 'authorization': 'Bearer ${PremiumConfig.accountToken}'}, body: jsonEncode({'productId': purchase.productID, 'purchaseToken': purchase.verificationData.serverVerificationData}));
    return response.statusCode == 200 && (jsonDecode(response.body)['entitlement'] == 'PREMIUM_ACTIVE');
  }

  @override void dispose() { _subscription?.cancel(); super.dispose(); }
}

extension _FirstOrNull<T> on Iterable<T> { T? get firstOrNull => isEmpty ? null : first; }
