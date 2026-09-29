import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/features/profile/data/models/vendor_join_request_model.dart';
import 'package:taksh_e_commerce/features/profile/data/models/vendor_join_response_model.dart';

/// Remote data source for vendor operations
abstract class VendorRemoteDataSource {
  /// Submit a vendor join request to the server
  Future<VendorJoinResponseModel> submitJoinRequest(
    VendorJoinRequestModel request,
  );
}

/// Implementation of [VendorRemoteDataSource]
class VendorRemoteDataSourceImpl implements VendorRemoteDataSource {
  final ApiClient apiClient;

  VendorRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<VendorJoinResponseModel> submitJoinRequest(
    VendorJoinRequestModel request,
  ) async {
    final formData = await request.toFormData();

    final response = await apiClient.post(
      ApiConstants.vendorRegister,
      data: formData,
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return VendorJoinResponseModel.fromJson(data);
  }
}
