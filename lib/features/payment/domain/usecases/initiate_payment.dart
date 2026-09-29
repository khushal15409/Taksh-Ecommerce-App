import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/initiate_payment_response.dart';
import 'package:taksh_e_commerce/features/payment/domain/repositories/payment_repository.dart';

/// Parameters for InitiatePayment use case
class InitiatePaymentParams {
  final String orderId;
  final String gateway;

  const InitiatePaymentParams({
    required this.orderId,
    this.gateway = 'razorpay',
  });
}

/// Use case for initiating payment (new flow)
/// This is the second step in the online payment checkout flow
/// It creates a Razorpay order after the order has been placed
class InitiatePayment
    implements UseCase<InitiatePaymentResponse, InitiatePaymentParams> {
  final PaymentRepository repository;

  InitiatePayment(this.repository);

  @override
  ResultFuture<InitiatePaymentResponse> call(
      InitiatePaymentParams params) async {
    return await repository.initiatePayment(
      orderId: params.orderId,
      gateway: params.gateway,
    );
  }
}
