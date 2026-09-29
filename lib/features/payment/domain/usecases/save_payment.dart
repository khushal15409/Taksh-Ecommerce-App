import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment.dart';
import 'package:taksh_e_commerce/features/payment/domain/repositories/payment_repository.dart';

/// Parameters for saving payment details
class SavePaymentParams {
  final String orderId;
  final int amount;
  final String razorpayOrderId;
  final String? razorpayPaymentId;
  final String? razorpaySignature;
  final String? errorCode;
  final String? errorMessage;

  const SavePaymentParams({
    required this.orderId,
    required this.amount,
    required this.razorpayOrderId,
    this.razorpayPaymentId,
    this.razorpaySignature,
    this.errorCode,
    this.errorMessage,
  });
}

/// Use case for saving payment details
class SavePayment implements UseCase<Payment, SavePaymentParams> {
  final PaymentRepository repository;

  SavePayment(this.repository);

  @override
  ResultFuture<Payment> call(SavePaymentParams params) async {
    return await repository.savePaymentDetails(
      orderId: params.orderId,
      amount: params.amount,
      razorpayOrderId: params.razorpayOrderId,
      razorpayPaymentId: params.razorpayPaymentId,
      razorpaySignature: params.razorpaySignature,
      errorCode: params.errorCode,
      errorMessage: params.errorMessage,
    );
  }
}
