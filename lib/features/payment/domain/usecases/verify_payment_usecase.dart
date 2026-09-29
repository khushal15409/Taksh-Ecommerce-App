import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/verify_payment_response.dart';
import 'package:taksh_e_commerce/features/payment/domain/repositories/payment_repository.dart';

/// Parameters for VerifyPayment use case
class VerifyPaymentParams {
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  const VerifyPaymentParams({
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });
}

/// Use case for verifying payment (new flow)
/// This is the final step in the online payment checkout flow
class VerifyPaymentUseCase
    implements UseCase<VerifyPaymentResponse, VerifyPaymentParams> {
  final PaymentRepository repository;

  VerifyPaymentUseCase(this.repository);

  @override
  ResultFuture<VerifyPaymentResponse> call(VerifyPaymentParams params) async {
    return await repository.verifyPayment(
      razorpayOrderId: params.razorpayOrderId,
      razorpayPaymentId: params.razorpayPaymentId,
      razorpaySignature: params.razorpaySignature,
    );
  }
}
