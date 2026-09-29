import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/bank_detail.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/bank_detail_repository.dart';

/// Use case for saving bank account details
class SaveBankDetail extends UseCase<BankDetail, BankDetailParams> {
  final BankDetailRepository _repository;

  const SaveBankDetail(this._repository);

  @override
  ResultFuture<BankDetail> call(BankDetailParams params) {
    return _repository.saveBankDetail(params);
  }
}
