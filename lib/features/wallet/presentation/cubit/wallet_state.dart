import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/bank_account.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/wallet_summary.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/withdrawal_response.dart';

/// Base class for all wallet states
abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded
class WalletInitial extends WalletState {
  const WalletInitial();
}

/// Loading state when fetching wallet data for the first time
class WalletLoading extends WalletState {
  const WalletLoading();
}

/// Wallet data loaded successfully
class WalletLoaded extends WalletState {
  final WalletSummary summary;
  final List<BankAccount> bankAccounts;

  const WalletLoaded({
    required this.summary,
    required this.bankAccounts,
  });

  @override
  List<Object?> get props => [summary, bankAccounts];
}

/// Withdrawal request is being submitted (preserves current wallet data)
class WalletWithdrawalInProgress extends WalletState {
  final WalletSummary summary;
  final List<BankAccount> bankAccounts;

  const WalletWithdrawalInProgress({
    required this.summary,
    required this.bankAccounts,
  });

  @override
  List<Object?> get props => [summary, bankAccounts];
}

/// Withdrawal request was submitted successfully
class WalletWithdrawalSuccess extends WalletState {
  final WithdrawalResponse withdrawal;
  final WalletSummary summary;
  final List<BankAccount> bankAccounts;

  const WalletWithdrawalSuccess({
    required this.withdrawal,
    required this.summary,
    required this.bankAccounts,
  });

  @override
  List<Object?> get props => [withdrawal, summary, bankAccounts];
}

/// Error state
class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}
