import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product.dart';
import 'package:taksh_e_commerce/features/product/domain/repositories/product_repository.dart';

/// Use case for fetching ecommerce product details
class GetEcommerceProductDetails
    extends UseCase<Product, GetEcommerceProductDetailsParams> {
  final ProductRepository repository;

  const GetEcommerceProductDetails(this.repository);

  @override
  ResultFuture<Product> call(GetEcommerceProductDetailsParams params) {
    return repository.getEcommerceProductDetails(params.productId);
  }
}

class GetEcommerceProductDetailsParams extends Equatable {
  final int productId;

  const GetEcommerceProductDetailsParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
