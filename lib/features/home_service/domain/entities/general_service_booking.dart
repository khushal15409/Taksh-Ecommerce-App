import 'package:equatable/equatable.dart';

/// Result returned after creating an electrician, plumber, or salon booking.
class GeneralServiceBooking extends Equatable {
  final int bookingId;
  final String bookingNumber;
  final String status;
  final String message;

  const GeneralServiceBooking({
    required this.bookingId,
    required this.bookingNumber,
    required this.status,
    required this.message,
  });

  @override
  List<Object?> get props => [bookingId, bookingNumber, status, message];
}
