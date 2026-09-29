import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/features/profile/data/models/delivery_boy_join_request_model.dart';
import 'package:taksh_e_commerce/features/profile/data/models/delivery_boy_join_response_model.dart';

/// Remote data source for delivery boy operations
abstract class DeliveryBoyRemoteDataSource {
  /// Submit a delivery boy join request to the server
  Future<DeliveryBoyJoinResponseModel> submitJoinRequest(
    DeliveryBoyJoinRequestModel request,
  );
}

/// Implementation of [DeliveryBoyRemoteDataSource]
class DeliveryBoyRemoteDataSourceImpl implements DeliveryBoyRemoteDataSource {
  final ApiClient apiClient;

  DeliveryBoyRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<DeliveryBoyJoinResponseModel> submitJoinRequest(
    DeliveryBoyJoinRequestModel request,
  ) async {
    // Convert request to form data
    final formData = request.toFormData();

    // Make API call
    final response = await apiClient.post(
      ApiConstants.deliveryBoyJoinRequest,
      data: formData,
    );

    // Parse response
    final data = response.data['data'] as Map<String, dynamic>;
    return DeliveryBoyJoinResponseModel.fromJson(data);
  }
}
