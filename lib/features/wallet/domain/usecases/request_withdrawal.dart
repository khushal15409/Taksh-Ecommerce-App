import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/withdrawal_response.dart';
import 'package:taksh_e_commerce/features/wallet/domain/repositories/wallet_repository.dart';

/// Use case for requesting a wallet withdrawal
class RequestWithdrawal extends UseCase<WithdrawalResponse, WithdrawalParams> {
  final WalletRepository _repository;

  const RequestWithdrawal(this._repository);

  @override
  ResultFuture<WithdrawalResponse> call(WithdrawalParams params) {
    return _repository.requestWithdrawal(params);
  }
}
