import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/features/profile/data/models/development_request_model.dart';
import 'package:taksh_e_commerce/features/profile/data/models/development_response_model.dart';

/// Remote data source for development operations
abstract class DevelopmentRemoteDataSource {
  /// Submit a development request to the server
  Future<DevelopmentResponseModel> submitDevelopmentRequest(
    DevelopmentRequestModel request,
  );
}

/// Implementation of [DevelopmentRemoteDataSource]
class DevelopmentRemoteDataSourceImpl implements DevelopmentRemoteDataSource {
  final ApiClient apiClient;

  DevelopmentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<DevelopmentResponseModel> submitDevelopmentRequest(
    DevelopmentRequestModel request,
  ) async {
    // Convert request to form data
    final formData = request.toFormData();
    
    // Debug: Print the data being sent
    print('Development Request Data: $formData');

    try {
      // Make API call
      final response = await apiClient.post(
        ApiConstants.developmentRequest,
        data: formData,
      );

      // Parse response
      final data = response.data['data'] as Map<String, dynamic>;
      return DevelopmentResponseModel.fromJson(data);
    } catch (e) {
      print('Development Request Error: $e');
      if (e.toString().contains('DioException')) {
        // Try to extract error message from response
        final errorMatch = RegExp(r'Response data: (.+)').firstMatch(e.toString());
        if (errorMatch != null) {
          print('Server Error Response: ${errorMatch.group(1)}');
        }
      }
      rethrow;
    }
  }
}
