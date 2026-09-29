import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/search_product.dart';

/// Model for search product item
class SearchProductModel extends SearchProduct {
  const SearchProductModel({
    required super.id,
    required super.name,
    super.brand,
    required super.price,
    super.mrp,
    super.imageUrl,
    required super.inStock,
  });

  factory SearchProductModel.fromJson(DataMap json) {
    return SearchProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String?,
      price: (json['price'] as num?)?.toInt() ?? 0,
      mrp: (json['mrp'] as num?)?.toInt(),
      imageUrl: json['image'] as String?,
      inStock: json['in_stock'] as bool? ?? false,
    );
  }
}
