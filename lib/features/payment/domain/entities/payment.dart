import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment_method.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment_status.dart';

/// Entity representing a payment
class Payment extends Equatable {
  final String id;
  final String orderId;
  final int amount;
  final String currency;
  final PaymentStatus status;
  final PaymentMethod method;
  final String? razorpayPaymentId;
  final String? razorpayOrderId;
  final String? razorpaySignature;
  final String? errorCode;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Payment({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.method,
    this.razorpayPaymentId,
    this.razorpayOrderId,
    this.razorpaySignature,
    this.errorCode,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get amount in rupees
  double get amountInRupees => amount / 100;

  /// Check if payment is successful
  bool get isSuccessful => status == PaymentStatus.success;

  /// Check if payment is pending
  bool get isPending => status == PaymentStatus.pending;

  /// Check if payment failed
  bool get isFailed => status == PaymentStatus.failed;

  @override
  List<Object?> get props => [
        id,
        orderId,
        amount,
        currency,
        status,
        method,
        razorpayPaymentId,
        razorpayOrderId,
        razorpaySignature,
        errorCode,
        errorMessage,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Payment(id: $id, orderId: $orderId, amount: $amount, status: $status)';
  }
}
