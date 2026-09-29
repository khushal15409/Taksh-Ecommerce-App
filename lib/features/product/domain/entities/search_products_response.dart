import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/search_product.dart';

/// Search products response entity
class SearchProductsResponse extends Equatable {
  final bool status;
  final String keyword;
  final int count;
  final List<SearchProduct> products;

  const SearchProductsResponse({
    required this.status,
    required this.keyword,
    required this.count,
    required this.products,
  });

  bool get isEmpty => products.isEmpty;

  @override
  List<Object?> get props => [status, keyword, count, products];
}
