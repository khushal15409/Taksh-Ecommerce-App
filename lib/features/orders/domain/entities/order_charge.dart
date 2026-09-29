import 'package:equatable/equatable.dart';

/// Represents additional price lines associated with an order.
class OrderCharge extends Equatable {
  final String type;
  final String label;
  final String amount;
  final bool isDiscount;
  final int? sortOrder;

  const OrderCharge({
    required this.type,
    required this.label,
    required this.amount,
    required this.isDiscount,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [type, label, amount, isDiscount, sortOrder];
}
