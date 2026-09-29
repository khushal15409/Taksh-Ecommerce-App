import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';
import 'package:taksh_e_commerce/features/address/domain/repositories/address_repository.dart';

/// Parameters for GetLocationFromLatLng use case
class LatLngParams extends Equatable {
  final double latitude;
  final double longitude;

  const LatLngParams({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

/// Use case to get location details from coordinates (reverse geocoding)
class GetLocationFromLatLng extends UseCase<Location, LatLngParams> {
  final AddressRepository _repository;

  const GetLocationFromLatLng(this._repository);

  @override
  ResultFuture<Location> call(LatLngParams params) {
    return _repository.getLocationFromLatLng(
      params.latitude,
      params.longitude,
    );
  }
}
