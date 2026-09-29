import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/paginated_orders.dart';
import 'package:taksh_e_commerce/features/orders/domain/repositories/order_repository.dart';

/// Use case for getting all orders with pagination
class GetOrders {
  final OrderRepository _repository;

  GetOrders(this._repository);

  /// Execute the use case
  /// 
  /// [page] - The page number to fetch (default: 1)
  /// 
  /// Returns [Right(PaginatedOrders)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, PaginatedOrders>> call({int page = 1}) async {
    return await _repository.getOrders(page: page);
  }
}
