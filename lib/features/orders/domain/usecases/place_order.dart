import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart' as order_entity;
import 'package:taksh_e_commerce/features/orders/domain/repositories/order_repository.dart';

/// Parameters for placing an order
class PlaceOrderParams {
  final int addressId;
  final int warehouseId;
  final String deliveryType;
  final String paymentMethod;

  const PlaceOrderParams({
    required this.addressId,
    required this.warehouseId,
    required this.deliveryType,
    required this.paymentMethod,
  });
}

/// Use case for placing a new order
class PlaceOrder {
  final OrderRepository _repository;

  PlaceOrder(this._repository);

  /// Execute the use case
  /// 
  /// [params] - The parameters for placing the order
  /// 
  /// Returns [Right(Order)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, order_entity.Order>> call(
      PlaceOrderParams params) async {
    return await _repository.placeOrder(
      addressId: params.addressId,
      warehouseId: params.warehouseId,
      deliveryType: params.deliveryType,
      paymentMethod: params.paymentMethod,
    );
  }
}
