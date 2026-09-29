import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';

/// Entity representing selected items for checkout
class SelectedCheckoutItems extends Equatable {
  final List<CartItem> items;
  final List<int> itemIds;
  final int subtotal;
  final int totalQuantity;
  final List<ExtraCharge> extraCharges;
  final String? deliveryType;

  const SelectedCheckoutItems({
    required this.items,
    required this.itemIds,
    required this.subtotal,
    required this.totalQuantity,
    this.extraCharges = const [],
    this.deliveryType,
  });

  /// Create empty selection
  factory SelectedCheckoutItems.empty() {
    return const SelectedCheckoutItems(
      items: [],
      itemIds: [],
      subtotal: 0,
      totalQuantity: 0,
      extraCharges: [],
      deliveryType: null,
    );
  }

  /// Check if selection is empty
  bool get isEmpty => items.isEmpty;

  /// Check if selection is not empty
  bool get isNotEmpty => items.isNotEmpty;

  @override
  List<Object?> get props => [
    items,
    itemIds,
    subtotal,
    totalQuantity,
    extraCharges,
    deliveryType,
  ];

  @override
  String toString() {
    return 'SelectedCheckoutItems(items: ${items.length}, subtotal: $subtotal, qty: $totalQuantity, charges: ${extraCharges.length})';
  }
}
