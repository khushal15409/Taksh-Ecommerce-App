import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/delivery_option.dart';
import 'package:taksh_e_commerce/features/checkout/domain/repositories/checkout_repository.dart';

/// Use case for getting delivery options
class GetDeliveryOptions implements UseCase<List<DeliveryOption>, String> {
  final CheckoutRepository repository;

  GetDeliveryOptions(this.repository);

  @override
  ResultFuture<List<DeliveryOption>> call(String addressId) async {
    return await repository.getDeliveryOptions(addressId: addressId);
  }
}
