import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_product_variant.dart';

/// Order item entity representing a product in an order
class OrderItem extends Equatable {
  final int id;
  final int orderId;
  final int productVariantId;
  final int qty;
  final String price;
  final String? productName;
  final String? brandName;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final OrderProductVariant? productVariant;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productVariantId,
    required this.qty,
    required this.price,
    this.productName,
    this.brandName,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    this.productVariant,
  });

  @override
  List<Object?> get props => [
        id,
        orderId,
        productVariantId,
        qty,
        price,
        productName,
        brandName,
        image,
        createdAt,
        updatedAt,
        productVariant,
      ];

  @override
  String toString() {
    return 'OrderItem(id: $id, name: $productName, qty: $qty, price: $price)';
  }
}
