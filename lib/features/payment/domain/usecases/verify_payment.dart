import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/domain/repositories/payment_repository.dart';

/// Parameters for verifying payment signature
class VerifyPaymentParams {
  final String orderId;
  final String paymentId;
  final String signature;

  const VerifyPaymentParams({
    required this.orderId,
    required this.paymentId,
    required this.signature,
  });
}

/// Use case for verifying payment signature
class VerifyPayment implements UseCase<bool, VerifyPaymentParams> {
  final PaymentRepository repository;

  VerifyPayment(this.repository);

  @override
  ResultFuture<bool> call(VerifyPaymentParams params) async {
    return await repository.verifyPaymentSignature(
      orderId: params.orderId,
      paymentId: params.paymentId,
      signature: params.signature,
    );
  }
}
