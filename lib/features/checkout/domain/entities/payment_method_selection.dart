import 'package:equatable/equatable.dart';

/// Enum representing payment method types
enum PaymentMethodType {
  cod('cod', 'Cash on Delivery'),
  online('online', 'Pay Online');

  final String value;
  final String displayName;

  const PaymentMethodType(this.value, this.displayName);

  /// Get payment method from string value
  static PaymentMethodType fromValue(String value) {
    return PaymentMethodType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => PaymentMethodType.cod,
    );
  }
}

/// Entity representing selected payment method
class PaymentMethodSelection extends Equatable {
  final PaymentMethodType type;
  final String description;

  const PaymentMethodSelection({
    required this.type,
    required this.description,
  });

  /// COD payment method
  static const cod = PaymentMethodSelection(
    type: PaymentMethodType.cod,
    description: 'Pay with cash upon delivery',
  );

  /// Online payment method
  static const online = PaymentMethodSelection(
    type: PaymentMethodType.online,
    description: 'Pay online using Razorpay',
  );

  @override
  List<Object?> get props => [type, description];

  @override
  String toString() => 'PaymentMethodSelection(${type.value})';
}
