import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';

/// Cart entity representing a shopping cart
class Cart extends Equatable {
  final List<CartItem> items;
  final int total;
  final String? guestToken;
  final List<ExtraCharge> extraCharges;
  final String? deliveryChargeCode;
  final int? deliveryEstimatedMinutes;
  final double? deliveryChargePrice;
  final int? totalWithDelivery;

  const Cart({
    required this.items,
    required this.total,
    this.guestToken,
    this.extraCharges = const [],
    this.deliveryChargeCode,
    this.deliveryEstimatedMinutes,
    this.deliveryChargePrice,
    this.totalWithDelivery,
  });

  /// Create an empty cart
  factory Cart.empty() {
    return const Cart(items: [], total: 0, extraCharges: []);
  }

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Get total number of items in cart
  int get totalItems => items.fold(0, (sum, item) => sum + item.qty);

  @override
  List<Object?> get props => [
    items,
    total,
    guestToken,
    extraCharges,
    deliveryChargeCode,
    deliveryEstimatedMinutes,
    deliveryChargePrice,
    totalWithDelivery,
  ];

  @override
  String toString() {
    return 'Cart(items: ${items.length}, total: $total, totalWithDelivery: $totalWithDelivery, guestToken: $guestToken, extraCharges: ${extraCharges.length})';
  }
}
