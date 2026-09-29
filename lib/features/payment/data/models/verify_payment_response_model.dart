import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/verify_payment_response.dart';

part 'verify_payment_response_model.g.dart';

/// Model for verify payment response
/// This is flexible to handle different response structures from the backend
@JsonSerializable(createToJson: false)
class VerifyPaymentResponseModel {
  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'verified')
  final bool? verified;

  @JsonKey(name: 'payment_id')
  final dynamic paymentId;

  @JsonKey(name: 'order_id')
  final dynamic orderId;

  @JsonKey(name: 'order_status')
  final String? orderStatus;

  const VerifyPaymentResponseModel({
    this.status,
    this.message,
    this.verified,
    this.paymentId,
    this.orderId,
    this.orderStatus,
  });

  factory VerifyPaymentResponseModel.fromJson(DataMap json) =>
      _$VerifyPaymentResponseModelFromJson(json);

  /// Check if payment verification was successful
  /// Backend returns status: "paid" when payment is verified
  bool get isSuccess =>
      verified == true ||
      status?.toLowerCase() == 'paid' ||
      status?.toLowerCase() == 'success' ||
      status == '1';

  /// Get payment ID as string
  String? get paymentIdString => paymentId?.toString();

  /// Get order ID as string
  String? get orderIdString => orderId?.toString();

  /// Convert to domain entity
  VerifyPaymentResponse toEntity() {
    return VerifyPaymentResponse(
      verified: isSuccess,
      message: message ??
          (isSuccess
              ? 'Payment verified successfully'
              : 'Payment verification failed'),
      paymentId: paymentIdString,
      orderId: orderIdString,
    );
  }
}
