import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/data/models/search_product_model.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/search_products_response.dart';

/// Model for search products API response
class SearchProductsResponseModel extends SearchProductsResponse {
  const SearchProductsResponseModel({
    required super.status,
    required super.keyword,
    required super.count,
    required super.products,
  });

  factory SearchProductsResponseModel.fromJson(DataMap json) {
    final data = (json['data'] as List?) ?? const [];
    return SearchProductsResponseModel(
      status: json['status'] as bool? ?? false,
      keyword: json['keyword'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? data.length,
      products: data
          .map((item) => SearchProductModel.fromJson(item as DataMap))
          .toList(),
    );
  }
}
