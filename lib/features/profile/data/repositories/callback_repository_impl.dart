import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/data/datasources/callback_remote_datasource.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/callback_response.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/callback_repository.dart';

/// Implementation of [CallbackRepository]
class CallbackRepositoryImpl implements CallbackRepository {
  final CallbackRemoteDataSource _remoteDataSource;

  CallbackRepositoryImpl({
    required CallbackRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<CallbackResponse> requestCallback() async {
    try {
      final response = await _remoteDataSource.requestCallback();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure(e.toString()),
      );
    }
  }
}
