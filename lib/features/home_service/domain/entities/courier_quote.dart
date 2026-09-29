import 'package:equatable/equatable.dart';

/// One courier partner quote returned from the quote API.
class CourierQuoteOption extends Equatable {
  final int courierDeliveryPartnerId;
  final String name;
  final String slug;
  final double totalAmount;

  const CourierQuoteOption({
    required this.courierDeliveryPartnerId,
    required this.name,
    required this.slug,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [
    courierDeliveryPartnerId,
    name,
    slug,
    totalAmount,
  ];
}

/// Quote summary returned before a courier booking is created.
class CourierQuote extends Equatable {
  final int actualWeightGrams;
  final int volumetricWeightGrams;
  final int chargeableWeightGrams;
  final String chargeableWeightSource;
  final List<CourierQuoteOption> quotes;

  const CourierQuote({
    required this.actualWeightGrams,
    required this.volumetricWeightGrams,
    required this.chargeableWeightGrams,
    required this.chargeableWeightSource,
    required this.quotes,
  });

  bool get isVolumetricChargeableWeight {
    return chargeableWeightSource.toLowerCase() == 'volumetric';
  }

  @override
  List<Object?> get props => [
    actualWeightGrams,
    volumetricWeightGrams,
    chargeableWeightGrams,
    chargeableWeightSource,
    quotes,
  ];
}
