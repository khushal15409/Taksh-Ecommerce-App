import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart'
    as order_entity;
import 'package:taksh_e_commerce/features/orders/domain/repositories/order_repository.dart';

/// Use case for cancelling an order
class CancelOrder {
  final OrderRepository _repository;

  CancelOrder(this._repository);

  /// Execute the use case
  Future<Either<Failure, order_entity.Order>> call(int orderId) async {
    return await _repository.cancelOrder(orderId);
  }
}
