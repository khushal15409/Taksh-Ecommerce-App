import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';

part 'initiate_payment_request_model.g.dart';

/// Model for initiate payment request
@JsonSerializable(createFactory: false)
class InitiatePaymentRequestModel {
  @JsonKey(name: 'order_id')
  final String orderId;

  @JsonKey(name: 'gateway')
  final String gateway;

  const InitiatePaymentRequestModel({
    required this.orderId,
    this.gateway = 'razorpay',
  });

  Map<String, dynamic> toJson() => _$InitiatePaymentRequestModelToJson(this);

  /// Convert to form data map for API
  DataMap toFormData() {
    return {
      'order_id': orderId,
      'gateway': gateway,
    };
  }
}
