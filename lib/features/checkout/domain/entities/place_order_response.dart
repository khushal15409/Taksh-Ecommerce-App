import 'package:equatable/equatable.dart';

/// Entity for place order response
class PlaceOrderResponse extends Equatable {
  final int orderId;
  final String? orderNumber;
  final String? message;
  final String? totalAmount;
  final String? paymentStatus;
  final String? orderStatus;

  const PlaceOrderResponse({
    required this.orderId,
    this.orderNumber,
    this.message,
    this.totalAmount,
    this.paymentStatus,
    this.orderStatus,
  });

  @override
  List<Object?> get props => [
        orderId,
        orderNumber,
        message,
        totalAmount,
        paymentStatus,
        orderStatus,
      ];
}
