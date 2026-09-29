import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/features/profile/data/models/callback_response_model.dart';

/// Remote data source for callback operations
abstract class CallbackRemoteDataSource {
  /// Request a callback from support
  Future<CallbackResponseModel> requestCallback();
}

/// Implementation of [CallbackRemoteDataSource]
class CallbackRemoteDataSourceImpl implements CallbackRemoteDataSource {
  final ApiClient apiClient;

  CallbackRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CallbackResponseModel> requestCallback() async {
    try {
      // Make API call - no body data, auth token handled by ApiClient
      final response = await apiClient.post(
        ApiConstants.requestCallback,
      );

      // Parse response
      final data = response.data['data'] as Map<String, dynamic>;
      return CallbackResponseModel.fromJson(data);
    } on DioException catch (e) {
      // Extract error message from API response
      if (e.response?.data != null && e.response?.data['message'] != null) {
        throw ServerException(e.response!.data['message']);
      }
      throw const ServerException('Failed to request callback');
    }
  }
}
