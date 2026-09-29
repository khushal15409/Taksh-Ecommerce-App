import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/data/datasources/development_remote_datasource.dart';
import 'package:taksh_e_commerce/features/profile/data/models/development_request_model.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/development_request.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/development_response.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/development_repository.dart';

/// Implementation of [DevelopmentRepository]
class DevelopmentRepositoryImpl implements DevelopmentRepository {
  final DevelopmentRemoteDataSource _remoteDataSource;

  DevelopmentRepositoryImpl({
    required DevelopmentRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<DevelopmentResponse> submitDevelopmentRequest(
    DevelopmentRequest request,
  ) async {
    try {
      final requestModel = DevelopmentRequestModel.fromEntity(request);
      final response = await _remoteDataSource.submitDevelopmentRequest(requestModel);
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
