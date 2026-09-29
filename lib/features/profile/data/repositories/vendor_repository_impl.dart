import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/data/datasources/vendor_remote_datasource.dart';
import 'package:taksh_e_commerce/features/profile/data/models/vendor_join_request_model.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/vendor_join_request.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/vendor_join_response.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/vendor_repository.dart';

/// Implementation of [VendorRepository]
class VendorRepositoryImpl implements VendorRepository {
  final VendorRemoteDataSource _remoteDataSource;

  VendorRepositoryImpl({
    required VendorRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<VendorJoinResponse> submitJoinRequest(
    VendorJoinRequest request,
  ) async {
    try {
      final requestModel = VendorJoinRequestModel.fromEntity(request);
      final response = await _remoteDataSource.submitJoinRequest(requestModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
