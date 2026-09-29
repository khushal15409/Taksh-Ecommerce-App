import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/bank_account.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/wallet_summary.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/withdrawal_response.dart';

/// Repository contract for wallet operations
abstract class WalletRepository {
  /// Fetch wallet summary (balance, pending, available, reward info)
  ResultFuture<WalletSummary> getWalletSummary();

  /// Request a withdrawal of points to a bank account
  ResultFuture<WithdrawalResponse> requestWithdrawal(WithdrawalParams params);

  /// Fetch the list of user's bank accounts
  ResultFuture<List<BankAccount>> getBankAccounts();
}
