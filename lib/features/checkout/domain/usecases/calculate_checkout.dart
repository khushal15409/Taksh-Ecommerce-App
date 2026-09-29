import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/checkout_summary.dart';
import 'package:taksh_e_commerce/features/checkout/domain/repositories/checkout_repository.dart';

/// Parameters for calculating checkout summary
class CalculateCheckoutParams {
  final List<int> cartItemIds;
  final String deliveryType;
  final String? addressId;
  final String? couponCode;

  const CalculateCheckoutParams({
    required this.cartItemIds,
    required this.deliveryType,
    this.addressId,
    this.couponCode,
  });
}

/// Use case for calculating checkout summary
class CalculateCheckout
    implements UseCase<CheckoutSummary, CalculateCheckoutParams> {
  final CheckoutRepository repository;

  CalculateCheckout(this.repository);

  @override
  ResultFuture<CheckoutSummary> call(CalculateCheckoutParams params) async {
    return await repository.calculateCheckout(
      cartItemIds: params.cartItemIds,
      deliveryType: params.deliveryType,
      addressId: params.addressId,
      couponCode: params.couponCode,
    );
  }
}
