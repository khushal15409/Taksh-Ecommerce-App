import 'package:equatable/equatable.dart';

/// Entity representing an order creation request
class OrderRequest extends Equatable {
  final List<int> cartItemIds;
  final String addressId;
  final int warehouseId;
  final String deliveryType;
  final bool isExpress;
  final String paymentMethod;
  final int expectedTotal;

  const OrderRequest({
    required this.cartItemIds,
    required this.addressId,
    required this.warehouseId,
    required this.deliveryType,
    required this.isExpress,
    required this.paymentMethod,
    required this.expectedTotal,
  });

  @override
  List<Object?> get props => [
        cartItemIds,
        addressId,
        warehouseId,
        deliveryType,
        isExpress,
        paymentMethod,
        expectedTotal,
      ];

  @override
  String toString() {
    return 'OrderRequest(items: ${cartItemIds.length}, address: $addressId, warehouse: $warehouseId, delivery: $deliveryType, payment: $paymentMethod)';
  }
}
