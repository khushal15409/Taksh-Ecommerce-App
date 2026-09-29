import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/home_service/data/models/courier_booking_model.dart';
import 'package:taksh_e_commerce/features/home_service/data/models/courier_delivery_partner_model.dart';
import 'package:taksh_e_commerce/features/home_service/data/models/courier_quote_model.dart';
import 'package:taksh_e_commerce/features/home_service/data/models/general_service_booking_model.dart';
import 'package:taksh_e_commerce/features/home_service/data/models/home_service_model.dart';
import 'package:taksh_e_commerce/features/home_service/data/models/service_inquiry_model.dart';

/// Remote data source contract for home service feature.
abstract class HomeServiceRemoteDataSource {
  /// Fetch all available services.
  Future<List<HomeServiceModel>> getServices();

  /// Fetch courier delivery partners.
  Future<List<CourierDeliveryPartnerModel>> getCourierDeliveryPartners();

  /// Compute courier quotes without creating a booking.
  Future<CourierQuoteModel> getCourierQuote({
    required double weightGrams,
    required double dimensionLength,
    required double dimensionHeight,
    required double dimensionWidth,
    required String dimensionUnit,
  });

  /// Create a courier booking.
  Future<CourierBookingModel> createCourierBooking({
    required String customerName,
    required String customerMobile,
    required String pickupAddress,
    required String pickupPincode,
    required String deliveryName,
    required String deliveryMobile,
    required String deliveryAddress,
    required String deliveryPincode,
    required String productDetails,
    required String packagingDetails,
    required double weightGrams,
    required double dimensionLength,
    required double dimensionHeight,
    required double dimensionWidth,
    required String dimensionUnit,
    required int courierDeliveryPartnerId,
    String? customerNotes,
    String? itemPhotoPath,
  });

  /// Create an electrician, plumber, or salon booking.
  Future<GeneralServiceBookingModel> createGeneralServiceBooking({
    required String serviceSlug,
    required String customerName,
    required String customerMobile,
    required String fullAddress,
    required String pincode,
    required String serviceDescription,
    String? customerNotes,
  });

  /// Fetch service inquiry / order history.
  Future<List<ServiceInquiryModel>> getServiceInquiryHistory({
    int? serviceId,
    String? status,
    String? paymentStatus,
    int perPage = 15,
  });
}

/// Implementation of [HomeServiceRemoteDataSource].
class HomeServiceRemoteDataSourceImpl implements HomeServiceRemoteDataSource {
  final ApiClient _apiClient;

  HomeServiceRemoteDataSourceImpl(this._apiClient);

  String _generalServiceBookingEndpoint(String serviceSlug) {
    switch (serviceSlug.trim().toLowerCase()) {
      case 'electrician':
        return ApiConstants.electricianBookings;
      case 'plumber':
        return ApiConstants.plumberBookings;
      case 'salon':
      case 'salon-parlor':
        return ApiConstants.salonBookings;
      default:
        throw ServerException('Unsupported service type: $serviceSlug');
    }
  }

  @override
  Future<List<HomeServiceModel>> getServices() async {
    final log = loggerWithContext({
      'feature': 'home_service',
      'class': 'HomeServiceRemoteDataSourceImpl',
      'method': 'getServices',
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext('Fetching available services', {});

      final response = await _apiClient.get(ApiConstants.services);

      final data = response.data as Map<String, dynamic>;
      final success = data['success'] as bool? ?? false;

      if (!success) {
        throw ServerException(
          data['message'] as String? ?? 'Failed to fetch services',
        );
      }

      final servicesList = data['data'] as List<dynamic>;
      final services = servicesList
          .map((e) => HomeServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();

      log.infoWithContext('Services fetched successfully', {
        'count': services.length,
        'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
      });

      return services;
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'DioException fetching services',
        {'message': e.message},
        e,
        stackTrace,
      );
      throw ServerException(
        e.response?.data?['message']?.toString() ?? 'Failed to fetch services',
        e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      if (e is ServerException) rethrow;
      log.errorWithContext(
        'Unexpected error fetching services',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      throw ServerException('Failed to fetch services: $e');
    }
  }

  @override
  Future<List<CourierDeliveryPartnerModel>> getCourierDeliveryPartners() async {
    final log = loggerWithContext({
      'feature': 'home_service',
      'class': 'HomeServiceRemoteDataSourceImpl',
      'method': 'getCourierDeliveryPartners',
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext('Fetching courier delivery partners', {});

      final response = await _apiClient.get(
        ApiConstants.courierDeliveryPartners,
      );

      final data = response.data as Map<String, dynamic>;
      final success = data['success'] as bool? ?? false;

      if (!success) {
        throw ServerException(
          data['message'] as String? ??
              'Failed to fetch courier delivery partners',
        );
      }

      final payload = data['data'] as Map<String, dynamic>? ?? const {};
      final partnersList = payload['partners'] as List<dynamic>? ?? const [];
      final partners = partnersList
          .map(
            (partner) => CourierDeliveryPartnerModel.fromJson(
              Map<String, dynamic>.from(partner as Map),
            ),
          )
          .toList(growable: false);

      log.infoWithContext('Courier delivery partners fetched successfully', {
        'count': partners.length,
        'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
      });

      return partners;
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'DioException fetching courier delivery partners',
        {'message': e.message},
        e,
        stackTrace,
      );
      throw ServerException(
        e.response?.data?['message']?.toString() ??
            'Failed to fetch courier delivery partners',
        e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      if (e is ServerException) rethrow;
      log.errorWithContext(
        'Unexpected error fetching courier delivery partners',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      throw ServerException('Failed to fetch courier delivery partners: $e');
    }
  }

  @override
  Future<CourierQuoteModel> getCourierQuote({
    required double weightGrams,
    required double dimensionLength,
    required double dimensionHeight,
    required double dimensionWidth,
    required String dimensionUnit,
  }) async {
    final log = loggerWithContext({
      'feature': 'home_service',
      'class': 'HomeServiceRemoteDataSourceImpl',
      'method': 'getCourierQuote',
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext('Fetching courier quote', {
        'weight_grams': weightGrams,
        'dimension_unit': dimensionUnit,
      });

      final formData = FormData.fromMap({
        'weight_grams': weightGrams.round().toString(),
        'dimension_unit': dimensionUnit,
        'length': dimensionLength.toString(),
        'width': dimensionWidth.toString(),
        'height': dimensionHeight.toString(),
      });

      final response = await _apiClient.post(
        ApiConstants.courierQuote,
        data: formData,
      );

      final data = response.data as Map<String, dynamic>;
      final success = data['success'] as bool? ?? false;

      if (!success) {
        throw ServerException(
          data['message'] as String? ?? 'Failed to compute courier quote',
        );
      }

      final quote = CourierQuoteModel.fromJson(
        Map<String, dynamic>.from(data['data'] as Map),
      );

      log.infoWithContext('Courier quote fetched successfully', {
        'quotes_count': quote.quotes.length,
        'chargeable_weight_grams': quote.chargeableWeightGrams,
        'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
      });

      return quote;
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'DioException fetching courier quote',
        {'message': e.message},
        e,
        stackTrace,
      );
      throw ServerException(
        e.response?.data?['message']?.toString() ??
            'Failed to compute courier quote',
        e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      if (e is ServerException) rethrow;
      log.errorWithContext(
        'Unexpected error fetching courier quote',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      throw ServerException('Failed to compute courier quote: $e');
    }
  }

  @override
  Future<CourierBookingModel> createCourierBooking({
    required String customerName,
    required String customerMobile,
    required String pickupAddress,
    required String pickupPincode,
    required String deliveryName,
    required String deliveryMobile,
    required String deliveryAddress,
    required String deliveryPincode,
    required String productDetails,
    required String packagingDetails,
    required double weightGrams,
    required double dimensionLength,
    required double dimensionHeight,
    required double dimensionWidth,
    required String dimensionUnit,
    required int courierDeliveryPartnerId,
    String? customerNotes,
    String? itemPhotoPath,
  }) async {
    final log = loggerWithContext({
      'feature': 'home_service',
      'class': 'HomeServiceRemoteDataSourceImpl',
      'method': 'createCourierBooking',
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext('Creating courier booking', {
        'pickup_pincode': pickupPincode,
        'delivery_pincode': deliveryPincode,
        'courier_delivery_partner_id': courierDeliveryPartnerId,
      });

      final formMap = <String, dynamic>{
        'customer_name': customerName,
        'customer_mobile': customerMobile,
        'pickup_address': pickupAddress,
        'pickup_pincode': pickupPincode,
        'delivery_name': deliveryName,
        'delivery_mobile': deliveryMobile,
        'delivery_address': deliveryAddress,
        'delivery_pincode': deliveryPincode,
        'product_details': productDetails,
        'packaging_details': packagingDetails,
        'weight_grams': weightGrams.round().toString(),
        'dimension_unit': dimensionUnit,
        'length': dimensionLength.toString(),
        'width': dimensionWidth.toString(),
        'height': dimensionHeight.toString(),
        'courier_delivery_partner_id': courierDeliveryPartnerId.toString(),
      };

      if (customerNotes != null && customerNotes.isNotEmpty) {
        formMap['customer_notes'] = customerNotes;
      }

      if (itemPhotoPath != null && itemPhotoPath.isNotEmpty) {
        formMap['item_photo'] = await MultipartFile.fromFile(
          itemPhotoPath,
          filename: itemPhotoPath.split('/').last,
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await _apiClient.post(
        ApiConstants.courierBookings,
        data: formData,
      );

      final data = response.data as Map<String, dynamic>;
      final success = data['success'] as bool? ?? false;

      if (!success) {
        throw ServerException(
          data['message'] as String? ?? 'Failed to create courier booking',
        );
      }

      final booking = CourierBookingModel.fromJson(
        Map<String, dynamic>.from(data['data'] as Map),
      );

      log.infoWithContext('Courier booking created successfully', {
        'booking_id': booking.bookingId,
        'booking_number': booking.bookingNumber,
        'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
      });

      return booking;
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'DioException creating courier booking',
        {'message': e.message},
        e,
        stackTrace,
      );
      throw ServerException(
        e.response?.data?['message']?.toString() ??
            'Failed to create courier booking',
        e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      if (e is ServerException) rethrow;
      log.errorWithContext(
        'Unexpected error creating courier booking',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      throw ServerException('Failed to create courier booking: $e');
    }
  }

  @override
  Future<GeneralServiceBookingModel> createGeneralServiceBooking({
    required String serviceSlug,
    required String customerName,
    required String customerMobile,
    required String fullAddress,
    required String pincode,
    required String serviceDescription,
    String? customerNotes,
  }) async {
    final log = loggerWithContext({
      'feature': 'home_service',
      'class': 'HomeServiceRemoteDataSourceImpl',
      'method': 'createGeneralServiceBooking',
    });
    final startTime = DateTime.now();

    try {
      final endpoint = _generalServiceBookingEndpoint(serviceSlug);

      log.infoWithContext('Creating general service booking', {
        'service_slug': serviceSlug,
        'endpoint': endpoint,
        'pincode': pincode,
      });

      final formMap = <String, dynamic>{
        'customer_name': customerName,
        'customer_mobile': customerMobile,
        'full_address': fullAddress,
        'pincode': pincode,
        'service_description': serviceDescription,
      };

      final normalizedCustomerNotes = customerNotes?.trim();
      if (normalizedCustomerNotes != null &&
          normalizedCustomerNotes.isNotEmpty) {
        formMap['customer_notes'] = normalizedCustomerNotes;
      }

      final formData = FormData.fromMap(formMap);

      final response = await _apiClient.post(endpoint, data: formData);

      final data = response.data as Map<String, dynamic>;
      final success = data['success'] as bool? ?? false;

      if (!success) {
        throw ServerException(
          data['message'] as String? ?? 'Failed to create service booking',
        );
      }

      final booking = GeneralServiceBookingModel.fromJson({
        ...Map<String, dynamic>.from(data['data'] as Map),
        'message': data['message'],
      });

      log.infoWithContext('General service booking created successfully', {
        'booking_id': booking.bookingId,
        'booking_number': booking.bookingNumber,
        'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
      });

      return booking;
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'DioException creating general service booking',
        {'message': e.message},
        e,
        stackTrace,
      );
      throw ServerException(
        e.response?.data?['message']?.toString() ??
            'Failed to create service booking',
        e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      if (e is ServerException) rethrow;
      log.errorWithContext(
        'Unexpected error creating general service booking',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      throw ServerException('Failed to create service booking: $e');
    }
  }

  @override
  Future<List<ServiceInquiryModel>> getServiceInquiryHistory({
    int? serviceId,
    String? status,
    String? paymentStatus,
    int perPage = 15,
  }) async {
    final log = loggerWithContext({
      'feature': 'home_service',
      'class': 'HomeServiceRemoteDataSourceImpl',
      'method': 'getServiceInquiryHistory',
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext('Fetching service inquiry history', {
        'service_id': serviceId,
        'status': status,
        'payment_status': paymentStatus,
        'per_page': perPage,
      });

      final queryParameters = <String, dynamic>{'per_page': perPage.toString()};

      if (serviceId != null) {
        queryParameters['service_id'] = serviceId.toString();
      }

      final normalizedStatus = status?.trim();
      if (normalizedStatus != null && normalizedStatus.isNotEmpty) {
        queryParameters['status'] = normalizedStatus;
      }

      final normalizedPaymentStatus = paymentStatus?.trim();
      if (normalizedPaymentStatus != null &&
          normalizedPaymentStatus.isNotEmpty) {
        queryParameters['payment_status'] = normalizedPaymentStatus;
      }

      final response = await _apiClient.get(
        ApiConstants.serviceOrders,
        queryParameters: queryParameters,
      );

      final data = response.data as Map<String, dynamic>;
      final success = data['success'] as bool? ?? false;

      if (!success) {
        throw ServerException(
          data['message'] as String? ?? 'Failed to fetch service orders',
        );
      }

      final ordersData = data['data'] as Map<String, dynamic>;
      final ordersList = ordersData['orders'] as List<dynamic>;
      final orders = ordersList
          .map((e) => ServiceInquiryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      log.infoWithContext('Service inquiry history fetched successfully', {
        'count': orders.length,
        'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
      });

      return orders;
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'DioException fetching service inquiry history',
        {'message': e.message},
        e,
        stackTrace,
      );
      throw ServerException(
        e.response?.data?['message']?.toString() ??
            'Failed to fetch service orders',
        e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      if (e is ServerException) rethrow;
      log.errorWithContext(
        'Unexpected error fetching service inquiry history',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      throw ServerException('Failed to fetch service orders: $e');
    }
  }
}
