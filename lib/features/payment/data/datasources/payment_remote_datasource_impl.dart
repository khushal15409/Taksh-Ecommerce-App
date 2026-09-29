import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:taksh_e_commerce/features/payment/data/models/initiate_payment_request_model.dart';
import 'package:taksh_e_commerce/features/payment/data/models/initiate_payment_response_model.dart';
import 'package:taksh_e_commerce/features/payment/data/models/payment_model.dart';
import 'package:taksh_e_commerce/features/payment/data/models/payment_order_model.dart';
import 'package:taksh_e_commerce/features/payment/data/models/verify_payment_request_model.dart';
import 'package:taksh_e_commerce/features/payment/data/models/verify_payment_response_model.dart';

/// Real API implementation of PaymentRemoteDataSource
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiClient apiClient;

  PaymentRemoteDataSourceImpl({required this.apiClient});

  final _log = loggerWithContext({
    'feature': 'payment',
    'layer': 'datasource',
    'type': 'api',
  });

  @override
  Future<PaymentOrderModel> createRazorpayOrder({
    required int amount,
    required String currency,
    required String receipt,
  }) async {
    try {
      _log.infoWithContext('Creating Razorpay order via API', {
        'amount': amount,
        'currency': currency,
      });

      final response = await apiClient.post(
        '/payments/create-order',
        data: {
          'amount': amount,
          'currency': currency,
          'receipt': receipt,
        },
      );

      return PaymentOrderModel.fromJson(response.data['data'] as DataMap);
    } on DioException catch (e) {
      _log.errorWithContext('API error creating Razorpay order', {
        'error': e.message,
        'statusCode': e.response?.statusCode,
      });
      throw ServerException(
        e.response?.data['message'] as String? ?? e.message ?? 'Unknown error',
        e.response?.statusCode ?? 500,
      );
    } catch (e) {
      _log.errorWithContext('Unexpected error creating Razorpay order', {
        'error': e.toString(),
      });
      throw ServerException(e.toString());
    }
  }

  @override
  Future<InitiatePaymentResponseModel> initiatePayment({
    required String orderId,
    String gateway = 'razorpay',
  }) async {
    try {
      _log.infoWithContext('Creating Razorpay order via API', {
        'orderId': orderId,
        'gateway': gateway,
      });

      final requestModel = InitiatePaymentRequestModel(
        orderId: orderId,
        gateway: gateway,
      );

      final formData = FormData.fromMap(requestModel.toFormData());

      // POST /payments/create - Backend creates Razorpay order and returns:
      // { razorpay_order_id, amount (in paisa), currency, razorpay_key }
      final response = await apiClient.post(
        ApiConstants.createPayment,
        data: formData,
      );

      // Handle flexible response structure
      final responseData = response.data;

      if (responseData is Map<String, dynamic>) {
        DataMap dataToProcess;
        if (responseData.containsKey('data')) {
          dataToProcess = responseData['data'] as DataMap;
        } else {
          dataToProcess = responseData;
        }

        _log.infoWithContext('Payment creation response', {
          'razorpay_order_id': dataToProcess['razorpay_order_id'],
          'amount': dataToProcess['amount'],
          'razorpay_key': dataToProcess['razorpay_key'],
        });

        return InitiatePaymentResponseModel.fromJson(dataToProcess);
      }

      throw const ServerException('Invalid response format');
    } on DioException catch (e) {
      _log.errorWithContext('API error initiating payment', {
        'error': e.message,
        'statusCode': e.response?.statusCode,
        'responseData': e.response?.data,
      });
      throw ServerException(
        e.response?.data['message'] as String? ??
            e.message ??
            'Failed to initiate payment',
        e.response?.statusCode ?? 500,
      );
    } catch (e) {
      _log.errorWithContext('Unexpected error initiating payment', {
        'error': e.toString(),
      });
      throw ServerException(e.toString());
    }
  }

  @override
  Future<VerifyPaymentResponseModel> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      _log.infoWithContext('Verifying payment via API', {
        'razorpayOrderId': razorpayOrderId,
        'razorpayPaymentId': razorpayPaymentId,
      });

      final requestModel = VerifyPaymentRequestModel(
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
      );

      final formData = FormData.fromMap(requestModel.toFormData());

      final response = await apiClient.post(
        ApiConstants.verifyPayment,
        data: formData,
      );

      // Handle flexible response structure
      final responseData = response.data;

      if (responseData is Map<String, dynamic>) {
        DataMap dataToProcess;
        if (responseData.containsKey('data')) {
          dataToProcess = responseData['data'] as DataMap;
        } else {
          dataToProcess = responseData;
        }

        _log.infoWithContext('Payment verification response', {
          'payment_id': dataToProcess['payment_id'],
          'order_id': dataToProcess['order_id'],
          'status': dataToProcess['status'],
          'order_status': dataToProcess['order_status'],
        });

        return VerifyPaymentResponseModel.fromJson(dataToProcess);
      }

      throw const ServerException('Invalid response format');
    } on DioException catch (e) {
      _log.errorWithContext('API error verifying payment', {
        'error': e.message,
        'statusCode': e.response?.statusCode,
        'responseData': e.response?.data,
      });
      throw ServerException(
        e.response?.data['message'] as String? ??
            e.message ??
            'Failed to verify payment',
        e.response?.statusCode ?? 500,
      );
    } catch (e) {
      _log.errorWithContext('Unexpected error verifying payment', {
        'error': e.toString(),
      });
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> verifyPaymentSignature({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final response = await verifyPayment(
        razorpayOrderId: orderId,
        razorpayPaymentId: paymentId,
        razorpaySignature: signature,
      );

      return response.isSuccess;
    } catch (e) {
      _log.errorWithContext('Error in legacy verify signature', {
        'error': e.toString(),
      });
      rethrow;
    }
  }

  @override
  Future<PaymentModel> savePaymentDetails({
    required DataMap paymentData,
  }) async {
    try {
      _log.infoWithContext('Saving payment details via API', paymentData);

      final response = await apiClient.post(
        '/payments/save',
        data: paymentData,
      );

      return PaymentModel.fromJson(response.data['data'] as DataMap);
    } on DioException catch (e) {
      _log.errorWithContext('API error saving payment details', {
        'error': e.message,
        'statusCode': e.response?.statusCode,
      });
      throw ServerException(
        e.response?.data['message'] as String? ?? e.message ?? 'Unknown error',
        e.response?.statusCode ?? 500,
      );
    } catch (e) {
      _log.errorWithContext('Unexpected error saving payment details', {
        'error': e.toString(),
      });
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PaymentModel> getPaymentById(String paymentId) async {
    try {
      _log.infoWithContext('Getting payment by ID via API', {
        'paymentId': paymentId,
      });

      final response = await apiClient.get('/payments/$paymentId');

      return PaymentModel.fromJson(response.data['data'] as DataMap);
    } on DioException catch (e) {
      _log.errorWithContext('API error getting payment', {
        'error': e.message,
        'statusCode': e.response?.statusCode,
      });
      throw ServerException(
        e.response?.data['message'] as String? ?? e.message ?? 'Unknown error',
        e.response?.statusCode ?? 500,
      );
    } catch (e) {
      _log.errorWithContext('Unexpected error getting payment', {
        'error': e.toString(),
      });
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PaymentModel>> getPaymentHistory({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      _log.infoWithContext('Getting payment history via API', {
        'userId': userId,
        'page': page,
        'limit': limit,
      });

      final response = await apiClient.get(
        ApiConstants.paymentHistory,
        queryParameters: {
          'user_id': userId,
          'page': page,
          'limit': limit,
        },
      );

      final dataList = response.data['data'] as List<dynamic>;
      return dataList
          .map((json) => PaymentModel.fromJson(json as DataMap))
          .toList();
    } on DioException catch (e) {
      _log.errorWithContext('API error getting payment history', {
        'error': e.message,
        'statusCode': e.response?.statusCode,
      });
      throw ServerException(
        e.response?.data['message'] as String? ?? e.message ?? 'Unknown error',
        e.response?.statusCode ?? 500,
      );
    } catch (e) {
      _log.errorWithContext('Unexpected error getting payment history', {
        'error': e.toString(),
      });
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PaymentModel> processRefund({
    required String paymentId,
    required int amount,
    required String reason,
  }) async {
    try {
      _log.infoWithContext('Processing refund via API', {
        'paymentId': paymentId,
        'amount': amount,
        'reason': reason,
      });

      final response = await apiClient.post(
        '/payments/$paymentId/refund',
        data: {
          'amount': amount,
          'reason': reason,
        },
      );

      return PaymentModel.fromJson(response.data['data'] as DataMap);
    } on DioException catch (e) {
      _log.errorWithContext('API error processing refund', {
        'error': e.message,
        'statusCode': e.response?.statusCode,
      });
      throw ServerException(
        e.response?.data['message'] as String? ?? e.message ?? 'Unknown error',
        e.response?.statusCode ?? 500,
      );
    } catch (e) {
      _log.errorWithContext('Unexpected error processing refund', {
        'error': e.toString(),
      });
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updatePaymentStatus({
    required String paymentId,
    required String status,
  }) async {
    try {
      _log.infoWithContext('Updating payment status via API', {
        'paymentId': paymentId,
        'status': status,
      });

      await apiClient.put(
        '/payments/$paymentId/status',
        data: {'status': status},
      );
    } on DioException catch (e) {
      _log.errorWithContext('API error updating payment status', {
        'error': e.message,
        'statusCode': e.response?.statusCode,
      });
      throw ServerException(
        e.response?.data['message'] as String? ?? e.message ?? 'Unknown error',
        e.response?.statusCode ?? 500,
      );
    } catch (e) {
      _log.errorWithContext('Unexpected error updating payment status', {
        'error': e.toString(),
      });
      throw ServerException(e.toString());
    }
  }
}
