import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/search_products_response.dart';
import 'package:taksh_e_commerce/features/product/domain/repositories/product_repository.dart';

/// Use case for searching products by keyword
class SearchProducts extends UseCase<SearchProductsResponse, String> {
  final ProductRepository repository;

  const SearchProducts(this.repository);

  @override
  ResultFuture<SearchProductsResponse> call(String params) {
    return repository.searchProducts(keyword: params);
  }
}
