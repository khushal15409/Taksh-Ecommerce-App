import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/express_products_response.dart';
import 'package:taksh_e_commerce/features/product/domain/repositories/product_repository.dart';

/// Use case for getting express products based on nearest fulfillment center
class GetExpressProducts
    implements UseCase<ExpressProductsResponse, GetExpressProductsParams> {
  final ProductRepository repository;

  GetExpressProducts(this.repository);

  @override
  ResultFuture<ExpressProductsResponse> call(
      GetExpressProductsParams params) async {
    return await repository.getExpressProducts(
      categoryId: params.categoryId,
      latitude: params.latitude,
      longitude: params.longitude,
      page: params.page,
      limit: params.limit,
    );
  }
}

/// Parameters for GetExpressProducts use case
class GetExpressProductsParams extends Equatable {
  final int categoryId;
  final double latitude;
  final double longitude;
  final int page;
  final int limit;

  const GetExpressProductsParams({
    required this.categoryId,
    required this.latitude,
    required this.longitude,
    this.page = 1,
    this.limit = 30,
  });

  @override
  List<Object?> get props => [categoryId, latitude, longitude, page, limit];

  /// Create params from address location
  factory GetExpressProductsParams.fromLocation({
    required int categoryId,
    required double latitude,
    required double longitude,
    int page = 1,
    int limit = 30,
  }) {
    return GetExpressProductsParams(
      categoryId: categoryId,
      latitude: latitude,
      longitude: longitude,
      page: page,
      limit: limit,
    );
  }
}
