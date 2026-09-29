import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment_method.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment_status.dart';

part 'payment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PaymentModel extends Payment {
  @JsonKey(name: 'status')
  final String statusString;

  @JsonKey(name: 'method')
  final String methodString;

  const PaymentModel({
    required super.id,
    required super.orderId,
    required super.amount,
    required super.currency,
    required this.statusString,
    required this.methodString,
    super.razorpayPaymentId,
    super.razorpayOrderId,
    super.razorpaySignature,
    super.errorCode,
    super.errorMessage,
    required super.createdAt,
    required super.updatedAt,
  }) : super(
          status: PaymentStatus.pending,
          method: PaymentMethod.razorpay,
        );

  factory PaymentModel.fromJson(DataMap json) => _$PaymentModelFromJson(json);

  DataMap toJson() => _$PaymentModelToJson(this);

  /// Convert to entity
  Payment toEntity() {
    return Payment(
      id: id,
      orderId: orderId,
      amount: amount,
      currency: currency,
      status: _parseStatus(statusString),
      method: _parseMethod(methodString),
      razorpayPaymentId: razorpayPaymentId,
      razorpayOrderId: razorpayOrderId,
      razorpaySignature: razorpaySignature,
      errorCode: errorCode,
      errorMessage: errorMessage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static PaymentStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'processing':
        return PaymentStatus.processing;
      case 'success':
        return PaymentStatus.success;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      case 'cancelled':
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.pending;
    }
  }

  static PaymentMethod _parseMethod(String method) {
    switch (method.toLowerCase()) {
      case 'razorpay':
        return PaymentMethod.razorpay;
      case 'cod':
        return PaymentMethod.cod;
      case 'card':
        return PaymentMethod.card;
      case 'upi':
        return PaymentMethod.upi;
      case 'netbanking':
        return PaymentMethod.netbanking;
      case 'wallet':
        return PaymentMethod.wallet;
      default:
        return PaymentMethod.razorpay;
    }
  }
}
