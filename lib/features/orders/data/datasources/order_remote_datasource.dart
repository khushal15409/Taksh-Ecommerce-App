import 'dart:io';

import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/data/models/orders_response_model.dart';
import 'package:taksh_e_commerce/features/orders/data/models/order_response_model.dart';
import 'package:taksh_e_commerce/features/orders/data/models/return_request_response_model.dart';

/// Remote datasource for order operations
abstract class OrderRemoteDatasource {
  /// Get all orders with pagination
  Future<OrdersResponseModel> getOrders({int page = 1});

  /// Get order details by ID
  Future<OrderResponseModel> getOrderDetails(int orderId);

  /// Place a new order
  Future<OrderResponseModel> placeOrder({
    required int addressId,
    required int warehouseId,
    required String deliveryType,
    required String paymentMethod,
  });

  /// Request a return for an order item
  Future<ReturnRequestResponseModel> requestReturn({
    required int orderId,
    required int orderItemId,
    required String reason,
    String? resolution,
  });

  /// Upload images for a return request
  Future<ReturnRequestResponseModel> uploadReturnMedia({
    required String returnId,
    required List<String> imagePaths,
  });

  /// Cancel an order
  Future<OrderResponseModel> cancelOrder(int orderId);

  /// Download the invoice PDF for an order.
  ///
  /// Returns the absolute file path of the saved PDF on success.
  Future<String> downloadInvoice({
    required String orderNumber,
    required String savePath,
    DownloadProgressCallback? onProgress,
  });
}

/// Implementation of [OrderRemoteDatasource]
class OrderRemoteDatasourceImpl implements OrderRemoteDatasource {
  final ApiClient _apiClient;

  OrderRemoteDatasourceImpl(this._apiClient);

  @override
  Future<OrdersResponseModel> getOrders({int page = 1}) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRemoteDatasourceImpl',
      'method': 'getOrders'
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext('Fetching orders', {'page': page});

      final response = await _apiClient.get(
        ApiConstants.orders,
        queryParameters: {'page': page},
      );

      final ordersResponse = OrdersResponseModel.fromJson(response.data);

      log.infoWithContext(
        'Orders fetched successfully',
        {
          'page': page,
          'total': ordersResponse.data?.total,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return ordersResponse;
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'Failed to fetch orders',
        {
          'page': page,
          'error_type': e.type.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to fetch orders: ${e.message}',
        e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error fetching orders',
        {
          'page': page,
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      throw ServerException('Failed to fetch orders: $e');
    }
  }

  @override
  Future<OrderResponseModel> getOrderDetails(int orderId) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRemoteDatasourceImpl',
      'method': 'getOrderDetails'
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext('Fetching order details', {'order_id': orderId});

      final response = await _apiClient.get(
        ApiConstants.orderDetails(orderId),
      );

      final orderResponse = OrderResponseModel.fromJson(response.data);

      log.infoWithContext(
        'Order details fetched successfully',
        {
          'order_id': orderId,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return orderResponse;
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'Failed to fetch order details',
        {
          'order_id': orderId,
          'error_type': e.type.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to fetch order details: ${e.message}',
        e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error fetching order details',
        {
          'order_id': orderId,
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      throw ServerException('Failed to fetch order details: $e');
    }
  }

  @override
  Future<OrderResponseModel> placeOrder({
    required int addressId,
    required int warehouseId,
    required String deliveryType,
    required String paymentMethod,
  }) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRemoteDatasourceImpl',
      'method': 'placeOrder'
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext('Placing order', {
        'address_id': addressId,
        'warehouse_id': warehouseId,
        'delivery_type': deliveryType,
        'payment_method': paymentMethod,
      });

      final formData = FormData.fromMap({
        'address_id': addressId.toString(),
        'warehouse_id': warehouseId.toString(),
        'delivery_type': deliveryType,
        'payment_method': paymentMethod,
      });

      final response = await _apiClient.post(
        ApiConstants.placeOrder,
        data: formData,
      );

      final orderResponse = OrderResponseModel.fromJson(response.data);

      log.infoWithContext(
        'Order placed successfully',
        {
          'order_id': orderResponse.data?.id,
          'order_number': orderResponse.data?.orderNumber,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return orderResponse;
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'Failed to place order',
        {
          'address_id': addressId,
          'warehouse_id': warehouseId,
          'error_type': e.type.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to place order: ${e.message}',
        e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error placing order',
        {
          'address_id': addressId,
          'warehouse_id': warehouseId,
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      throw ServerException('Failed to place order: $e');
    }
  }

  @override
  Future<ReturnRequestResponseModel> requestReturn({
    required int orderId,
    required int orderItemId,
    required String reason,
    String? resolution,
  }) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRemoteDatasourceImpl',
      'method': 'requestReturn'
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext('Requesting return', {
        'order_id': orderId,
        'order_item_id': orderItemId,
        'reason': reason,
      });

      final formData = FormData.fromMap({
        'order_id': orderId.toString(),
        'order_item_id': orderItemId.toString(),
        'reason': reason,
        'resolution': resolution ?? '',
      });

      final response = await _apiClient.post(
        ApiConstants.returnRequest,
        data: formData,
      );

      final returnResponse = ReturnRequestResponseModel.fromJson(response.data);

      log.infoWithContext(
        'Return request submitted successfully',
        {
          'order_id': orderId,
          'order_item_id': orderItemId,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return returnResponse;
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'Failed to request return',
        {
          'order_id': orderId,
          'order_item_id': orderItemId,
          'error_type': e.type.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to request return: ${e.message}',
        e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error requesting return',
        {
          'order_id': orderId,
          'order_item_id': orderItemId,
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      throw ServerException('Failed to request return: $e');
    }
  }

  @override
  Future<ReturnRequestResponseModel> uploadReturnMedia({
    required String returnId,
    required List<String> imagePaths,
  }) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRemoteDatasourceImpl',
      'method': 'uploadReturnMedia'
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext('Uploading return media', {
        'return_id': returnId,
        'image_count': imagePaths.length,
      });

      // Build FormData with multiple images
      final formData = FormData.fromMap({
        'return_id': returnId,
      });

      // Add each image to FormData
      for (var i = 0; i < imagePaths.length; i++) {
        final imagePath = imagePaths[i];
        final fileName = imagePath.split('/').last;
        formData.files.add(
          MapEntry(
            'images[]',
            await MultipartFile.fromFile(
              imagePath,
              filename: fileName,
            ),
          ),
        );
      }

      final response = await _apiClient.post(
        ApiConstants.returnUploadMedia,
        data: formData,
      );

      final uploadResponse = ReturnRequestResponseModel.fromJson(response.data);

      log.infoWithContext(
        'Return media uploaded successfully',
        {
          'return_id': returnId,
          'image_count': imagePaths.length,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return uploadResponse;
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'Failed to upload return media',
        {
          'return_id': returnId,
          'image_count': imagePaths.length,
          'error_type': e.type.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to upload return media: ${e.message}',
        e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error uploading return media',
        {
          'return_id': returnId,
          'image_count': imagePaths.length,
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      throw ServerException('Failed to upload return media: $e');
    }
  }

  @override
  Future<OrderResponseModel> cancelOrder(int orderId) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRemoteDatasourceImpl',
      'method': 'cancelOrder'
    });
    final startTime = DateTime.now();

    try {
      log.infoWithContext('Cancelling order', {'order_id': orderId});
      final response = await _apiClient.post(
        ApiConstants.cancelOrder(orderId),
      );

      final orderResponse = OrderResponseModel.fromJson(response.data);

      log.infoWithContext(
        'Order cancelled successfully',
        {
          'order_id': orderId,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );

      return orderResponse;
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'Failed to cancel order',
        {
          'order_id': orderId,
          'error_type': e.type.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      final errorMessage = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.message)
          : e.message;

      throw ServerException(
        'Failed to cancel order: $errorMessage',
        e.response?.statusCode,
      );
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error cancelling order',
        {
          'order_id': orderId,
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      throw ServerException('Failed to cancel order: $e');
    }
  }

  @override
  Future<String> downloadInvoice({
    required String orderNumber,
    required String savePath,
    DownloadProgressCallback? onProgress,
  }) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRemoteDatasourceImpl',
      'method': 'downloadInvoice',
    });
    final startTime = DateTime.now();
    final invoiceUrl = ApiConstants.orderInvoiceFile(
      orderNumber,
      baseUrl: _apiClient.baseUrl,
    );

    try {
      log.infoWithContext('Downloading invoice', {
        'order_number': orderNumber,
        'url': invoiceUrl,
        'save_path': savePath,
      });

      // Dedicated Dio for binary PDF — avoids ApiClient JSON Accept header
      // and uses the absolute invoice URL (outside the `/api` prefix).
      final downloadDio = Dio(
        BaseOptions(
          connectTimeout: ApiConstants.connectTimeout,
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: ApiConstants.sendTimeout,
          followRedirects: true,
          maxRedirects: 5,
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
          responseType: ResponseType.bytes,
          headers: {
            'Accept': 'application/pdf, application/octet-stream, */*',
          },
        ),
      );

      final token = await _apiClient.authToken;
      if (token != null && token.isNotEmpty) {
        downloadDio.options.headers['Authorization'] = 'Bearer $token';
      }

      await downloadDio.download(
        invoiceUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (onProgress == null) return;
          if (total > 0) {
            onProgress((received / total).clamp(0.0, 1.0));
          } else if (received > 0) {
            // Unknown content-length: keep UI moving without claiming 100%.
            onProgress(0.5);
          }
        },
      );

      // Ensure we received a real PDF, not an HTML landing/error page.
      final file = File(savePath);
      await _validatePdfFile(file);

      log.infoWithContext('Invoice downloaded successfully', {
        'order_number': orderNumber,
        'save_path': savePath,
        'file_size_bytes': await file.length(),
        'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
      });

      onProgress?.call(1.0);
      return savePath;
    } on DioException catch (e, stackTrace) {
      log.errorWithContext(
        'Failed to download invoice',
        {
          'order_number': orderNumber,
          'url': invoiceUrl,
          'error_type': e.type.toString(),
          'status_code': e.response?.statusCode,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      final errorMessage = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.message)
          : (e.message ?? 'Failed to download invoice');
      throw ServerException(
        'Failed to download invoice: $errorMessage',
        e.response?.statusCode,
      );
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error downloading invoice',
        {
          'order_number': orderNumber,
          'url': invoiceUrl,
          'error_type': e.runtimeType.toString(),
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
        e,
        stackTrace,
      );
      throw ServerException('Failed to download invoice: $e');
    }
  }

  /// Ensures [file] exists, is non-empty, and starts with the PDF magic bytes.
  Future<void> _validatePdfFile(File file) async {
    if (!await file.exists()) {
      throw const ServerException('Invoice file was not saved on device');
    }

    final length = await file.length();
    if (length < 5) {
      await file.delete();
      throw const ServerException('Invoice file is empty or incomplete');
    }

    final raf = await file.open();
    try {
      final header = await raf.read(5);
      final isPdf = header.length >= 5 &&
          header[0] == 0x25 && // %
          header[1] == 0x50 && // P
          header[2] == 0x44 && // D
          header[3] == 0x46 && // F
          header[4] == 0x2D; // -
      if (!isPdf) {
        await file.delete();
        throw const ServerException(
          'Server did not return a valid PDF invoice',
        );
      }
    } finally {
      await raf.close();
    }
  }
}
