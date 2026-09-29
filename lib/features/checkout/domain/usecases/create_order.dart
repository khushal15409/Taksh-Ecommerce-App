import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/order_request.dart';
import 'package:taksh_e_commerce/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart';

/// Use case for creating order
class CreateOrder implements UseCase<Order, OrderRequest> {
  final CheckoutRepository repository;

  CreateOrder(this.repository);

  @override
  ResultFuture<Order> call(OrderRequest params) async {
    return await repository.createOrder(orderRequest: params);
  }
}
