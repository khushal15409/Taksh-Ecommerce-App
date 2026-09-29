import 'package:equatable/equatable.dart';

/// Entity representing price breakdown
class PriceBreakdown extends Equatable {
  final int itemTotal;
  final int deliveryCharges;
  final int cgst;
  final int sgst;
  final int discount;
  final int grandTotal;

  const PriceBreakdown({
    required this.itemTotal,
    required this.deliveryCharges,
    required this.cgst,
    required this.sgst,
    required this.discount,
    required this.grandTotal,
  });

  /// Total tax amount
  int get totalTax => cgst + sgst;

  /// Get item total in rupees
  double get itemTotalInRupees => itemTotal / 1;

  /// Get delivery charges in rupees
  double get deliveryChargesInRupees => deliveryCharges / 1;

  /// Get total tax in rupees
  double get totalTaxInRupees => totalTax / 1;

  /// Get discount in rupees
  double get discountInRupees => discount / 1;

  /// Get grand total in rupees
  double get grandTotalInRupees => grandTotal / 1;

  @override
  List<Object?> get props => [
        itemTotal,
        deliveryCharges,
        cgst,
        sgst,
        discount,
        grandTotal,
      ];

  @override
  String toString() {
    return 'PriceBreakdown(itemTotal: $itemTotal, delivery: $deliveryCharges, tax: $totalTax, grandTotal: $grandTotal)';
  }
}
