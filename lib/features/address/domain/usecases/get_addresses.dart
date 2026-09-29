import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/domain/repositories/address_repository.dart';

/// Use case to get all addresses for the current user
class GetAddresses extends UseCaseNoParams<List<Address>> {
  final AddressRepository _repository;

  const GetAddresses(this._repository);

  @override
  ResultFuture<List<Address>> call() => _repository.getAddresses();
}
