import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';
import 'package:taksh_e_commerce/features/checkout/data/models/checkout_summary_model.dart';
import 'package:taksh_e_commerce/features/checkout/data/models/delivery_option_model.dart';
import 'package:taksh_e_commerce/features/checkout/data/models/place_order_response_model.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_model.dart';

/// Remote data source contract for checkout operations
abstract class CheckoutRemoteDataSource {
  /// Calculate checkout summary
  Future<CheckoutSummaryModel> calculateCheckout({
    required List<int> cartItemIds,
    required String deliveryType,
    String? addressId,
    String? couponCode,
  });

  /// Get delivery options
  Future<List<DeliveryOptionModel>> getDeliveryOptions({
    required String addressId,
  });

  /// Validate checkout
  Future<bool> validateCheckout({required DataMap orderRequest});

  /// Create order (legacy method - still used for COD)
  Future<OrderModel> createOrder({required DataMap orderRequest});

  /// Place order (new flow - returns order_id)
  /// This is the first step in the new checkout flow
  Future<PlaceOrderResponseModel> placeOrder({
    required String addressId,
    required String warehouseId,
    required String deliveryType,
    required String paymentMethod,
    required String vendorId,
    required List<ExtraCharge> extraCharges,
  });
}
