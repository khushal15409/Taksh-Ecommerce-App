import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/core/network/base_response_model.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home/data/models/express_dashboard_model.dart';

/// Remote data source for express dashboard
abstract class ExpressDashboardRemoteDataSource {
  Future<ExpressDashboardModel> getExpressDashboard({
    required double latitude,
    required double longitude,
    required String pincode,
  });
}

class ExpressDashboardRemoteDataSourceImpl
    implements ExpressDashboardRemoteDataSource {
  final ApiClient _apiClient;

  const ExpressDashboardRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<ExpressDashboardModel> getExpressDashboard({
    required double latitude,
    required double longitude,
    required String pincode,
  }) async {
    final log = loggerWithContext({
      'feature': 'home',
      'layer': 'datasource',
      'action': 'getExpressDashboard',
    });
    final startTime = DateTime.now();
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      log.infoWithContext(
        'Initiating express dashboard request to API',
        {
          'request_id': requestId,
          'endpoint': ApiConstants.expressDashboard,
          'latitude': latitude,
          'longitude': longitude,
          'pincode': pincode,
        },
      );

      final response = await _apiClient.get(
        ApiConstants.expressDashboard,
        queryParameters: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'pincode': pincode,
        },
      );

      final responseData = response.data as DataMap;
      final baseResponse = BaseResponse.fromJson(
        responseData,
        (json) => ExpressDashboardModel.fromJson(json as DataMap),
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
          'Express dashboard data missing in response',
          {
            'request_id': requestId,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        throw const ServerException('Express dashboard data not received');
      }

      log.infoWithContext(
        'Express dashboard data fetched successfully',
        {
          'request_id': requestId,
          'sections_count': baseResponse.data!.sections.length,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return baseResponse.data!;
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error fetching express dashboard data',
        {
          'request_id': requestId,
          'error_type': e.runtimeType.toString(),
          'endpoint': ApiConstants.expressDashboard,
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
