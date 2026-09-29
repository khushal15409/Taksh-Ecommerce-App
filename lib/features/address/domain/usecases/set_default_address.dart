import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/domain/repositories/address_repository.dart';

/// Use case to set an address as default
class SetDefaultAddress extends UseCase<Address, String> {
  final AddressRepository _repository;

  const SetDefaultAddress(this._repository);

  @override
  ResultFuture<Address> call(String params) => _repository.setDefaultAddress(params);
}
