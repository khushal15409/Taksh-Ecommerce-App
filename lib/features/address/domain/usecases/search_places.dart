import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';
import 'package:taksh_e_commerce/features/address/domain/repositories/address_repository.dart';

/// Use case to search for places using a query string
class SearchPlaces extends UseCase<List<Location>, String> {
  final AddressRepository _repository;

  const SearchPlaces(this._repository);

  @override
  ResultFuture<List<Location>> call(String params) => _repository.searchPlaces(params);
}
