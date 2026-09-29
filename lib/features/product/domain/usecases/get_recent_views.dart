import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/recent_view.dart';
import 'package:taksh_e_commerce/features/product/domain/repositories/product_repository.dart';

/// Use case for getting recent views
class GetRecentViews extends UseCaseNoParams<List<RecentView>> {
  final ProductRepository _repository;

  const GetRecentViews(this._repository);

  @override
  ResultFuture<List<RecentView>> call() {
    return _repository.getRecentViews();
  }
}
