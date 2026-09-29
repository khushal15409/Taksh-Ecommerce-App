import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/bank_account.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/wallet_summary.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/withdrawal_response.dart';
import 'package:taksh_e_commerce/features/wallet/domain/usecases/get_bank_accounts.dart';
import 'package:taksh_e_commerce/features/wallet/domain/usecases/get_wallet_summary.dart';
import 'package:taksh_e_commerce/features/wallet/domain/usecases/request_withdrawal.dart';
import 'package:taksh_e_commerce/features/wallet/presentation/cubit/wallet_state.dart';

/// Cubit for managing wallet state
class WalletCubit extends Cubit<WalletState> {
  final GetWalletSummary _getWalletSummary;
  final RequestWithdrawal _requestWithdrawal;
  final GetBankAccounts _getBankAccounts;

  WalletSummary? _lastSummary;
  List<BankAccount> _lastBankAccounts = [];

  WalletCubit({
    required GetWalletSummary getWalletSummary,
    required RequestWithdrawal requestWithdrawal,
    required GetBankAccounts getBankAccounts,
  })  : _getWalletSummary = getWalletSummary,
        _requestWithdrawal = requestWithdrawal,
        _getBankAccounts = getBankAccounts,
        super(const WalletInitial());

  /// Load wallet summary and bank accounts in parallel
  Future<void> loadWallet() async {
    final log = loggerWithContext({
      'feature': 'wallet',
      'cubit': 'WalletCubit',
      'action': 'loadWallet',
    });
    final startTime = DateTime.now();

    if (isClosed) return;
    emit(const WalletLoading());

    log.infoWithContext('Loading wallet data', {});

    // Fetch wallet summary and bank accounts in parallel
    final results = await Future.wait([
      _getWalletSummary(),
      _getBankAccounts(),
    ]);

    if (isClosed) return;

    final summaryResult = results[0];
    final bankAccountsResult = results[1];

    // Handle wallet summary result
    WalletSummary? summary;
    summaryResult.fold(
      (failure) {
        log.errorWithContext(
          'Failed to fetch wallet summary',
          {
            'failure_message': failure.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!isClosed) {
          emit(WalletError(failure.message));
        }
      },
      (data) {
        summary = data as WalletSummary;
      },
    );

    // If summary failed, don't continue
    if (summary == null) return;

    // Handle bank accounts result
    List<BankAccount> bankAccounts = [];
    bankAccountsResult.fold(
      (failure) {
        log.errorWithContext(
          'Failed to fetch bank accounts (continuing with empty list)',
          {
            'failure_message': failure.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        // We still show the wallet even if bank accounts fail to load
        bankAccounts = [];
      },
      (data) {
        bankAccounts = (data as List).cast<BankAccount>();
      },
    );

    _lastSummary = summary;
    _lastBankAccounts = bankAccounts;

    log.infoWithContext(
      'Wallet data loaded successfully',
      {
        'balance_points': summary!.balancePoints,
        'available_points': summary!.availablePoints,
        'bank_accounts_count': bankAccounts.length,
        'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
      },
    );

    if (!isClosed) {
      emit(WalletLoaded(
        summary: summary!,
        bankAccounts: bankAccounts,
      ));
    }
  }

  /// Submit a withdrawal request
  Future<void> submitWithdrawal({
    required int points,
    required int bankDetailId,
  }) async {
    final log = loggerWithContext({
      'feature': 'wallet',
      'cubit': 'WalletCubit',
      'action': 'submitWithdrawal',
    });
    final startTime = DateTime.now();

    if (isClosed) return;

    final currentSummary = _lastSummary ?? const WalletSummary.empty();
    final currentBankAccounts = _lastBankAccounts;

    emit(WalletWithdrawalInProgress(
      summary: currentSummary,
      bankAccounts: currentBankAccounts,
    ));

    log.infoWithContext(
      'Submitting withdrawal request',
      {'points': points, 'bank_detail_id': bankDetailId},
    );

    final result = await _requestWithdrawal(
      WithdrawalParams(points: points, bankDetailId: bankDetailId),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        log.errorWithContext(
          'Withdrawal request failed',
          {
            'failure_message': failure.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!isClosed) {
          emit(WalletError(failure.message));
          // Restore loaded state after error
          emit(WalletLoaded(
            summary: currentSummary,
            bankAccounts: currentBankAccounts,
          ));
        }
      },
      (withdrawal) {
        log.infoWithContext(
          'Withdrawal request submitted successfully',
          {
            'withdrawal_id': withdrawal.id,
            'amount_rupees': withdrawal.amountRupees,
            'status': withdrawal.status,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!isClosed) {
          emit(WalletWithdrawalSuccess(
            withdrawal: withdrawal,
            summary: currentSummary,
            bankAccounts: currentBankAccounts,
          ));
        }
      },
    );
  }
}
