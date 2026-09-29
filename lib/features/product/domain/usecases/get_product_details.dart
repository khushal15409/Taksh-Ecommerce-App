import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product.dart';
import 'package:taksh_e_commerce/features/product/domain/repositories/product_repository.dart';

/// Use case for getting product details by ID
class GetProductDetails implements UseCase<Product, GetProductDetailsParams> {
  final ProductRepository repository;

  GetProductDetails(this.repository);

  @override
  ResultFuture<Product> call(GetProductDetailsParams params) async {
    return await repository.getProductDetails(params.productId);
  }
}

/// Parameters for GetProductDetails use case
class GetProductDetailsParams extends Equatable {
  final int productId;

  const GetProductDetailsParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
