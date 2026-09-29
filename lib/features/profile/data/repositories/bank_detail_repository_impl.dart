import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/data/datasources/bank_detail_remote_datasource.dart';
import 'package:taksh_e_commerce/features/profile/data/models/bank_detail_model.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/bank_detail.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/bank_detail_repository.dart';

/// Implementation of [BankDetailRepository]
class BankDetailRepositoryImpl implements BankDetailRepository {
  final BankDetailRemoteDataSource _remoteDataSource;

  BankDetailRepositoryImpl({
    required BankDetailRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<BankDetail> saveBankDetail(BankDetailParams params) async {
    final log = loggerWithContext({
      'feature': 'profile',
      'layer': 'repository',
      'action': 'saveBankDetail',
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext(
        'Saving bank details via remote data source',
        {
          'account_holder': params.accountHolderName,
          'bank_name': params.bankName,
        },
      );

      // Convert params to model
      final paramsModel = BankDetailParamsModel.fromEntity(params);

      // Call remote data source
      final response = await _remoteDataSource.saveBankDetail(paramsModel);

      log.infoWithContext(
        'Bank details saved successfully',
        {
          'bank_detail_id': response.id,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return Right(response);
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server error saving bank details',
        {
          'error_type': 'ServerException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network error saving bank details',
        {
          'error_type': 'NetworkException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e, stackTrace) {
      log.errorWithContext(
        'Validation error saving bank details',
        {
          'error_type': 'ValidationException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ValidationFailure(e.message));
    } on AppException catch (e, stackTrace) {
      log.errorWithContext(
        'App error saving bank details',
        {
          'error_type': 'AppException',
          'error_message': e.message,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error saving bank details',
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
