import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product_variant.dart';

/// Lightweight variant info for product cards in the home/dashboard context.
/// Contains only the data needed to display variant options and add to cart.
class ProductVariantInfo extends Equatable {
  final int id;
  final int productId;
  final String sku;
  final double price;
  final double salePrice;
  final String? label;
  final String status;
  final bool inStock;
  final int? availableStock;
  final String? outOfStockMessage;
  final bool hasStockInfo;

  const ProductVariantInfo({
    required this.id,
    required this.productId,
    required this.sku,
    required this.price,
    required this.salePrice,
    this.label,
    required this.status,
    this.inStock = true,
    this.availableStock,
    this.outOfStockMessage,
    this.hasStockInfo = false,
  });

  /// Whether this variant is active and available
  bool get isActive => status == 'active';

  bool get isAvailableForSale =>
      isActive && inStock && (availableStock == null || availableStock! > 0);

  /// Calculate discount percentage
  int? get discountPercentage {
    if (price <= 0 || salePrice >= price) return null;
    final value = ((price - salePrice) / price * 100).round();
    return value > 0 ? value : null;
  }

  factory ProductVariantInfo.fromJson(DataMap json) {
    final priceRaw = json['price'];
    final salePriceRaw = json['sale_price'];

    double parsePrice(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    final price = parsePrice(priceRaw);
    final salePrice = parsePrice(salePriceRaw);

    bool? parseNullableBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is num) return value != 0;

      switch (value.toString().trim().toLowerCase()) {
        case '1':
        case 'true':
        case 'yes':
          return true;
        case '0':
        case 'false':
        case 'no':
          return false;
        default:
          return null;
      }
    }

    final explicitInStock = parseNullableBool(json['in_stock']);
    final stockQuantity =
        json['stock_quantity'] ??
        json['stock_qty'] ??
        json['available_stock'] ??
        json['quantity'];
    final stockStatus = json['stock_status']?.toString().trim().toLowerCase();
    final outOfStockMessage = json['out_of_stock_message'] as String?;
    final availableStock = stockQuantity is num
        ? stockQuantity.toInt()
        : int.tryParse(stockQuantity?.toString() ?? '');
    final hasStockInfo =
        explicitInStock != null ||
        stockQuantity != null ||
        stockStatus != null ||
        outOfStockMessage != null;

    bool inStock = explicitInStock ?? true;
    if (explicitInStock == null && stockQuantity is num) {
      inStock = stockQuantity > 0;
    } else if (explicitInStock == null && stockQuantity is String) {
      inStock = (double.tryParse(stockQuantity) ?? 0) > 0;
    } else if (explicitInStock == null && stockStatus != null) {
      if (const {
        'out_of_stock',
        'sold_out',
        'unavailable',
      }.contains(stockStatus)) {
        inStock = false;
      } else if (const {'in_stock', 'available'}.contains(stockStatus)) {
        inStock = true;
      }
    }

    // Try to build a human-readable label from variant_attributes
    String? label;
    final variantAttributes = json['variant_attributes'];
    if (variantAttributes is List && variantAttributes.isNotEmpty) {
      final labels = <String>[];
      for (final attr in variantAttributes) {
        if (attr is Map) {
          final attrValue = attr['attribute_value'];
          if (attrValue is Map && attrValue['value'] != null) {
            labels.add(attrValue['value'].toString());
          }
        }
      }
      if (labels.isNotEmpty) {
        label = labels.join(' / ');
      }
    }

    // Fallback label from SKU if no variant attributes
    label ??= json['sku'] as String?;

    return ProductVariantInfo(
      id: (json['id'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      sku: json['sku'] as String? ?? '',
      price: price,
      salePrice: salePrice > 0 ? salePrice : price,
      label: label,
      status: json['status'] as String? ?? 'active',
      inStock: inStock,
      availableStock: availableStock,
      outOfStockMessage: outOfStockMessage,
      hasStockInfo: hasStockInfo,
    );
  }

  DataMap toJson() => {
    'id': id,
    'product_id': productId,
    'sku': sku,
    'price': price,
    'sale_price': salePrice,
    'label': label,
    'status': status,
    'in_stock': inStock,
    'available_stock': availableStock,
    'out_of_stock_message': outOfStockMessage,
    'has_stock_info': hasStockInfo,
  };

  @override
  List<Object?> get props => [
    id,
    productId,
    sku,
    price,
    salePrice,
    label,
    status,
    inStock,
    availableStock,
    outOfStockMessage,
    hasStockInfo,
  ];

  /// Create from a full [ProductVariant] entity (used in category pages
  /// where the product feature's domain model is available).
  factory ProductVariantInfo.fromProductVariant(ProductVariant variant) {
    double parsePrice(String value) => double.tryParse(value) ?? 0.0;

    final price = parsePrice(variant.price);
    final salePrice = variant.salePrice != null
        ? parsePrice(variant.salePrice!)
        : price;

    // Build label from variant attributes
    String? label;
    final attrs = variant.variantAttributes;
    if (attrs != null && attrs.isNotEmpty) {
      final labels = attrs
          .where((a) => a.attributeValue != null)
          .map((a) => a.attributeValue!.value)
          .toList();
      if (labels.isNotEmpty) {
        label = labels.join(' / ');
      }
    }
    label ??= variant.sku;

    return ProductVariantInfo(
      id: variant.id,
      productId: variant.productId,
      sku: variant.sku,
      price: price,
      salePrice: salePrice,
      label: label,
      status: variant.status,
      inStock: variant.inStock,
      availableStock: variant.availableStock,
      outOfStockMessage: variant.outOfStockMessage,
      hasStockInfo: variant.hasStockInfo,
    );
  }

  /// Convert a list of [ProductVariant] to a list of [ProductVariantInfo].
  static List<ProductVariantInfo>? fromProductVariants(
    List<ProductVariant>? variants,
  ) {
    if (variants == null || variants.isEmpty) return null;
    return variants.map(ProductVariantInfo.fromProductVariant).toList();
  }
}
