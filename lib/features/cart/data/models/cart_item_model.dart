import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.productVariantId,
    required super.productName,
    required super.sku,
    required super.price,
    required super.qty,
    required super.total,
    super.image,
    // productId and isExpress30 are not returned by the cart API;
    // they are enriched separately during checkout delivery availability check.
    super.productId,
    super.isExpress30,
  });

  factory CartItemModel.fromJson(DataMap json) {
    final dynamic rawIsExpress30 =
        json['is_express30'] ?? json['is_express_30'];
    final String? deliveryType = json['delivery_type']?.toString();

    final bool? parsedExpress = _toBool(rawIsExpress30);
    final bool? inferredFromType = deliveryType == null
        ? null
        : (deliveryType == '30_min');

    return CartItemModel(
      id: _toInt(json['id']) ?? 0,
      productVariantId: _toInt(json['product_variant_id']) ?? 0,
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      price:
          json['price']?.toString() ?? json['final_sell_price']?.toString() ?? '0',
      qty: _toInt(json['qty']) ?? 0,
      total: _toInt(json['total']) ?? 0,
      image: json['image']?.toString(),
      productId: _toInt(json['product_id']),
      isExpress30: parsedExpress ?? inferredFromType,
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value.toString().trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
    return null;
  }

  DataMap toJson() => {
    'id': id,
    'product_variant_id': productVariantId,
    'product_name': productName,
    'sku': sku,
    'price': price,
    'qty': qty,
    'total': total,
    'image': image,
    if (productId != null) 'product_id': productId,
    if (isExpress30 != null) 'is_express30': isExpress30,
  };
}
