import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/delivery_option.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/price_breakdown.dart';

/// Entity representing a complete checkout summary
class CheckoutSummary extends Equatable {
  final List<CartItem> items;
  final PriceBreakdown priceBreakdown;
  final DeliveryOption deliveryOption;
  final Address? selectedAddress;

  const CheckoutSummary({
    required this.items,
    required this.priceBreakdown,
    required this.deliveryOption,
    this.selectedAddress,
  });

  /// Check if address is selected
  bool get hasAddress => selectedAddress != null;

  /// Check if checkout is ready to place order
  bool get isReadyToPlaceOrder => items.isNotEmpty && hasAddress;

  /// Get total items count
  int get totalItems => items.fold(0, (sum, item) => sum + item.qty);

  @override
  List<Object?> get props => [
        items,
        priceBreakdown,
        deliveryOption,
        selectedAddress,
      ];

  @override
  String toString() {
    return 'CheckoutSummary(items: ${items.length}, total: ${priceBreakdown.grandTotal}, hasAddress: $hasAddress)';
  }
}
