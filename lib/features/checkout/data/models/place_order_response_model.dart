import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/place_order_response.dart';

part 'place_order_response_model.g.dart';

/// Model for place order response
/// This is flexible to handle different response structures from the backend
@JsonSerializable(createToJson: false)
class PlaceOrderResponseModel {
  @JsonKey(name: 'order_id')
  final int? orderId;

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'order_number')
  final String? orderNumber;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'total_amount')
  final dynamic totalAmount;

  @JsonKey(name: 'payment_status')
  final String? paymentStatus;

  @JsonKey(name: 'order_status')
  final String? orderStatus;

  const PlaceOrderResponseModel({
    this.orderId,
    this.id,
    this.orderNumber,
    this.message,
    this.status,
    this.totalAmount,
    this.paymentStatus,
    this.orderStatus,
  });

  factory PlaceOrderResponseModel.fromJson(DataMap json) =>
      _$PlaceOrderResponseModelFromJson(json);

  /// Get the actual order ID from various possible fields
  int get actualOrderId => orderId ?? id ?? 0;

  /// Check if order was placed successfully
  bool get isSuccess =>
      (status?.toLowerCase() == 'success' || status == '1') ||
      actualOrderId > 0;

  /// Convert to domain entity
  PlaceOrderResponse toEntity() {
    return PlaceOrderResponse(
      orderId: actualOrderId,
      orderNumber: orderNumber,
      message: message,
      totalAmount: totalAmount?.toString(),
      paymentStatus: paymentStatus,
      orderStatus: orderStatus,
    );
  }
}
