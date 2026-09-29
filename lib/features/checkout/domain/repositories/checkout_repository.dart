import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/checkout_summary.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/delivery_option.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/order_request.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/place_order_response.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart';

/// Repository contract for checkout operations
abstract class CheckoutRepository {
  /// Calculate price breakdown for selected items
  ResultFuture<CheckoutSummary> calculateCheckout({
    required List<int> cartItemIds,
    required String deliveryType,
    String? addressId,
    String? couponCode,
  });

  /// Get available delivery options for location
  ResultFuture<List<DeliveryOption>> getDeliveryOptions({
    required String addressId,
  });

  /// Validate checkout before placing order
  ResultFuture<bool> validateCheckout({required OrderRequest orderRequest});

  /// Create order (legacy method - still used for COD)
  ResultFuture<Order> createOrder({required OrderRequest orderRequest});

  /// Place order (new flow - returns order_id)
  /// This is the first step in the new online payment checkout flow
  ResultFuture<PlaceOrderResponse> placeOrder({
    required String addressId,
    required String warehouseId,
    required String deliveryType,
    required String paymentMethod,
    required String vendorId,
    required List<ExtraCharge> extraCharges,
  });
}
