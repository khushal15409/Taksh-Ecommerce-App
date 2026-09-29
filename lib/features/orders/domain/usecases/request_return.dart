import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/repositories/order_repository.dart';

/// Parameters for requesting a return
class RequestReturnParams {
  final int orderId;
  final int orderItemId;
  final String reason;
  final String? resolution;

  const RequestReturnParams({
    required this.orderId,
    required this.orderItemId,
    required this.reason,
    this.resolution,
  });
}

/// Use case for requesting a return for an order item
class RequestReturn {
  final OrderRepository _repository;

  RequestReturn(this._repository);

  /// Execute the use case
  /// 
  /// [params] - The parameters for requesting the return
  /// 
  /// Returns [Right(DataMap)] with response data on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, DataMap>> call(RequestReturnParams params) async {
    return await _repository.requestReturn(
      orderId: params.orderId,
      orderItemId: params.orderItemId,
      reason: params.reason,
      resolution: params.resolution,
    );
  }
}
