import 'package:equatable/equatable.dart';

/// Represents an additional charge/discount line in cart and order payload.
class ExtraCharge extends Equatable {
  final String type;
  final String label;
  final int amount;
  final bool isDiscount;
  final int? sortOrder;

  const ExtraCharge({
    required this.type,
    required this.label,
    required this.amount,
    required this.isDiscount,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [type, label, amount, isDiscount, sortOrder];
}
