import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/repositories/address_repository.dart';

/// Use case to delete an address
class DeleteAddress extends UseCaseVoid<String> {
  final AddressRepository _repository;

  const DeleteAddress(this._repository);

  @override
  ResultVoid call(String params) => _repository.deleteAddress(params);
}
