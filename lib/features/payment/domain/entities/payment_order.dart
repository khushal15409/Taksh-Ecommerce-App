import 'package:equatable/equatable.dart';

/// Entity representing a Razorpay order
class PaymentOrder extends Equatable {
  final String id;
  final String razorpayOrderId;
  final int amount;
  final String currency;
  final String receipt;
  final String status;
  final int attempts;
  final DateTime createdAt;

  const PaymentOrder({
    required this.id,
    required this.razorpayOrderId,
    required this.amount,
    required this.currency,
    required this.receipt,
    required this.status,
    required this.attempts,
    required this.createdAt,
  });

  /// Get amount in rupees
  double get amountInRupees => amount / 100;

  @override
  List<Object?> get props => [
        id,
        razorpayOrderId,
        amount,
        currency,
        receipt,
        status,
        attempts,
        createdAt,
      ];

  @override
  String toString() {
    return 'PaymentOrder(id: $id, razorpayOrderId: $razorpayOrderId, amount: $amount, status: $status)';
  }
}
