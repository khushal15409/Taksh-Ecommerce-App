import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/quick_delivery/data/models/quick_delivery_tracking_model.dart';

abstract class QuickDeliveryRemoteDatasource {
  Future<QuickDeliveryTrackingModel> getDeliveryLocation(int orderId);
}

class QuickDeliveryRemoteDatasourceImpl
    implements QuickDeliveryRemoteDatasource {
  final ApiClient _apiClient;

  QuickDeliveryRemoteDatasourceImpl(this._apiClient);

  @override
  Future<QuickDeliveryTrackingModel> getDeliveryLocation(int orderId) async {
    final log = loggerWithContext({
      'feature': 'quick_delivery',
      'class': 'QuickDeliveryRemoteDatasourceImpl',
      'method': 'getDeliveryLocation',
    });

    try {
      final response = await _apiClient.get(
        ApiConstants.quickDeliveryLocation(orderId),
      );

      return QuickDeliveryTrackingModel.fromJson(
        (response.data as Map).cast<String, dynamic>(),
      );
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'Failed to fetch quick delivery location',
        {'order_id': orderId, 'message': e.message, 'type': e.type.name},
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to fetch delivery location: ${e.message}',
        e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error fetching quick delivery location',
        {'order_id': orderId, 'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      throw ServerException('Failed to fetch delivery location: $e');
    }
  }
}
