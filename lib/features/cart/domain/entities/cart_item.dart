import 'package:equatable/equatable.dart';

/// Cart item entity representing a product in the cart
class CartItem extends Equatable {
  final int id;
  final int productVariantId;
  final String productName;
  final String sku;
  final String price;
  final int qty;
  final int total;
  final String? image;

  /// The product ID (not variant ID) – used for delivery availability checks.
  /// May be null when not enriched from product details.
  final int? productId;

  /// Whether this item supports express 30-min delivery.
  /// Null means unknown (not yet enriched). False / true are explicit values.
  final bool? isExpress30;

  const CartItem({
    required this.id,
    required this.productVariantId,
    required this.productName,
    required this.sku,
    required this.price,
    required this.qty,
    required this.total,
    this.image,
    this.productId,
    this.isExpress30,
  });

  /// Return a copy with updated delivery metadata
  CartItem withDeliveryInfo(
      {required int productId, required bool isExpress30}) {
    return CartItem(
      id: id,
      productVariantId: productVariantId,
      productName: productName,
      sku: sku,
      price: price,
      qty: qty,
      total: total,
      image: image,
      productId: productId,
      isExpress30: isExpress30,
    );
  }

  /// Create an empty cart item
  factory CartItem.empty() {
    return const CartItem(
      id: 0,
      productVariantId: 0,
      productName: '',
      sku: '',
      price: '0',
      qty: 0,
      total: 0,
    );
  }

  /// Check if cart item is empty
  bool get isEmpty => id == 0;

  /// Check if cart item is not empty
  bool get isNotEmpty => id != 0;

  /// Get price as double
  double get priceAsDouble => double.tryParse(price) ?? 0.0;

  @override
  List<Object?> get props => [
        id,
        productVariantId,
        productName,
        sku,
        price,
        qty,
        total,
        image,
        productId,
        isExpress30,
      ];

  @override
  String toString() {
    return 'CartItem(id: $id, productName: $productName, qty: $qty, total: $total)';
  }
}
