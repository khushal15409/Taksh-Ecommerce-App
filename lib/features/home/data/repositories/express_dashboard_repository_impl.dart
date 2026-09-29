import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/network/network_info.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/home/data/datasources/express_dashboard_remote_datasource.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/express_dashboard_entity.dart';
import 'package:taksh_e_commerce/features/home/domain/repositories/express_dashboard_repository.dart';

/// Repository implementation for express dashboard
class ExpressDashboardRepositoryImpl implements ExpressDashboardRepository {
  final ExpressDashboardRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const ExpressDashboardRepositoryImpl({
    required ExpressDashboardRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, ExpressDashboardEntity>> getExpressDashboard({
    required double latitude,
    required double longitude,
    required String pincode,
  }) async {
    final log = loggerWithContext({
      'feature': 'home',
      'layer': 'repository',
      'action': 'getExpressDashboard',
    });

    try {
      if (!await _networkInfo.isConnected) {
        log.warnWithContext(
          'No internet connection',
          {'latitude': latitude, 'longitude': longitude},
        );
        return const Left(NetworkFailure('No internet connection'));
      }

      log.debugWithContext(
        'Fetching express dashboard from remote',
        {'latitude': latitude, 'longitude': longitude},
      );

      final dashboard = await _remoteDataSource.getExpressDashboard(
        latitude: latitude,
        longitude: longitude,
        pincode: pincode,
      );

      log.infoWithContext(
        'Express dashboard fetched successfully',
        {'sections_count': dashboard.sections.length},
      );

      return Right(dashboard);
    } on NetworkException catch (e) {
      log.errorWithContext('Network exception', {'message': e.message});
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      log.errorWithContext('Server exception', {'message': e.message});
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error',
        {'error': e.toString()},
        e,
        stackTrace,
      );
      return Left(GeneralFailure(e.toString()));
    }
  }
}
