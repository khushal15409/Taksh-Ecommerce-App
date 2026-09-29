import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment_order.dart';

part 'payment_order_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PaymentOrderModel extends PaymentOrder {
  const PaymentOrderModel({
    required super.id,
    required super.razorpayOrderId,
    required super.amount,
    required super.currency,
    required super.receipt,
    required super.status,
    required super.attempts,
    required super.createdAt,
  });

  factory PaymentOrderModel.fromJson(DataMap json) =>
      _$PaymentOrderModelFromJson(json);

  DataMap toJson() => _$PaymentOrderModelToJson(this);

  /// Convert to entity
  PaymentOrder toEntity() {
    return PaymentOrder(
      id: id,
      razorpayOrderId: razorpayOrderId,
      amount: amount,
      currency: currency,
      receipt: receipt,
      status: status,
      attempts: attempts,
      createdAt: createdAt,
    );
  }
}
