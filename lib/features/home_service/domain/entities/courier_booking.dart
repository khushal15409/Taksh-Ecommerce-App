import 'package:equatable/equatable.dart';

/// Result returned after creating a courier booking.
class CourierBooking extends Equatable {
  final int bookingId;
  final String bookingNumber;
  final int actualWeightGrams;
  final int volumetricWeightGrams;
  final int chargeableWeightGrams;
  final String chargeableWeightSource;
  final int courierDeliveryPartnerId;
  final String partnerName;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final String? itemPhotoPath;

  const CourierBooking({
    required this.bookingId,
    required this.bookingNumber,
    required this.actualWeightGrams,
    required this.volumetricWeightGrams,
    required this.chargeableWeightGrams,
    required this.chargeableWeightSource,
    required this.courierDeliveryPartnerId,
    required this.partnerName,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    this.itemPhotoPath,
  });

  bool get isVolumetricChargeableWeight =>
      chargeableWeightSource.toLowerCase() == 'volumetric';

  @override
  List<Object?> get props => [
        bookingId,
        bookingNumber,
        actualWeightGrams,
        volumetricWeightGrams,
        chargeableWeightGrams,
        chargeableWeightSource,
        courierDeliveryPartnerId,
        partnerName,
        totalAmount,
        status,
        paymentStatus,
        itemPhotoPath,
      ];
}