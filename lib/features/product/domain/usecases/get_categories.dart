import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';
import 'package:taksh_e_commerce/features/product/domain/repositories/product_repository.dart';

/// Use case for getting all categories
class GetCategories implements UseCase<List<Category>, GetCategoriesParams> {
  final ProductRepository repository;

  GetCategories(this.repository);

  @override
  ResultFuture<List<Category>> call(GetCategoriesParams params) async {
    return await repository.getCategories(
      deliveryType: params.deliveryType,
    );
  }
}

class GetCategoriesParams {
  final String deliveryType;

  const GetCategoriesParams({required this.deliveryType});
}
