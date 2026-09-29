import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/wallet/data/models/bank_account_model.dart';
import 'package:taksh_e_commerce/features/wallet/data/models/wallet_summary_model.dart';
import 'package:taksh_e_commerce/features/wallet/data/models/withdrawal_response_model.dart';

/// Remote data source contract for wallet operations
abstract class WalletRemoteDataSource {
  /// GET /wallet — Fetch wallet summary
  Future<WalletSummaryModel> getWalletSummary();

  /// POST /wallet — Submit a withdrawal request
  Future<WithdrawalResponseModel> requestWithdrawal({
    required int points,
    required int bankDetailId,
  });

  /// GET /bank-detail — Fetch user's bank accounts
  Future<List<BankAccountModel>> getBankAccounts();
}

/// Implementation of [WalletRemoteDataSource]
class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final ApiClient apiClient;

  WalletRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<WalletSummaryModel> getWalletSummary() async {
    final log = loggerWithContext({
      'feature': 'wallet',
      'layer': 'datasource',
      'action': 'getWalletSummary',
    });
    final startTime = DateTime.now();
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      log.infoWithContext(
        'Fetching wallet summary from API',
        {'request_id': requestId, 'endpoint': ApiConstants.wallet},
      );

      final response = await apiClient.get(ApiConstants.wallet);

      log.debugWithContext(
        'Wallet summary response received',
        {
          'request_id': requestId,
          'status_code': response.statusCode,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      final responseData = response.data;

      if (responseData['success'] == false) {
        log.errorWithContext(
          'API returned unsuccessful response',
          {
            'request_id': requestId,
            'message': responseData['message'],
          },
        );
        throw ServerException(
          responseData['message'] ?? 'Failed to fetch wallet summary',
        );
      }

      final data = responseData['data'] as DataMap;
      return WalletSummaryModel.fromJson(data);
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'Dio error fetching wallet summary',
        {
          'request_id': requestId,
          'error_type': e.type.toString(),
          'status_code': e.response?.statusCode,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      if (e.response?.data != null && e.response?.data['message'] != null) {
        throw ServerException(e.response!.data['message']);
      }
      throw const ServerException('Failed to fetch wallet summary');
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error fetching wallet summary',
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

  @override
  Future<WithdrawalResponseModel> requestWithdrawal({
    required int points,
    required int bankDetailId,
  }) async {
    final log = loggerWithContext({
      'feature': 'wallet',
      'layer': 'datasource',
      'action': 'requestWithdrawal',
    });
    final startTime = DateTime.now();
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      log.infoWithContext(
        'Submitting withdrawal request',
        {
          'request_id': requestId,
          'endpoint': ApiConstants.wallet,
          'points': points,
          'bank_detail_id': bankDetailId,
        },
      );

      final formData = FormData.fromMap({
        'points': points.toString(),
        'bank_detail_id': bankDetailId.toString(),
      });

      final response = await apiClient.post(
        ApiConstants.wallet,
        data: formData,
      );

      log.debugWithContext(
        'Withdrawal response received',
        {
          'request_id': requestId,
          'status_code': response.statusCode,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      final responseData = response.data;

      if (responseData['success'] == false) {
        final message = responseData['message'] ?? 'Withdrawal request failed';
        log.errorWithContext(
          'API returned unsuccessful response for withdrawal',
          {
            'request_id': requestId,
            'message': message,
          },
        );
        throw ServerException(message);
      }

      final data = responseData['data'] as DataMap;
      return WithdrawalResponseModel.fromJson(data);
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'Dio error submitting withdrawal',
        {
          'request_id': requestId,
          'error_type': e.type.toString(),
          'status_code': e.response?.statusCode,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      if (e.response?.data != null && e.response?.data['message'] != null) {
        throw ServerException(e.response!.data['message']);
      }
      throw const ServerException('Failed to submit withdrawal request');
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error submitting withdrawal',
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

  @override
  Future<List<BankAccountModel>> getBankAccounts() async {
    final log = loggerWithContext({
      'feature': 'wallet',
      'layer': 'datasource',
      'action': 'getBankAccounts',
    });
    final startTime = DateTime.now();
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      log.infoWithContext(
        'Fetching bank accounts from API',
        {'request_id': requestId, 'endpoint': ApiConstants.bankDetails},
      );

      final response = await apiClient.get(ApiConstants.bankDetails);

      log.debugWithContext(
        'Bank accounts response received',
        {
          'request_id': requestId,
          'status_code': response.statusCode,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      final responseData = response.data;

      // The GET /bank-detail API uses "status" instead of "success"
      if (responseData['status'] == false &&
          responseData['success'] == false) {
        log.errorWithContext(
          'API returned unsuccessful response for bank accounts',
          {
            'request_id': requestId,
            'message': responseData['message'],
          },
        );
        throw ServerException(
          responseData['message'] ?? 'Failed to fetch bank accounts',
        );
      }

      final dataList = responseData['data'] as List<dynamic>? ?? [];
      return dataList
          .map((item) => BankAccountModel.fromJson(item as DataMap))
          .toList();
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'Dio error fetching bank accounts',
        {
          'request_id': requestId,
          'error_type': e.type.toString(),
          'status_code': e.response?.statusCode,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      if (e.response?.data != null && e.response?.data['message'] != null) {
        throw ServerException(e.response!.data['message']);
      }
      throw const ServerException('Failed to fetch bank accounts');
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error fetching bank accounts',
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
