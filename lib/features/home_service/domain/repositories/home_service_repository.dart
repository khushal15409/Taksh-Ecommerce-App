import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/courier_booking.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/courier_delivery_partner.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/courier_quote.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/general_service_booking.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/home_service.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/service_inquiry.dart';

/// Repository contract for the Home Service feature.
abstract class HomeServiceRepository {
  /// Fetches all available home services.
  ResultFuture<List<HomeService>> getServices();

  /// Fetches the delivery partners available for courier bookings.
  ResultFuture<List<CourierDeliveryPartner>> getCourierDeliveryPartners();

  /// Computes courier quotes for the current parcel dimensions and weight.
  ResultFuture<CourierQuote> getCourierQuote({
    required double weightGrams,
    required double dimensionLength,
    required double dimensionHeight,
    required double dimensionWidth,
    required String dimensionUnit,
  });

  /// Creates a courier booking.
  ResultFuture<CourierBooking> createCourierBooking({
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

  /// Creates an electrician, plumber, or salon booking.
  ResultFuture<GeneralServiceBooking> createGeneralServiceBooking({
    required String serviceSlug,
    required String customerName,
    required String customerMobile,
    required String fullAddress,
    required String pincode,
    required String serviceDescription,
    String? customerNotes,
  });

  /// Fetches the order / inquiry history for the current user.
  ResultFuture<List<ServiceInquiry>> getServiceInquiryHistory({
    int? serviceId,
    String? status,
    String? paymentStatus,
    int perPage = 15,
  });
}
