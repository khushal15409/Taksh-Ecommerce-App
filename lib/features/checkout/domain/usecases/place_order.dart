import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/place_order_response.dart';
import 'package:taksh_e_commerce/features/checkout/domain/repositories/checkout_repository.dart';

/// Parameters for PlaceOrder use case
class PlaceOrderParams {
  final String addressId;
  final String warehouseId;
  final String deliveryType;
  final String paymentMethod;
  final String vendorId;
  final List<ExtraCharge> extraCharges;

  const PlaceOrderParams({
    required this.addressId,
    required this.warehouseId,
    required this.deliveryType,
    required this.paymentMethod,
    required this.vendorId,
    this.extraCharges = const [],
  });
}

/// Use case for placing an order (new flow)
/// This is the first step in the online payment checkout flow
class PlaceOrder implements UseCase<PlaceOrderResponse, PlaceOrderParams> {
  final CheckoutRepository repository;

  PlaceOrder(this.repository);

  @override
  ResultFuture<PlaceOrderResponse> call(PlaceOrderParams params) async {
    return await repository.placeOrder(
      addressId: params.addressId,
      warehouseId: params.warehouseId,
      deliveryType: params.deliveryType,
      paymentMethod: params.paymentMethod,
      vendorId: params.vendorId,
      extraCharges: params.extraCharges,
    );
  }
}
