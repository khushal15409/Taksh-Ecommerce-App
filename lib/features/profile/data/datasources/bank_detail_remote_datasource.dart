import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/profile/data/models/bank_detail_model.dart';

/// Remote data source for bank detail operations
abstract class BankDetailRemoteDataSource {
  /// Save bank account details to the server
  Future<BankDetailModel> saveBankDetail(BankDetailParamsModel params);
}

/// Implementation of [BankDetailRemoteDataSource]
class BankDetailRemoteDataSourceImpl implements BankDetailRemoteDataSource {
  final ApiClient apiClient;

  BankDetailRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<BankDetailModel> saveBankDetail(BankDetailParamsModel params) async {
    final log = loggerWithContext({
      'feature': 'profile',
      'layer': 'datasource',
      'action': 'saveBankDetail'
    });
    final startTime = DateTime.now();
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      log.infoWithContext(
        'Initiating bank detail save request to API',
        {
          'request_id': requestId,
          'endpoint': ApiConstants.saveBankDetail,
        },
      );

      // Convert params to form data
      final formData = params.toFormData();

      // Make API call
      final response = await apiClient.post(
        ApiConstants.saveBankDetail,
        data: formData,
      );

      log.debugWithContext(
        'Bank detail save response received',
        {
          'request_id': requestId,
          'status_code': response.statusCode,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      // Print status code to console
      print('✅ Bank Detail API Response - Status Code: ${response.statusCode}');

      // Parse response
      final responseData = response.data;

      // Check if response indicates success
      if (responseData['success'] == false) {
        print(
            '❌ Bank Detail API Error - Status Code: ${response.statusCode}, Message: ${responseData['message']}');
        log.errorWithContext(
          'API returned unsuccessful response',
          {
            'request_id': requestId,
            'status_code': response.statusCode,
            'message': responseData['message'],
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        throw ServerException(
            responseData['message'] ?? 'Failed to save bank details');
      }

      final data = responseData['data'] as Map<String, dynamic>;
      final bankDetail = BankDetailModel.fromJson(data);

      print(
          '✅ Bank Details Saved Successfully - Status Code: ${response.statusCode}, ID: ${bankDetail.id}');
      log.infoWithContext(
        'Bank details saved successfully',
        {
          'request_id': requestId,
          'status_code': response.statusCode,
          'bank_detail_id': bankDetail.id,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return bankDetail;
    } on DioException catch (e, stackTrace) {
      print(
          '❌ Bank Detail Dio Error - Status Code: ${e.response?.statusCode ?? 'N/A'}, Type: ${e.type}');
      log.errorWithContext(
        'Dio error saving bank details',
        {
          'request_id': requestId,
          'error_type': e.type.toString(),
          'status_code': e.response?.statusCode,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );

      // Extract error message from API response
      if (e.response?.data != null && e.response?.data['message'] != null) {
        throw ServerException(e.response!.data['message']);
      }
      throw const ServerException('Failed to save bank details');
    } catch (e, stackTrace) {
      print('❌ Bank Detail Unexpected Error - Type: ${e.runtimeType}');
      log.errorWithContext(
        'Unexpected error saving bank details',
        {
          'request_id': requestId,
          'error_type': e.runtimeType.toString(),
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
