import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/bank_account.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/wallet_summary.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/withdrawal_response.dart';
import 'package:taksh_e_commerce/features/wallet/domain/repositories/wallet_repository.dart';

/// Implementation of [WalletRepository]
class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remoteDataSource;

  WalletRepositoryImpl({
    required WalletRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<WalletSummary> getWalletSummary() async {
    final log = loggerWithContext({
      'feature': 'wallet',
      'layer': 'repository',
      'action': 'getWalletSummary',
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext('Fetching wallet summary via remote data source', {});

      final result = await _remoteDataSource.getWalletSummary();

      log.infoWithContext(
        'Wallet summary fetched successfully',
        {
          'balance_points': result.balancePoints,
          'available_points': result.availablePoints,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return Right(result);
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server error fetching wallet summary',
        {
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network error fetching wallet summary',
        {
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } on AppException catch (e, stackTrace) {
      log.errorWithContext(
        'App error fetching wallet summary',
        {
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error fetching wallet summary',
        {
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<WithdrawalResponse> requestWithdrawal(
    WithdrawalParams params,
  ) async {
    final log = loggerWithContext({
      'feature': 'wallet',
      'layer': 'repository',
      'action': 'requestWithdrawal',
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext(
        'Submitting withdrawal request via remote data source',
        {'points': params.points, 'bank_detail_id': params.bankDetailId},
      );

      final result = await _remoteDataSource.requestWithdrawal(
        points: params.points,
        bankDetailId: params.bankDetailId,
      );

      log.infoWithContext(
        'Withdrawal request submitted successfully',
        {
          'withdrawal_id': result.id,
          'amount_rupees': result.amountRupees,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return Right(result);
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server error submitting withdrawal',
        {
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network error submitting withdrawal',
        {
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } on AppException catch (e, stackTrace) {
      log.errorWithContext(
        'App error submitting withdrawal',
        {
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error submitting withdrawal',
        {
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<BankAccount>> getBankAccounts() async {
    final log = loggerWithContext({
      'feature': 'wallet',
      'layer': 'repository',
      'action': 'getBankAccounts',
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext(
        'Fetching bank accounts via remote data source',
        {},
      );

      final result = await _remoteDataSource.getBankAccounts();

      log.infoWithContext(
        'Bank accounts fetched successfully',
        {
          'count': result.length,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return Right(result);
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server error fetching bank accounts',
        {
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network error fetching bank accounts',
        {
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } on AppException catch (e, stackTrace) {
      log.errorWithContext(
        'App error fetching bank accounts',
        {
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error fetching bank accounts',
        {
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.toString()));
    }
  }
}
