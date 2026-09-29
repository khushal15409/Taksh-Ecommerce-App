import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/courier_booking.dart';
import 'package:taksh_e_commerce/features/home_service/domain/repositories/home_service_repository.dart';

class CreateCourierBooking
    implements UseCase<CourierBooking, CreateCourierBookingParams> {
  final HomeServiceRepository repository;

  const CreateCourierBooking(this.repository);

  @override
  ResultFuture<CourierBooking> call(CreateCourierBookingParams params) async {
    return repository.createCourierBooking(
      customerName: params.customerName,
      customerMobile: params.customerMobile,
      pickupAddress: params.pickupAddress,
      pickupPincode: params.pickupPincode,
      deliveryName: params.deliveryName,
      deliveryMobile: params.deliveryMobile,
      deliveryAddress: params.deliveryAddress,
      deliveryPincode: params.deliveryPincode,
      productDetails: params.productDetails,
      packagingDetails: params.packagingDetails,
      weightGrams: params.weightGrams,
      dimensionLength: params.dimensionLength,
      dimensionHeight: params.dimensionHeight,
      dimensionWidth: params.dimensionWidth,
      dimensionUnit: params.dimensionUnit,
      courierDeliveryPartnerId: params.courierDeliveryPartnerId,
      customerNotes: params.customerNotes,
      itemPhotoPath: params.itemPhotoPath,
    );
  }
}

class CreateCourierBookingParams extends Equatable {
  final String customerName;
  final String customerMobile;
  final String pickupAddress;
  final String pickupPincode;
  final String deliveryName;
  final String deliveryMobile;
  final String deliveryAddress;
  final String deliveryPincode;
  final String productDetails;
  final String packagingDetails;
  final double weightGrams;
  final double dimensionLength;
  final double dimensionHeight;
  final double dimensionWidth;
  final String dimensionUnit;
  final int courierDeliveryPartnerId;
  final String? customerNotes;
  final String? itemPhotoPath;

  const CreateCourierBookingParams({
    required this.customerName,
    required this.customerMobile,
    required this.pickupAddress,
    required this.pickupPincode,
    required this.deliveryName,
    required this.deliveryMobile,
    required this.deliveryAddress,
    required this.deliveryPincode,
    required this.productDetails,
    required this.packagingDetails,
    required this.weightGrams,
    required this.dimensionLength,
    required this.dimensionHeight,
    required this.dimensionWidth,
    required this.dimensionUnit,
    required this.courierDeliveryPartnerId,
    this.customerNotes,
    this.itemPhotoPath,
  });

  @override
  List<Object?> get props => [
        customerName,
        customerMobile,
        pickupAddress,
        pickupPincode,
        deliveryName,
        deliveryMobile,
        deliveryAddress,
        deliveryPincode,
        productDetails,
        packagingDetails,
        weightGrams,
        dimensionLength,
        dimensionHeight,
        dimensionWidth,
        dimensionUnit,
        courierDeliveryPartnerId,
        customerNotes,
        itemPhotoPath,
      ];
}