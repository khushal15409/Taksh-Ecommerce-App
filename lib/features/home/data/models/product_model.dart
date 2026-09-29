import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/core/utils/json_converters.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/product_entity.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/product_variant_info.dart';

part 'product_model.g.dart';

String? _normalizedImageString(dynamic value) {
  if (value is! String) return null;

  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') {
    return null;
  }

  return trimmed;
}

String? _normalizedString(dynamic value) {
  if (value == null) return null;

  final trimmed = value.toString().trim();
  if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') {
    return null;
  }

  return trimmed;
}

int? _normalizedInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();

  final normalized = _normalizedString(value);
  if (normalized == null) return null;

  return num.tryParse(normalized)?.toInt();
}

bool _normalizedBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;

  switch (_normalizedString(value)?.toLowerCase()) {
    case '1':
    case 'true':
    case 'yes':
      return true;
    case '0':
    case 'false':
    case 'no':
      return false;
    default:
      return fallback;
  }
}

DataMap? _asDataMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  return null;
}

DataMap _mergeNestedProductJson(DataMap json) {
  final nestedProduct = _asDataMap(json['product']);
  if (nestedProduct == null) {
    return json;
  }

  final merged = Map<String, dynamic>.from(nestedProduct);
  for (final entry in json.entries) {
    if (entry.key == 'product' || entry.value == null) continue;
    merged[entry.key] = entry.value;
  }

  return merged;
}

List<DataMap> _extractVariantMaps(DataMap json) {
  for (final key in const [
    'variants',
    'product_variants',
    'available_variants',
  ]) {
    final rawVariants = json[key];
    if (rawVariants is! List || rawVariants.isEmpty) continue;

    final variants = rawVariants
        .map(_asDataMap)
        .whereType<DataMap>()
        .toList(growable: false);
    if (variants.isNotEmpty) {
      return variants;
    }
  }

  for (final key in const ['product_variant', 'variant']) {
    final variant = _asDataMap(json[key]);
    if (variant != null) {
      return [variant];
    }
  }

  return const [];
}

DataMap _normalizeVariantJson(
  DataMap variantJson, {
  required DataMap productJson,
  required int productId,
}) {
  final normalized = Map<String, dynamic>.from(variantJson);

  normalized['id'] =
      _normalizedInt(normalized['id']) ??
      _normalizedInt(normalized['variant_id']) ??
      _normalizedInt(productJson['product_variant_id']) ??
      _normalizedInt(productJson['variant_id']);
  normalized['product_id'] =
      _normalizedInt(normalized['product_id']) ?? productId;
  normalized['sku'] =
      _normalizedString(normalized['sku']) ??
      _normalizedString(productJson['sku']) ??
      '';
  normalized['price'] =
      normalized['price'] ??
      normalized['original_price'] ??
      productJson['original_price'] ??
      productJson['price'];
  normalized['sale_price'] =
      normalized['sale_price'] ?? normalized['price'] ?? productJson['price'];
  normalized['status'] = _normalizedString(normalized['status']) ?? 'active';
  normalized['in_stock'] = normalized['in_stock'] ?? productJson['in_stock'];
  normalized['available_stock'] =
      normalized['available_stock'] ??
      normalized['stock_quantity'] ??
      normalized['stock_qty'] ??
      normalized['quantity'];
  normalized['has_stock_info'] =
      normalized['has_stock_info'] ??
      (normalized.containsKey('available_stock') ||
          normalized.containsKey('stock_quantity') ||
          normalized.containsKey('stock_qty') ||
          normalized.containsKey('quantity') ||
          normalized.containsKey('stock_status') ||
          normalized.containsKey('in_stock'));
  normalized['out_of_stock_message'] =
      _normalizedString(normalized['out_of_stock_message']) ??
      _normalizedString(productJson['out_of_stock_message']);

  return normalized;
}

String? _imageUrlFromMap(Map<dynamic, dynamic> imageData) {
  return _normalizedImageString(
    imageData['image_url'] ??
        imageData['url'] ??
        imageData['image'] ??
        imageData['thumbnail'] ??
        imageData['featured_image'] ??
        imageData['main_image'],
  );
}

String? _resolveImageFromCollection(dynamic rawImages) {
  if (rawImages is! List || rawImages.isEmpty) {
    return _normalizedImageString(rawImages);
  }

  for (final imageData in rawImages) {
    if (imageData is Map<dynamic, dynamic> && imageData['is_primary'] == true) {
      final primaryUrl = _imageUrlFromMap(imageData);
      if (primaryUrl != null) {
        return primaryUrl;
      }
    }
  }

  for (final imageData in rawImages) {
    if (imageData is Map<dynamic, dynamic>) {
      final imageUrl = _imageUrlFromMap(imageData);
      if (imageUrl != null) {
        return imageUrl;
      }
      continue;
    }

    final directImageUrl = _normalizedImageString(imageData);
    if (directImageUrl != null) {
      return directImageUrl;
    }
  }

  return null;
}

String? _resolveVariantImage(dynamic rawVariants) {
  if (rawVariants is! List || rawVariants.isEmpty) {
    return null;
  }

  for (final variantData in rawVariants) {
    if (variantData is! Map<dynamic, dynamic>) continue;

    final variantImages = _resolveImageFromCollection(variantData['images']);
    if (variantImages != null) {
      return variantImages;
    }

    final directVariantImage = _imageUrlFromMap(variantData);
    if (directVariantImage != null) {
      return directVariantImage;
    }
  }

  return null;
}

String? _resolveProductImageUrl(DataMap json) {
  final directImageUrl = _normalizedImageString(
    json['image_url'] ??
        json['image'] ??
        json['thumbnail'] ??
        json['featured_image'] ??
        json['main_image'] ??
        json['primary_image_url'],
  );
  if (directImageUrl != null) {
    return directImageUrl;
  }

  final imagesImageUrl = _resolveImageFromCollection(json['images']);
  if (imagesImageUrl != null) {
    return imagesImageUrl;
  }

  final variantImageUrl = _resolveVariantImage(json['variants']);
  if (variantImageUrl != null) {
    return variantImageUrl;
  }

  final categoryData = json['category'];
  if (categoryData is Map<dynamic, dynamic>) {
    return _resolveImageFromCollection(categoryData['images']) ??
        _normalizedImageString(
          categoryData['image_url'] ?? categoryData['icon_url'],
        );
  }

  return null;
}

/// Model for Product data from API (Express Dashboard sections)
/// API returns: price (sale price), original_price, discount (number)
@JsonSerializable(fieldRename: FieldRename.snake)
class ProductModel extends ProductEntity {
  @JsonKey(name: 'original_price')
  @PriceConverter()
  @override
  final double originalPrice;

  /// In the API, 'price' is actually the sale/discounted price
  @JsonKey(name: 'price')
  @PriceConverter()
  @override
  final double price;

  /// Map salePrice to 'price' field from API (same as price)
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  final double salePrice;

  @SafeStringConverter()
  @override
  final String? imageUrl;

  @SafeStringConverter()
  @override
  final String? brand;

  @SafeStringConverter()
  @override
  final String? slug;

  @SafeStringConverter()
  @JsonKey(name: 'description')
  @override
  final String? shortDescription;

  /// Discount from API is a number, convert to label
  @JsonKey(name: 'discount')
  final int? discountValue;

  @JsonKey(name: 'rating_summary')
  final Map<String, dynamic>? ratingSummary;

  @override
  final double? averageRating;

  @override
  final int? totalReviews;

  @override
  final bool inStock;

  @override
  final String? outOfStockMessage;

  @override
  @JsonKey(fromJson: _variantsFromJson, toJson: _variantsToJson)
  final List<ProductVariantInfo>? variants;

  @override
  String? get discountLabel => discountValue != null && discountValue! > 0
      ? '$discountValue% OFF'
      : null;

  const ProductModel({
    required super.id,
    super.productVariantId,
    required super.name,
    this.slug,
    this.shortDescription,
    required this.originalPrice,
    required this.price,
    double? salePrice,
    this.discountValue,
    super.saleId,
    this.imageUrl,
    this.brand,
    this.ratingSummary,
    this.averageRating,
    this.totalReviews,
    this.inStock = true,
    this.outOfStockMessage,
    this.variants,
  }) : salePrice = salePrice ?? price,
       super(
         originalPrice: originalPrice,
         price: price,
         salePrice: salePrice ?? price,
         slug: slug,
         shortDescription: shortDescription,
         discountLabel: discountValue != null && discountValue > 0
             ? '$discountValue% OFF'
             : null,
         imageUrl: imageUrl,
         brand: brand,
         averageRating: averageRating,
         totalReviews: totalReviews,
         inStock: inStock,
         outOfStockMessage: outOfStockMessage,
         variants: variants,
       );

  static List<ProductVariantInfo>? _variantsFromJson(List<dynamic>? json) {
    if (json == null || json.isEmpty) return null;

    return json
        .whereType<Map<String, dynamic>>()
        .map(ProductVariantInfo.fromJson)
        .toList();
  }

  static List<DataMap>? _variantsToJson(List<ProductVariantInfo>? variants) {
    if (variants == null || variants.isEmpty) return null;

    return variants.map((variant) => variant.toJson()).toList();
  }

  factory ProductModel.fromJson(DataMap json) {
    final normalizedJson = _mergeNestedProductJson(json);
    final imageUrl = _resolveProductImageUrl(normalizedJson);

    // Handle nested brand object
    String? brandName;
    final brandData = normalizedJson['brand'];
    final brandMap = _asDataMap(brandData);
    if (brandMap != null) {
      brandName = _normalizedString(brandMap['name']);
    } else if (brandData is String) {
      brandName = brandData;
    }
    brandName ??= _normalizedString(normalizedJson['brand_name']);

    // Parse the price (which is the sale price in the API)
    const priceConverter = PriceConverter();
    final price = priceConverter.fromJson(normalizedJson['price']);
    final originalPrice = priceConverter.fromJson(
      normalizedJson['original_price'],
    );

    // Handle rating_summary
    double? averageRating;
    int? totalReviews;
    final ratingSummaryData = _asDataMap(normalizedJson['rating_summary']);
    if (ratingSummaryData != null) {
      final avgRating = ratingSummaryData['average_rating'];
      averageRating = avgRating is num ? avgRating.toDouble() : null;

      final totReviews = ratingSummaryData['total_reviews'];
      totalReviews = totReviews is num ? totReviews.toInt() : null;
    }

    // Parse variants list from API response
    List<ProductVariantInfo>? variants;
    final productId = _normalizedInt(normalizedJson['id']) ?? 0;
    final variantMaps = _extractVariantMaps(normalizedJson);
    if (variantMaps.isNotEmpty) {
      final parsedVariants = <ProductVariantInfo>[];
      for (final variantMap in variantMaps) {
        final normalizedVariant = _normalizeVariantJson(
          variantMap,
          productJson: normalizedJson,
          productId: productId,
        );
        if (_normalizedInt(normalizedVariant['id']) == null) continue;
        parsedVariants.add(ProductVariantInfo.fromJson(normalizedVariant));
      }
      if (parsedVariants.isNotEmpty) {
        variants = parsedVariants;
      }
    }

    // Derive productVariantId from first variant if not provided
    int? productVariantId =
        _normalizedInt(normalizedJson['product_variant_id']) ??
        _normalizedInt(normalizedJson['variant_id']);
    if (productVariantId == null && variants != null && variants.isNotEmpty) {
      productVariantId = variants.first.id;
    }

    // Derive price/salePrice from first variant if main price is 0
    double effectivePrice = price;
    double effectiveOriginalPrice = originalPrice;
    if (effectivePrice <= 0 && variants != null && variants.isNotEmpty) {
      effectivePrice = variants.first.salePrice;
      effectiveOriginalPrice = variants.first.price;
    }

    // Determine product-level in_stock status
    bool effectiveInStock = _normalizedBool(
      normalizedJson['in_stock'],
      fallback: true,
    );

    // Derive product-level in_stock from variants when the API didn't
    // explicitly provide it. If all variants are out of stock, mark the
    // product as out of stock so the out-of-stock sticker is shown.
    final bool apiProvidedInStock = normalizedJson.containsKey('in_stock') &&
        normalizedJson['in_stock'] != null;
    if (!apiProvidedInStock && variants != null && variants.isNotEmpty) {
      final allVariantsOutOfStock = variants.every(
        (v) => !v.inStock || !v.isActive,
      );
      if (allVariantsOutOfStock) {
        effectiveInStock = false;
      }
    }

    return ProductModel(
      id: productId,
      productVariantId: productVariantId,
      name: _normalizedString(normalizedJson['name']) ?? '',
      slug: _normalizedString(normalizedJson['slug']),
      shortDescription: _normalizedString(
        normalizedJson['description'] ?? normalizedJson['short_description'],
      ),
      originalPrice: effectiveOriginalPrice,
      price: effectivePrice,
      salePrice: effectivePrice, // price IS the sale price in this API
      discountValue: _normalizedInt(normalizedJson['discount']),
      saleId: _normalizedInt(normalizedJson['sale_id']),
      imageUrl: imageUrl,
      brand: brandName,
      ratingSummary: ratingSummaryData,
      averageRating: averageRating,
      totalReviews: totalReviews,
      inStock: effectiveInStock,
      outOfStockMessage: _normalizedString(
        normalizedJson['out_of_stock_message'],
      ),
      variants: variants,
    );
  }

  DataMap toJson() => _$ProductModelToJson(this);

  /// Create from entity (for testing/mapping purposes)
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      productVariantId: entity.productVariantId,
      name: entity.name,
      slug: entity.slug,
      shortDescription: entity.shortDescription,
      originalPrice: entity.originalPrice,
      price: entity.price,
      salePrice: entity.salePrice,
      saleId: entity.saleId,
      imageUrl: entity.imageUrl,
      brand: entity.brand,
      averageRating: entity.averageRating,
      totalReviews: entity.totalReviews,
      inStock: entity.inStock,
      outOfStockMessage: entity.outOfStockMessage,
      variants: entity.variants,
    );
  }
}
