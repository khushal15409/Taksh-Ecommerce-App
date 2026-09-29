import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/core/network/base_response_model.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home/data/models/dashboard_model.dart';

/// Remote data source for dashboard operations
abstract class DashboardRemoteDataSource {
  /// Fetch dashboard data for given location
  Future<DashboardModel> getDashboard({
    required double latitude,
    required double longitude,
  });
}

/// Implementation of DashboardRemoteDataSource
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient _apiClient;

  const DashboardRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<DashboardModel> getDashboard({
    required double latitude,
    required double longitude,
  }) async {
    final log = loggerWithContext({
      'feature': 'home',
      'layer': 'datasource',
      'action': 'getDashboard',
    });
    final startTime = DateTime.now();
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      log.infoWithContext(
        'Initiating dashboard request to API',
        {
          'request_id': requestId,
          'endpoint': ApiConstants.dashboard,
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      final response = await _apiClient.get(
        ApiConstants.dashboard,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      final responseData = response.data as DataMap;
      final baseResponse = BaseResponse.fromJson(
        responseData,
        (json) => DashboardModel.fromJson(json as DataMap),
      );

      if (!baseResponse.success) {
        log.errorWithContext(
          'API returned unsuccessful response',
          {
            'request_id': requestId,
            'success': false,
            'message': baseResponse.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        throw ServerException(baseResponse.message);
      }

      if (baseResponse.data == null) {
        log.errorWithContext(
          'Dashboard data missing in response',
          {
            'request_id': requestId,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        throw const ServerException('Dashboard data not received');
      }

      log.infoWithContext(
        'Dashboard data fetched successfully',
        {
          'request_id': requestId,
          'sections_count': baseResponse.data!.sections.length,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return baseResponse.data!;
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error fetching dashboard data',
        {
          'request_id': requestId,
          'error_type': e.runtimeType.toString(),
          'endpoint': ApiConstants.dashboard,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      if (e is AppException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
