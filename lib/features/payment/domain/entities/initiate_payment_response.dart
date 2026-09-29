import 'package:equatable/equatable.dart';

/// Entity for payment initiation response
class InitiatePaymentResponse extends Equatable {
  final String razorpayOrderId;
  final String orderId;
  final int amountInPaise;
  final String currency;
  final String? receipt;
  final String? razorpayKey;

  const InitiatePaymentResponse({
    required this.razorpayOrderId,
    required this.orderId,
    required this.amountInPaise,
    required this.currency,
    this.receipt,
    this.razorpayKey,
  });

  @override
  List<Object?> get props => [
        razorpayOrderId,
        orderId,
        amountInPaise,
        currency,
        receipt,
        razorpayKey,
      ];
}
