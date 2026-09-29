import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart' as order_entity;
import 'package:taksh_e_commerce/features/orders/domain/repositories/order_repository.dart';

/// Use case for getting order details by ID
class GetOrderDetails {
  final OrderRepository _repository;

  GetOrderDetails(this._repository);

  /// Execute the use case
  /// 
  /// [orderId] - The ID of the order to fetch
  /// 
  /// Returns [Right(Order)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, order_entity.Order>> call(int orderId) async {
    return await _repository.getOrderDetails(orderId);
  }
}
