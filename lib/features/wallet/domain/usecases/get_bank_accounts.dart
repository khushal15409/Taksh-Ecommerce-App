import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/bank_account.dart';
import 'package:taksh_e_commerce/features/wallet/domain/repositories/wallet_repository.dart';

/// Use case for fetching the user's bank accounts
class GetBankAccounts extends UseCaseNoParams<List<BankAccount>> {
  final WalletRepository _repository;

  const GetBankAccounts(this._repository);

  @override
  ResultFuture<List<BankAccount>> call() {
    return _repository.getBankAccounts();
  }
}
