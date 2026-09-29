import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/create_courier_booking.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/create_general_service_booking.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/get_courier_delivery_partners.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/get_courier_quote.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/get_service_inquiry_history.dart';
import 'package:taksh_e_commerce/features/home_service/domain/usecases/get_services.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/cubit/home_service_state.dart';

/// Cubit that manages the home service feature state.
class HomeServiceCubit extends Cubit<HomeServiceState> {
  final GetServices _getServices;
  final GetCourierDeliveryPartners _getCourierDeliveryPartners;
  final GetCourierQuote _getCourierQuote;
  final CreateCourierBooking _createCourierBooking;
  final CreateGeneralServiceBooking _createGeneralServiceBooking;
  final GetServiceInquiryHistory _getServiceInquiryHistory;

  final _log = loggerWithContext({
    'feature': 'home_service',
    'class': 'HomeServiceCubit',
  });

  HomeServiceCubit({
    required GetServices getServices,
    required GetCourierDeliveryPartners getCourierDeliveryPartners,
    required GetCourierQuote getCourierQuote,
    required CreateCourierBooking createCourierBooking,
    required CreateGeneralServiceBooking createGeneralServiceBooking,
    required GetServiceInquiryHistory getServiceInquiryHistory,
  }) : _getServices = getServices,
       _getCourierDeliveryPartners = getCourierDeliveryPartners,
       _getCourierQuote = getCourierQuote,
       _createCourierBooking = createCourierBooking,
       _createGeneralServiceBooking = createGeneralServiceBooking,
       _getServiceInquiryHistory = getServiceInquiryHistory,
       super(const HomeServiceInitial());

  /// Fetch all available services.
  Future<void> fetchServices() async {
    _log.infoWithContext('Fetching services', {'action': 'fetchServices'});
    emit(const HomeServiceLoading());

    final result = await _getServices();

    if (isClosed) return;

    result.fold(
      (failure) {
        _log.warnWithContext('Failed to fetch services', {
          'message': failure.message,
        });
        emit(HomeServiceError(failure.message));
      },
      (services) {
        _log.infoWithContext('Services fetched', {'count': services.length});
        emit(HomeServiceLoaded(services));
      },
    );
  }

  /// Fetch courier delivery partners.
  Future<void> fetchCourierDeliveryPartners() async {
    _log.infoWithContext('Fetching courier delivery partners', {
      'action': 'fetchCourierDeliveryPartners',
    });
    emit(const HomeServiceCourierPartnersLoading());

    final result = await _getCourierDeliveryPartners();

    if (isClosed) return;

    result.fold(
      (failure) {
        _log.warnWithContext('Failed to fetch courier delivery partners', {
          'message': failure.message,
        });
        emit(HomeServiceCourierPartnersError(failure.message));
      },
      (partners) {
        _log.infoWithContext('Courier delivery partners fetched', {
          'count': partners.length,
        });
        emit(HomeServiceCourierPartnersLoaded(partners));
      },
    );
  }

  /// Fetch courier quotes for the current parcel.
  Future<void> fetchCourierQuote(GetCourierQuoteParams params) async {
    _log.infoWithContext('Fetching courier quote', {
      'action': 'fetchCourierQuote',
      'weight_grams': params.weightGrams,
      'dimension_unit': params.dimensionUnit,
    });
    emit(const HomeServiceCourierQuoteLoading());

    final result = await _getCourierQuote(params);

    if (isClosed) return;

    result.fold(
      (failure) {
        _log.warnWithContext('Failed to fetch courier quote', {
          'message': failure.message,
        });
        emit(HomeServiceCourierQuoteError(failure.message));
      },
      (quote) {
        _log.infoWithContext('Courier quote fetched', {
          'quotes_count': quote.quotes.length,
          'chargeable_weight_grams': quote.chargeableWeightGrams,
        });
        emit(HomeServiceCourierQuoteLoaded(quote));
      },
    );
  }

  /// Submit a courier booking.
  Future<void> submitCourierBooking(CreateCourierBookingParams params) async {
    _log.infoWithContext('Submitting courier booking', {
      'action': 'submitCourierBooking',
      'courier_delivery_partner_id': params.courierDeliveryPartnerId,
    });
    emit(const HomeServiceCourierBookingSubmitting());

    final result = await _createCourierBooking(params);

    if (isClosed) return;

    result.fold(
      (failure) {
        _log.warnWithContext('Failed to submit courier booking', {
          'message': failure.message,
        });
        emit(HomeServiceCourierBookingError(failure.message));
      },
      (booking) {
        _log.infoWithContext('Courier booking submitted', {
          'booking_id': booking.bookingId,
          'booking_number': booking.bookingNumber,
        });
        emit(HomeServiceCourierBookingSuccess(booking));
      },
    );
  }

  /// Submit an electrician, plumber, or salon booking.
  Future<void> submitGeneralServiceBooking(
    CreateGeneralServiceBookingParams params,
  ) async {
    _log.infoWithContext('Submitting general service booking', {
      'action': 'submitGeneralServiceBooking',
      'service_slug': params.serviceSlug,
    });
    emit(const HomeServiceGeneralBookingSubmitting());

    final result = await _createGeneralServiceBooking(params);

    if (isClosed) return;

    result.fold(
      (failure) {
        _log.warnWithContext('Failed to submit general service booking', {
          'message': failure.message,
        });
        emit(HomeServiceGeneralBookingError(failure.message));
      },
      (booking) {
        _log.infoWithContext('General service booking submitted', {
          'booking_id': booking.bookingId,
          'booking_number': booking.bookingNumber,
        });
        emit(HomeServiceGeneralBookingSuccess(booking));
      },
    );
  }

  /// Fetch service inquiry / order history.
  Future<void> fetchHistory({
    int? serviceId,
    String? status,
    String? paymentStatus,
    int perPage = 15,
  }) async {
    _log.infoWithContext('Fetching service history', {
      'action': 'fetchHistory',
      'service_id': serviceId,
      'status': status,
      'payment_status': paymentStatus,
      'per_page': perPage,
    });
    emit(const HomeServiceHistoryLoading());

    final result = await _getServiceInquiryHistory(
      GetServiceInquiryHistoryParams(
        serviceId: serviceId,
        status: status,
        paymentStatus: paymentStatus,
        perPage: perPage,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        _log.warnWithContext('Failed to fetch service history', {
          'message': failure.message,
        });
        emit(HomeServiceHistoryError(failure.message));
      },
      (orders) {
        _log.infoWithContext('Service history fetched', {
          'count': orders.length,
        });
        emit(HomeServiceHistoryLoaded(orders));
      },
    );
  }
}
