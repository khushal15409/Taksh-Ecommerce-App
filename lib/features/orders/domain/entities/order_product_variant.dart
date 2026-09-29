import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_product.dart';

/// Order product variant entity
class OrderProductVariant extends Equatable {
  final int id;
  final int productId;
  final String sku;
  final String price;
  final String salePrice;
  final String? weight;
  final String? length;
  final String? width;
  final String? height;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final OrderProduct? product;

  const OrderProductVariant({
    required this.id,
    required this.productId,
    required this.sku,
    required this.price,
    required this.salePrice,
    this.weight,
    this.length,
    this.width,
    this.height,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.product,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        sku,
        price,
        salePrice,
        weight,
        length,
        width,
        height,
        status,
        createdAt,
        updatedAt,
        product,
      ];

  @override
  String toString() {
    return 'OrderProductVariant(id: $id, sku: $sku, price: $price)';
  }
}
