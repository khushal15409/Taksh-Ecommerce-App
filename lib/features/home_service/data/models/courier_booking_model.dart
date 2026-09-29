import 'package:taksh_e_commerce/features/home_service/domain/entities/courier_booking.dart';

int _bookingAsInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _bookingAsDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

String _bookingAsString(dynamic value) {
  if (value == null) {
    return '';
  }

  return value.toString().trim();
}

String? _bookingAsNullableString(dynamic value) {
  final normalizedValue = _bookingAsString(value);
  return normalizedValue.isEmpty ? null : normalizedValue;
}

class CourierBookingModel extends CourierBooking {
  const CourierBookingModel({
    required super.bookingId,
    required super.bookingNumber,
    required super.actualWeightGrams,
    required super.volumetricWeightGrams,
    required super.chargeableWeightGrams,
    required super.chargeableWeightSource,
    required super.courierDeliveryPartnerId,
    required super.partnerName,
    required super.totalAmount,
    required super.status,
    required super.paymentStatus,
    super.itemPhotoPath,
  });

  factory CourierBookingModel.fromJson(Map<String, dynamic> json) {
    return CourierBookingModel(
      bookingId: _bookingAsInt(json['booking_id']),
      bookingNumber: _bookingAsString(json['booking_number']),
      actualWeightGrams: _bookingAsInt(json['actual_weight_grams']),
      volumetricWeightGrams: _bookingAsInt(json['volumetric_weight_grams']),
      chargeableWeightGrams: _bookingAsInt(json['chargeable_weight_grams']),
      chargeableWeightSource: _bookingAsString(
        json['chargeable_weight_source'],
      ),
      courierDeliveryPartnerId: _bookingAsInt(
        json['courier_delivery_partner_id'],
      ),
      partnerName: _bookingAsString(json['partner_name']),
      totalAmount: _bookingAsDouble(json['total_amount']),
      status: _bookingAsString(json['status']),
      paymentStatus: _bookingAsString(json['payment_status']),
      itemPhotoPath: _bookingAsNullableString(json['item_photo_path']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'booking_number': bookingNumber,
      'actual_weight_grams': actualWeightGrams,
      'volumetric_weight_grams': volumetricWeightGrams,
      'chargeable_weight_grams': chargeableWeightGrams,
      'chargeable_weight_source': chargeableWeightSource,
      'courier_delivery_partner_id': courierDeliveryPartnerId,
      'partner_name': partnerName,
      'total_amount': totalAmount,
      'status': status,
      'payment_status': paymentStatus,
      'item_photo_path': itemPhotoPath,
    };
  }
}