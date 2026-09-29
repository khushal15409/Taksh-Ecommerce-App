import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/paginated_products.dart';
import 'package:taksh_e_commerce/features/product/domain/repositories/product_repository.dart';

/// Use case for getting paginated products with filters
class GetProducts implements UseCase<PaginatedProducts, GetProductsParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  ResultFuture<PaginatedProducts> call(GetProductsParams params) async {
    return await repository.getProducts(
      categoryId: params.categoryId,
      search: params.search,
      page: params.page,
      limit: params.limit,
    );
  }
}

/// Parameters for GetProducts use case
class GetProductsParams extends Equatable {
  final int? categoryId;
  final String? search;
  final int page;
  final int limit;

  const GetProductsParams({
    this.categoryId,
    this.search,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [categoryId, search, page, limit];
}
