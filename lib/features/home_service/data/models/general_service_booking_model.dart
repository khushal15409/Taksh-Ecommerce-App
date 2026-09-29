import 'package:taksh_e_commerce/features/home_service/domain/entities/general_service_booking.dart';

int _bookingAsInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _bookingAsString(dynamic value) {
  if (value == null) {
    return '';
  }

  return value.toString().trim();
}

class GeneralServiceBookingModel extends GeneralServiceBooking {
  const GeneralServiceBookingModel({
    required super.bookingId,
    required super.bookingNumber,
    required super.status,
    required super.message,
  });

  factory GeneralServiceBookingModel.fromJson(Map<String, dynamic> json) {
    return GeneralServiceBookingModel(
      bookingId: _bookingAsInt(json['booking_id']),
      bookingNumber: _bookingAsString(json['booking_number']),
      status: _bookingAsString(json['status']),
      message: _bookingAsString(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'booking_number': bookingNumber,
      'status': status,
      'message': message,
    };
  }
}
