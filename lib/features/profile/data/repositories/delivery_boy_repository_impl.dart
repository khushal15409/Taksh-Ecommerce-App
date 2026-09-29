import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/data/datasources/delivery_boy_remote_datasource.dart';
import 'package:taksh_e_commerce/features/profile/data/models/delivery_boy_join_request_model.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/delivery_boy_join_request.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/delivery_boy_join_response.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/delivery_boy_repository.dart';

/// Implementation of [DeliveryBoyRepository]
class DeliveryBoyRepositoryImpl implements DeliveryBoyRepository {
  final DeliveryBoyRemoteDataSource _remoteDataSource;

  DeliveryBoyRepositoryImpl({
    required DeliveryBoyRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<DeliveryBoyJoinResponse> submitJoinRequest(
    DeliveryBoyJoinRequest request,
  ) async {
    try {
      final requestModel = DeliveryBoyJoinRequestModel.fromEntity(request);
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
