import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';
import 'package:taksh_e_commerce/features/address/domain/repositories/address_repository.dart';

/// Use case to get current device location
class GetCurrentLocation extends UseCaseNoParams<Location> {
  final AddressRepository _repository;

  const GetCurrentLocation(this._repository);

  @override
  ResultFuture<Location> call() => _repository.getCurrentLocation();
}
