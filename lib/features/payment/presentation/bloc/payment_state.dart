import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment_order.dart';

/// Base class for all payment states
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

/// Creating Razorpay order state
class CreatingRazorpayOrder extends PaymentState {
  const CreatingRazorpayOrder();
}

/// Razorpay order created state
class RazorpayOrderCreated extends PaymentState {
  final PaymentOrder paymentOrder;

  const RazorpayOrderCreated(this.paymentOrder);

  @override
  List<Object?> get props => [paymentOrder];
}

/// Processing payment state
class ProcessingPayment extends PaymentState {
  const ProcessingPayment();
}

/// Payment success state (before verification)
class PaymentSucceeded extends PaymentState {
  final String paymentId;
  final String orderId;
  final String signature;

  const PaymentSucceeded({
    required this.paymentId,
    required this.orderId,
    required this.signature,
  });

  @override
  List<Object?> get props => [paymentId, orderId, signature];
}

/// Payment failed state
class PaymentFailed extends PaymentState {
  final String errorCode;
  final String errorMessage;

  const PaymentFailed({
    required this.errorCode,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [errorCode, errorMessage];
}

/// Verifying payment state
class VerifyingPayment extends PaymentState {
  const VerifyingPayment();
}

/// Payment verified state
class PaymentVerified extends PaymentState {
  final Payment payment;

  const PaymentVerified(this.payment);

  @override
  List<Object?> get props => [payment];
}

/// Payment error state
class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
