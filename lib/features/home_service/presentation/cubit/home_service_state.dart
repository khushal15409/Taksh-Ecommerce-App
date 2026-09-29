import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/courier_booking.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/courier_delivery_partner.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/courier_quote.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/general_service_booking.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/home_service.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/service_inquiry.dart';

/// States for the HomeService feature.
abstract class HomeServiceState extends Equatable {
  const HomeServiceState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class HomeServiceInitial extends HomeServiceState {
  const HomeServiceInitial();
}

/// Loading available services.
class HomeServiceLoading extends HomeServiceState {
  const HomeServiceLoading();
}

/// Services loaded successfully.
class HomeServiceLoaded extends HomeServiceState {
  final List<HomeService> services;

  const HomeServiceLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

/// Error loading services.
class HomeServiceError extends HomeServiceState {
  final String message;

  const HomeServiceError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Loading courier delivery partners.
class HomeServiceCourierPartnersLoading extends HomeServiceState {
  const HomeServiceCourierPartnersLoading();
}

/// Courier delivery partners loaded successfully.
class HomeServiceCourierPartnersLoaded extends HomeServiceState {
  final List<CourierDeliveryPartner> partners;

  const HomeServiceCourierPartnersLoaded(this.partners);

  @override
  List<Object?> get props => [partners];
}

/// Error loading courier delivery partners.
class HomeServiceCourierPartnersError extends HomeServiceState {
  final String message;

  const HomeServiceCourierPartnersError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Loading courier quote.
class HomeServiceCourierQuoteLoading extends HomeServiceState {
  const HomeServiceCourierQuoteLoading();
}

/// Courier quote loaded successfully.
class HomeServiceCourierQuoteLoaded extends HomeServiceState {
  final CourierQuote quote;

  const HomeServiceCourierQuoteLoaded(this.quote);

  @override
  List<Object?> get props => [quote];
}

/// Error loading courier quote.
class HomeServiceCourierQuoteError extends HomeServiceState {
  final String message;

  const HomeServiceCourierQuoteError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Creating a courier booking.
class HomeServiceCourierBookingSubmitting extends HomeServiceState {
  const HomeServiceCourierBookingSubmitting();
}

/// Courier booking created successfully.
class HomeServiceCourierBookingSuccess extends HomeServiceState {
  final CourierBooking booking;

  const HomeServiceCourierBookingSuccess(this.booking);

  @override
  List<Object?> get props => [booking];
}

/// Error creating courier booking.
class HomeServiceCourierBookingError extends HomeServiceState {
  final String message;

  const HomeServiceCourierBookingError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Creating an electrician, plumber, or salon booking.
class HomeServiceGeneralBookingSubmitting extends HomeServiceState {
  const HomeServiceGeneralBookingSubmitting();
}

/// General service booking created successfully.
class HomeServiceGeneralBookingSuccess extends HomeServiceState {
  final GeneralServiceBooking booking;

  const HomeServiceGeneralBookingSuccess(this.booking);

  @override
  List<Object?> get props => [booking];
}

/// Error creating a general service booking.
class HomeServiceGeneralBookingError extends HomeServiceState {
  final String message;

  const HomeServiceGeneralBookingError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Loading service inquiry history.
class HomeServiceHistoryLoading extends HomeServiceState {
  const HomeServiceHistoryLoading();
}

/// Service inquiry history loaded.
class HomeServiceHistoryLoaded extends HomeServiceState {
  final List<ServiceInquiry> orders;

  const HomeServiceHistoryLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

/// Error loading service inquiry history.
class HomeServiceHistoryError extends HomeServiceState {
  final String message;

  const HomeServiceHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
