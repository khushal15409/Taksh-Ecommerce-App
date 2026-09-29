import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/network/network_info.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home/data/datasources/dashboard_remote_datasource.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/dashboard_entity.dart';
import 'package:taksh_e_commerce/features/home/domain/repositories/dashboard_repository.dart';

/// Implementation of DashboardRepository
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const DashboardRepositoryImpl({
    required DashboardRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  ResultFuture<DashboardEntity> getDashboard({
    required double latitude,
    required double longitude,
  }) async {
    final log = loggerWithContext({
      'feature': 'home',
      'layer': 'repository',
      'action': 'getDashboard',
    });

    try {
      // Check network connectivity
      if (!await _networkInfo.isConnected) {
        log.warnWithContext(
          'No internet connection',
          {'latitude': latitude, 'longitude': longitude},
        );
        return const Left(NetworkFailure('No internet connection'));
      }

      log.debugWithContext(
        'Fetching dashboard from remote',
        {'latitude': latitude, 'longitude': longitude},
      );

      final dashboard = await _remoteDataSource.getDashboard(
        latitude: latitude,
        longitude: longitude,
      );

      log.infoWithContext(
        'Dashboard fetched successfully',
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
