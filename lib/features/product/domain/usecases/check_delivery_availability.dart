import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/delivery_availability.dart';
import 'package:taksh_e_commerce/features/product/domain/repositories/product_repository.dart';

/// Use case for checking delivery availability for a product at a given pincode
class CheckDeliveryAvailability
    extends UseCase<DeliveryAvailability, CheckDeliveryAvailabilityParams> {
  final ProductRepository repository;

  const CheckDeliveryAvailability(this.repository);

  @override
  ResultFuture<DeliveryAvailability> call(
      CheckDeliveryAvailabilityParams params) {
    return repository.checkDeliveryAvailability(
      productId: params.productId,
      pincode: params.pincode,
    );
  }
}

class CheckDeliveryAvailabilityParams extends Equatable {
  final int productId;
  final String pincode;

  const CheckDeliveryAvailabilityParams({
    required this.productId,
    required this.pincode,
  });

  @override
  List<Object?> get props => [productId, pincode];
}
