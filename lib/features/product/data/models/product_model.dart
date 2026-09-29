import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product.dart';
import 'package:taksh_e_commerce/features/product/data/models/brand_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/category_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/product_variant_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/product_image_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/rating_summary_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/review_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/question_answer_model.dart';

part 'product_model.g.dart';

int _productAsInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();

  final normalizedValue = value?.toString().trim();
  if (normalizedValue == null || normalizedValue.isEmpty) {
    return fallback;
  }

  return num.tryParse(normalizedValue)?.toInt() ?? fallback;
}

bool _productAsBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;

  switch (value?.toString().trim().toLowerCase()) {
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

bool? _productAsNullableBool(dynamic value) {
  if (value == null) return null;
  return _productAsBool(value);
}

String? _productAsString(dynamic value) {
  if (value == null) return null;
  final normalizedValue = value.toString().trim();
  return normalizedValue.isEmpty ? null : normalizedValue;
}

String? _extractProductImageUrl(dynamic value) {
  if (value is List) {
    for (final item in value) {
      final imageUrl = _extractProductImageUrl(item);
      if (imageUrl != null) return imageUrl;
    }
    return null;
  }

  if (value is Map) {
    final rawMap = Map<String, dynamic>.from(value);
    for (final key in const [
      'image_url',
      'url',
      'image',
      'src',
      'path',
      'thumbnail',
      'featured_image',
      'main_image',
    ]) {
      final imageUrl = _productAsString(rawMap[key]);
      if (imageUrl != null) return imageUrl;
    }
    return null;
  }

  return _productAsString(value);
}

Map<String, dynamic>? _normalizeProductImage(
  dynamic rawImage, {
  required int productId,
  int? productVariantId,
  required int fallbackId,
  required int sortOrder,
  bool? isPrimary,
}) {
  final rawMap = rawImage is Map
      ? Map<String, dynamic>.from(rawImage)
      : const <String, dynamic>{};
  final imageUrl = _extractProductImageUrl(rawImage);

  if (imageUrl == null) {
    return null;
  }

  return {
    'id': _productAsInt(rawMap['id'], fallback: fallbackId),
    'product_id': _productAsInt(rawMap['product_id'], fallback: productId),
    'product_variant_id':
        rawMap['product_variant_id'] ??
        rawMap['variant_id'] ??
        productVariantId,
    'image_url': imageUrl,
    'is_primary': _productAsBool(
      rawMap['is_primary'] ?? rawMap['primary'],
      fallback: isPrimary ?? sortOrder == 0,
    ),
    'sort_order': _productAsInt(
      rawMap['sort_order'] ?? rawMap['order'],
      fallback: sortOrder,
    ),
    'created_at': rawMap['created_at'],
    'updated_at': rawMap['updated_at'],
  };
}

List<Map<String, dynamic>> _normalizeProductImages(
  dynamic rawImages, {
  required int productId,
  int? productVariantId,
}) {
  if (rawImages is! List) {
    final singleImage = _normalizeProductImage(
      rawImages,
      productId: productId,
      productVariantId: productVariantId,
      fallbackId: 0,
      sortOrder: 0,
      isPrimary: true,
    );
    return singleImage == null
        ? const <Map<String, dynamic>>[]
        : <Map<String, dynamic>>[singleImage];
  }

  final images = <Map<String, dynamic>>[];
  for (var index = 0; index < rawImages.length; index++) {
    final image = _normalizeProductImage(
      rawImages[index],
      productId: productId,
      productVariantId: productVariantId,
      fallbackId: index,
      sortOrder: index,
    );
    if (image != null) {
      images.add(image);
    }
  }

  return images;
}

List<Map<String, dynamic>> _normalizeProductVariants(
  dynamic rawVariants, {
  required int productId,
}) {
  if (rawVariants is! List) return const <Map<String, dynamic>>[];

  final variants = <Map<String, dynamic>>[];
  for (var index = 0; index < rawVariants.length; index++) {
    final rawVariant = rawVariants[index];
    if (rawVariant is! Map) continue;

    final variant = Map<String, dynamic>.from(rawVariant);
    final variantId = _productAsInt(variant['id'], fallback: index);
    final variantImages = _normalizeProductImages(
      variant['images'],
      productId: productId,
      productVariantId: variantId,
    );

    if (variantImages.isEmpty) {
      final fallbackImage = _normalizeProductImage(
        variant['image_url'] ?? variant['image'] ?? variant['thumbnail'],
        productId: productId,
        productVariantId: variantId,
        fallbackId: variantId,
        sortOrder: 0,
        isPrimary: true,
      );
      if (fallbackImage != null) {
        variantImages.add(fallbackImage);
      }
    }

    variant['id'] = variantId;
    variant['product_id'] = _productAsInt(
      variant['product_id'],
      fallback: productId,
    );
    variant['sku'] = _productAsString(variant['sku']) ?? '';
    variant['price'] =
        _productAsString(
          variant['price'] ??
              variant['original_price'] ??
              variant['sale_price'],
        ) ??
        '0';
    variant['sale_price'] = _productAsString(variant['sale_price']);
    variant['status'] = _productAsString(variant['status']) ?? 'active';
    variant['out_of_stock_message'] = _productAsString(
      variant['out_of_stock_message'],
    );

    final explicitInStock = _productAsNullableBool(variant['in_stock']);
    final stockQuantity = variant['stock_quantity'] ??
      variant['stock_qty'] ??
        variant['available_stock'] ??
        variant['quantity'];
    final normalizedStockStatus = _productAsString(variant['stock_status'])
        ?.toLowerCase();

    // Normalize available_stock so the generated ProductVariantModel
    // parser picks it up. Without this, variants that only return
    // `stock_quantity` / `stock_qty` / `quantity` end up with a null
    // `availableStock`, which the cart treats as "in stock" even when
    // the server has no inventory.
    if (stockQuantity != null) {
      variant['available_stock'] = _productAsInt(stockQuantity);
    }

    bool variantInStock = explicitInStock ?? true;
    final hasStockInfo =
        explicitInStock != null ||
        stockQuantity != null ||
        normalizedStockStatus != null ||
        variant['out_of_stock_message'] != null;

    if (explicitInStock == null && stockQuantity != null) {
      variantInStock = _productAsInt(stockQuantity, fallback: 0) > 0;
    } else if (explicitInStock == null && normalizedStockStatus != null) {
      if (const {'out_of_stock', 'sold_out', 'unavailable'}.contains(
        normalizedStockStatus,
      )) {
        variantInStock = false;
      } else if (const {'in_stock', 'available'}.contains(
        normalizedStockStatus,
      )) {
        variantInStock = true;
      }
    }

    variant['in_stock'] = variantInStock;
    variant['has_stock_info'] = hasStockInfo;
    variant['images'] = variantImages;

    variants.add(variant);
  }

  return variants;
}

Map<String, dynamic>? _firstVariantImage(List<Map<String, dynamic>> variants) {
  for (final variant in variants) {
    final images = variant['images'];
    if (images is List && images.isNotEmpty) {
      final firstImage = images.first;
      if (firstImage is Map) {
        return Map<String, dynamic>.from(firstImage);
      }
    }
  }

  return null;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ProductModel extends Product {
  @JsonKey(name: 'brand')
  final BrandModel? brandModel;

  @JsonKey(name: 'category')
  final CategoryModel? categoryModel;

  @JsonKey(name: 'variants')
  final List<ProductVariantModel>? variantModels;

  @JsonKey(name: 'images')
  final List<ProductImageModel>? imageModels;

  @JsonKey(name: 'rating_summary')
  final RatingSummaryModel? ratingSummaryModel;

  @JsonKey(name: 'reviews')
  final List<ReviewModel>? reviewModels;

  @JsonKey(name: 'questions_answers')
  final List<QuestionAnswerModel>? questionsAnswersModels;

  @override
  @JsonKey(name: 'brand_id')
  final int? brandId;

  @override
  @JsonKey(name: 'is_trending', defaultValue: false)
  final bool isTrending;

  @override
  @JsonKey(name: 'is_latest', defaultValue: false)
  final bool isLatest;

  @override
  @JsonKey(name: 'is_express_30', defaultValue: false)
  final bool isExpress30;

  @override
  @JsonKey(name: 'in_stock', defaultValue: true)
  final bool inStock;

  @override
  @JsonKey(name: 'out_of_stock_message')
  final String? outOfStockMessage;

  const ProductModel({
    required super.id,
    required super.categoryId,
    this.brandId,
    super.fulfillmentCenterId,
    required super.name,
    required super.slug,
    super.description,
    super.shortDescription,
    required super.status,
    required this.isTrending,
    required this.isLatest,
    required this.isExpress30,
    super.createdAt,
    super.updatedAt,
    this.brandModel,
    this.categoryModel,
    this.variantModels,
    this.imageModels,
    this.ratingSummaryModel,
    this.reviewModels,
    this.questionsAnswersModels,
    super.originalPrice,
    super.salePrice,
    super.discountLabel,
    super.saleId,
    this.inStock = true,
    this.outOfStockMessage,
  }) : super(
         brandId: brandId,
         isTrending: isTrending,
         isLatest: isLatest,
         isExpress30: isExpress30,
         brand: brandModel,
         category: categoryModel,
         variants: variantModels,
         images: imageModels,
         ratingSummary: ratingSummaryModel,
         reviews: reviewModels,
         questionsAnswers: questionsAnswersModels,
         inStock: inStock,
         outOfStockMessage: outOfStockMessage,
       );

  factory ProductModel.fromJson(DataMap json) {
    final processedJson = Map<String, dynamic>.from(json);
    final productId = _productAsInt(processedJson['id']);

    processedJson['id'] = productId;
    processedJson['name'] = _productAsString(processedJson['name']) ?? '';
    processedJson['slug'] = _productAsString(processedJson['slug']) ?? '';
    processedJson['description'] = _productAsString(
      processedJson['description'],
    );
    processedJson['short_description'] = _productAsString(
      processedJson['short_description'],
    );
    processedJson['discount_label'] = _productAsString(
      processedJson['discount_label'],
    );
    processedJson['out_of_stock_message'] = _productAsString(
      processedJson['out_of_stock_message'],
    );
    processedJson['brand_id'] = processedJson['brand_id'] == null
        ? null
        : _productAsInt(processedJson['brand_id']);
    processedJson['fulfillment_center_id'] =
        processedJson['fulfillment_center_id'] == null
        ? null
        : _productAsInt(processedJson['fulfillment_center_id']);
    processedJson['is_trending'] = _productAsBool(processedJson['is_trending']);
    processedJson['is_latest'] = _productAsBool(processedJson['is_latest']);
    processedJson['is_express_30'] = _productAsBool(
      processedJson['is_express_30'],
    );

    // Track whether the API explicitly provided in_stock before normalizing
    final bool apiProvidedInStock = processedJson.containsKey('in_stock') &&
        processedJson['in_stock'] != null;
    processedJson['in_stock'] = _productAsBool(
      processedJson['in_stock'],
      fallback: true,
    );

    // Express API returns category as nested object without top-level category_id
    if (!processedJson.containsKey('category_id') &&
        processedJson['category'] is Map) {
      processedJson['category_id'] = _productAsInt(
        (processedJson['category'] as Map)['id'],
      );
    }
    processedJson['category_id'] = _productAsInt(processedJson['category_id']);

    if (processedJson['brand'] is! Map) {
      processedJson['brand'] = null;
    }
    if (processedJson['category'] is! Map) {
      processedJson['category'] = null;
    }

    final normalizedVariants = _normalizeProductVariants(
      processedJson['variants'],
      productId: productId,
    );
    if (normalizedVariants.isNotEmpty ||
        processedJson.containsKey('variants')) {
      processedJson['variants'] = normalizedVariants;
    }

    // Derive product-level in_stock from variants when the API didn't
    // explicitly provide it. If all variants are out of stock, mark the
    // product as out of stock so the out-of-stock sticker is shown.
    if (!apiProvidedInStock && normalizedVariants.isNotEmpty) {
      final allVariantsOutOfStock = normalizedVariants.every((variant) {
        final variantInStock = variant['in_stock'];
        final variantStatus = _productAsString(variant['status']);
        final isActive = variantStatus == null || variantStatus == 'active';
        return variantInStock == false || !isActive;
      });
      if (allVariantsOutOfStock) {
        processedJson['in_stock'] = false;
      }
    }

    final normalizedImages = _normalizeProductImages(
      processedJson['images'],
      productId: productId,
    );
    if (normalizedImages.isNotEmpty) {
      processedJson['images'] = normalizedImages;
    } else {
      final fallbackImage = _normalizeProductImage(
        processedJson['image_url'] ??
            processedJson['image'] ??
            processedJson['thumbnail'] ??
            processedJson['featured_image'] ??
            processedJson['main_image'],
        productId: productId,
        fallbackId: productId,
        sortOrder: 0,
        isPrimary: true,
      );

      if (fallbackImage != null) {
        processedJson['images'] = <Map<String, dynamic>>[fallbackImage];
      } else {
        final firstVariantImage = _firstVariantImage(normalizedVariants);
        processedJson['images'] = firstVariantImage == null
            ? const <Map<String, dynamic>>[]
            : <Map<String, dynamic>>[firstVariantImage];
      }
    }

    // Express API may not return status field
    if (!processedJson.containsKey('status')) {
      processedJson['status'] = 'active';
    }
    processedJson['status'] =
        _productAsString(processedJson['status']) ?? 'active';

    final currentOriginalPrice = processedJson['original_price'];
    final currentSalePrice = processedJson['sale_price'];
    if (currentOriginalPrice != null) {
      processedJson['original_price'] = _productAsInt(currentOriginalPrice);
    }
    if (currentSalePrice != null) {
      processedJson['sale_price'] = _productAsInt(currentSalePrice);
    }

    // Express API returns prices only in variants — extract to top level
    if (!processedJson.containsKey('original_price') ||
        processedJson['original_price'] == null) {
      if (normalizedVariants.isNotEmpty) {
        final firstVariant = normalizedVariants.first;
        final price = firstVariant['price'];
        final salePrice = firstVariant['sale_price'];
        if (price != null) {
          processedJson['original_price'] = _productAsInt(price);
        }
        if (salePrice != null) {
          processedJson['sale_price'] = _productAsInt(salePrice);
        }
      }
    }
    return _$ProductModelFromJson(processedJson);
  }

  DataMap toJson() => _$ProductModelToJson(this);
}
