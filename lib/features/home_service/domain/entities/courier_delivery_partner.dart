import 'package:equatable/equatable.dart';

/// Delivery partner option available for courier bookings.
class CourierDeliveryPartner extends Equatable {
  final int id;
  final String name;
  final String slug;
  final double baseCharge;
  final double chargePerKg;

  const CourierDeliveryPartner({
    required this.id,
    required this.name,
    required this.slug,
    required this.baseCharge,
    required this.chargePerKg,
  });

  double estimateAmount({required double weightGrams}) {
    final normalizedWeightGrams = weightGrams.isFinite ? weightGrams : 0;
    final safeWeightGrams = normalizedWeightGrams < 0 ? 0 : normalizedWeightGrams;
    final weightInKg = safeWeightGrams / 1000;
    return baseCharge + (weightInKg * chargePerKg);
  }

  @override
  List<Object?> get props => [id, name, slug, baseCharge, chargePerKg];
}