import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/wallet_summary.dart';
import 'package:taksh_e_commerce/features/wallet/domain/repositories/wallet_repository.dart';

/// Use case for fetching wallet summary
class GetWalletSummary extends UseCaseNoParams<WalletSummary> {
  final WalletRepository _repository;

  const GetWalletSummary(this._repository);

  @override
  ResultFuture<WalletSummary> call() {
    return _repository.getWalletSummary();
  }
}
