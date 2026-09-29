import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';

part 'verify_payment_request_model.g.dart';

/// Model for verify payment request
@JsonSerializable(createFactory: false)
class VerifyPaymentRequestModel {
  @JsonKey(name: 'razorpay_order_id')
  final String razorpayOrderId;

  @JsonKey(name: 'razorpay_payment_id')
  final String razorpayPaymentId;

  @JsonKey(name: 'razorpay_signature')
  final String razorpaySignature;

  const VerifyPaymentRequestModel({
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });

  Map<String, dynamic> toJson() => _$VerifyPaymentRequestModelToJson(this);

  /// Convert to form data map for API
  DataMap toFormData() {
    return {
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'razorpay_signature': razorpaySignature,
    };
  }
}
