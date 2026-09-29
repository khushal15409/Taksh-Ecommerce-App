import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/order_request.dart';
import 'package:taksh_e_commerce/features/checkout/domain/repositories/checkout_repository.dart';

/// Use case for validating checkout
class ValidateCheckout implements UseCase<bool, OrderRequest> {
  final CheckoutRepository repository;

  ValidateCheckout(this.repository);

  @override
  ResultFuture<bool> call(OrderRequest params) async {
    return await repository.validateCheckout(orderRequest: params);
  }
}
