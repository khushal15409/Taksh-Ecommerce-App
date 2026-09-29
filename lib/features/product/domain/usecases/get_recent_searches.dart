import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/recent_search.dart';
import 'package:taksh_e_commerce/features/product/domain/repositories/product_repository.dart';

/// Use case for getting recent searches
class GetRecentSearches extends UseCaseNoParams<List<RecentSearch>> {
  final ProductRepository _repository;

  const GetRecentSearches(this._repository);

  @override
  ResultFuture<List<RecentSearch>> call() {
    return _repository.getRecentSearches();
  }
}
