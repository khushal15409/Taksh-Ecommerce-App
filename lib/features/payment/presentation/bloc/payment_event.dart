import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart';

/// Base class for all payment events
abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

/// Event to create Razorpay order
class CreateRazorpayOrderEvent extends PaymentEvent {
  final Order order;

  const CreateRazorpayOrderEvent(this.order);

  @override
  List<Object?> get props => [order];
}

/// Event for payment success
class PaymentSuccessEvent extends PaymentEvent {
  final String paymentId;
  final String orderId;
  final String signature;

  const PaymentSuccessEvent({
    required this.paymentId,
    required this.orderId,
    required this.signature,
  });

  @override
  List<Object?> get props => [paymentId, orderId, signature];
}

/// Event for payment failure
class PaymentFailedEvent extends PaymentEvent {
  final String errorCode;
  final String errorMessage;

  const PaymentFailedEvent({
    required this.errorCode,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [errorCode, errorMessage];
}

/// Event to verify payment
class VerifyPaymentEvent extends PaymentEvent {
  final String paymentId;
  final String orderId;
  final String signature;

  const VerifyPaymentEvent({
    required this.paymentId,
    required this.orderId,
    required this.signature,
  });

  @override
  List<Object?> get props => [paymentId, orderId, signature];
}

/// Event to reset payment state
class ResetPaymentEvent extends PaymentEvent {
  const ResetPaymentEvent();
}
