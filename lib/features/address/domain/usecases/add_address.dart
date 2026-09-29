import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/domain/repositories/address_repository.dart';

/// Use case to add a new address
class AddAddress extends UseCase<Address, Address> {
  final AddressRepository _repository;

  const AddAddress(this._repository);

  @override
  ResultFuture<Address> call(Address params) => _repository.addAddress(params);
}
