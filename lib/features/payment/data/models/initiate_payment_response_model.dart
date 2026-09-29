import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/initiate_payment_response.dart';

part 'initiate_payment_response_model.g.dart';

/// Model for initiate payment response
/// This is flexible to handle different response structures from the backend
@JsonSerializable(createToJson: false)
class InitiatePaymentResponseModel {
  @JsonKey(name: 'razorpay_order_id')
  final String? razorpayOrderId;

  @JsonKey(name: 'order_id')
  final String? orderId;

  @JsonKey(name: 'amount')
  final dynamic amount;

  @JsonKey(name: 'currency')
  final String? currency;

  @JsonKey(name: 'receipt')
  final String? receipt;

  @JsonKey(name: 'razorpay_key')
  final String? razorpayKey;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'message')
  final String? message;

  const InitiatePaymentResponseModel({
    this.razorpayOrderId,
    this.orderId,
    this.amount,
    this.currency,
    this.receipt,
    this.razorpayKey,
    this.status,
    this.message,
  });

  factory InitiatePaymentResponseModel.fromJson(DataMap json) =>
      _$InitiatePaymentResponseModelFromJson(json);

  /// Check if payment initiation was successful
  bool get isSuccess =>
      (status?.toLowerCase() == 'success' || status == '1') ||
      razorpayOrderId != null;

  /// Get amount in paise (for Razorpay)
  int get amountInPaise {
    if (amount == null) return 0;
    if (amount is int) return amount as int;
    if (amount is double) return (amount as double).toInt();
    if (amount is String) {
      final parsed = double.tryParse(amount as String) ?? 0;
      return parsed.toInt();
    }
    return 0;
  }

  /// Convert to domain entity
  InitiatePaymentResponse toEntity() {
    return InitiatePaymentResponse(
      razorpayOrderId: razorpayOrderId ?? '',
      orderId: orderId ?? '',
      amountInPaise: amountInPaise,
      currency: currency ?? 'INR',
      receipt: receipt,
      razorpayKey: razorpayKey,
    );
  }
}
