import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/general_service_booking.dart';
import 'package:taksh_e_commerce/features/home_service/domain/repositories/home_service_repository.dart';

class CreateGeneralServiceBooking
    implements
        UseCase<GeneralServiceBooking, CreateGeneralServiceBookingParams> {
  final HomeServiceRepository repository;

  const CreateGeneralServiceBooking(this.repository);

  @override
  ResultFuture<GeneralServiceBooking> call(
    CreateGeneralServiceBookingParams params,
  ) async {
    return repository.createGeneralServiceBooking(
      serviceSlug: params.serviceSlug,
      customerName: params.customerName,
      customerMobile: params.customerMobile,
      fullAddress: params.fullAddress,
      pincode: params.pincode,
      serviceDescription: params.serviceDescription,
      customerNotes: params.customerNotes,
    );
  }
}

class CreateGeneralServiceBookingParams extends Equatable {
  final String serviceSlug;
  final String customerName;
  final String customerMobile;
  final String fullAddress;
  final String pincode;
  final String serviceDescription;
  final String? customerNotes;

  const CreateGeneralServiceBookingParams({
    required this.serviceSlug,
    required this.customerName,
    required this.customerMobile,
    required this.fullAddress,
    required this.pincode,
    required this.serviceDescription,
    this.customerNotes,
  });

  @override
  List<Object?> get props => [
    serviceSlug,
    customerName,
    customerMobile,
    fullAddress,
    pincode,
    serviceDescription,
    customerNotes,
  ];
}
