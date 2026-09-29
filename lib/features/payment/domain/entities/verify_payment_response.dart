import 'package:equatable/equatable.dart';

/// Entity for payment verification response
class VerifyPaymentResponse extends Equatable {
  final bool verified;
  final String? message;
  final String? paymentId;
  final String? orderId;

  const VerifyPaymentResponse({
    required this.verified,
    this.message,
    this.paymentId,
    this.orderId,
  });

  @override
  List<Object?> get props => [verified, message, paymentId, orderId];
}
