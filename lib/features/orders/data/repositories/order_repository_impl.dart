import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/paginated_orders.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart'
    as order_entity;
import 'package:taksh_e_commerce/features/orders/domain/repositories/order_repository.dart';
import 'package:path_provider/path_provider.dart';

/// Implementation of [OrderRepository]
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource _remoteDatasource;

  OrderRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, PaginatedOrders>> getOrders({int page = 1}) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRepositoryImpl',
      'method': 'getOrders'
    });

    try {
      log.infoWithContext('Getting orders', {'page': page});

      final response = await _remoteDatasource.getOrders(page: page);

      if (response.success && response.data != null) {
        log.infoWithContext('Orders retrieved successfully', {
          'page': page,
          'total': response.data!.total,
        });
        return Right(response.data!);
      } else {
        log.warnWithContext('Orders request unsuccessful', {
          'page': page,
          'message': response.message,
        });
        return Left(ServerFailure(response.message));
      }
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server exception getting orders',
        {'page': page, 'message': e.message},
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network exception getting orders',
        {'page': page, 'message': e.message},
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error getting orders',
        {'page': page, 'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      return Left(ServerFailure('Failed to get orders: $e'));
    }
  }

  @override
  Future<Either<Failure, order_entity.Order>> getOrderDetails(
      int orderId) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRepositoryImpl',
      'method': 'getOrderDetails'
    });

    try {
      log.infoWithContext('Getting order details', {'order_id': orderId});

      final response = await _remoteDatasource.getOrderDetails(orderId);

      if (response.success && response.data != null) {
        log.infoWithContext('Order details retrieved successfully', {
          'order_id': orderId,
          'order_number': response.data!.orderNumber,
        });
        return Right(response.data!);
      } else {
        log.warnWithContext('Order details request unsuccessful', {
          'order_id': orderId,
          'message': response.message,
        });
        return Left(ServerFailure(response.message));
      }
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server exception getting order details',
        {'order_id': orderId, 'message': e.message},
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network exception getting order details',
        {'order_id': orderId, 'message': e.message},
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error getting order details',
        {'order_id': orderId, 'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      return Left(ServerFailure('Failed to get order details: $e'));
    }
  }

  @override
  Future<Either<Failure, order_entity.Order>> placeOrder({
    required int addressId,
    required int warehouseId,
    required String deliveryType,
    required String paymentMethod,
  }) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRepositoryImpl',
      'method': 'placeOrder'
    });

    try {
      log.infoWithContext('Placing order', {
        'address_id': addressId,
        'warehouse_id': warehouseId,
        'delivery_type': deliveryType,
        'payment_method': paymentMethod,
      });

      final response = await _remoteDatasource.placeOrder(
        addressId: addressId,
        warehouseId: warehouseId,
        deliveryType: deliveryType,
        paymentMethod: paymentMethod,
      );

      if (response.success && response.data != null) {
        log.infoWithContext('Order placed successfully', {
          'order_id': response.data!.id,
          'order_number': response.data!.orderNumber,
        });
        return Right(response.data!);
      } else {
        log.warnWithContext('Place order request unsuccessful', {
          'message': response.message,
        });
        return Left(ServerFailure(response.message));
      }
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server exception placing order',
        {'message': e.message},
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network exception placing order',
        {'message': e.message},
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error placing order',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      return Left(ServerFailure('Failed to place order: $e'));
    }
  }

  @override
  Future<Either<Failure, DataMap>> requestReturn({
    required int orderId,
    required int orderItemId,
    required String reason,
    String? resolution,
  }) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRepositoryImpl',
      'method': 'requestReturn'
    });

    try {
      log.infoWithContext('Requesting return', {
        'order_id': orderId,
        'order_item_id': orderItemId,
      });

      final response = await _remoteDatasource.requestReturn(
        orderId: orderId,
        orderItemId: orderItemId,
        reason: reason,
        resolution: resolution,
      );

      if (response.success) {
        log.infoWithContext('Return request submitted successfully', {
          'order_id': orderId,
          'order_item_id': orderItemId,
        });
        return Right(response.data ?? {});
      } else {
        log.warnWithContext('Return request unsuccessful', {
          'order_id': orderId,
          'order_item_id': orderItemId,
          'message': response.message,
        });
        return Left(ServerFailure(response.message));
      }
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server exception requesting return',
        {
          'order_id': orderId,
          'order_item_id': orderItemId,
          'message': e.message
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network exception requesting return',
        {
          'order_id': orderId,
          'order_item_id': orderItemId,
          'message': e.message
        },
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error requesting return',
        {
          'order_id': orderId,
          'order_item_id': orderItemId,
          'error_type': e.runtimeType.toString()
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure('Failed to request return: $e'));
    }
  }

  @override
  Future<Either<Failure, DataMap>> uploadReturnMedia({
    required String returnId,
    required List<String> imagePaths,
  }) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRepositoryImpl',
      'method': 'uploadReturnMedia'
    });

    try {
      log.infoWithContext('Uploading return media', {
        'return_id': returnId,
        'image_count': imagePaths.length,
      });

      final response = await _remoteDatasource.uploadReturnMedia(
        returnId: returnId,
        imagePaths: imagePaths,
      );

      if (response.success) {
        log.infoWithContext('Return media uploaded successfully', {
          'return_id': returnId,
          'image_count': imagePaths.length,
        });
        return Right(response.data ?? {});
      } else {
        log.warnWithContext('Return media upload unsuccessful', {
          'return_id': returnId,
          'message': response.message,
        });
        return Left(ServerFailure(response.message));
      }
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server exception uploading return media',
        {'return_id': returnId, 'message': e.message},
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network exception uploading return media',
        {'return_id': returnId, 'message': e.message},
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error uploading return media',
        {'return_id': returnId, 'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      return Left(ServerFailure('Failed to upload return media: $e'));
    }
  }

  @override
  Future<Either<Failure, order_entity.Order>> cancelOrder(int orderId) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRepositoryImpl',
      'method': 'cancelOrder'
    });

    try {
      log.infoWithContext('Cancelling order', {'order_id': orderId});

      final response = await _remoteDatasource.cancelOrder(orderId);

      if (!response.success) {
        log.warnWithContext('Cancel order request unsuccessful', {
          'order_id': orderId,
          'message': response.message,
        });
        return Left(ServerFailure(response.message));
      }

      final cancelledOrder = response.data;
      if (cancelledOrder != null) {
        log.infoWithContext('Order cancelled successfully', {
          'order_id': orderId,
          'source': 'cancel_response',
        });
        return Right(cancelledOrder);
      }

      log.infoWithContext('Cancel succeeded without order payload', {
        'order_id': orderId,
        'action': 'fetch_updated_details',
      });

      final detailsResponse = await _remoteDatasource.getOrderDetails(orderId);
      if (detailsResponse.success && detailsResponse.data != null) {
        return Right(detailsResponse.data!);
      }

      return Left(
        ServerFailure(
          detailsResponse.message.isNotEmpty
              ? detailsResponse.message
              : response.message,
        ),
      );
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server exception cancelling order',
        {'order_id': orderId, 'message': e.message},
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network exception cancelling order',
        {'order_id': orderId, 'message': e.message},
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error cancelling order',
        {'order_id': orderId, 'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      return Left(ServerFailure('Failed to cancel order: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> downloadInvoice({
    required String orderNumber,
    DownloadProgressCallback? onProgress,
  }) async {
    final log = loggerWithContext({
      'feature': 'orders',
      'class': 'OrderRepositoryImpl',
      'method': 'downloadInvoice',
    });

    try {
      log.infoWithContext('Downloading invoice', {
        'order_number': orderNumber,
      });

      // Resolve the device's documents directory and place invoices in
      // a dedicated `invoices/` subfolder so they are easy to find.
      final directory = await getApplicationDocumentsDirectory();
      final invoicesDir = Directory('${directory.path}/invoices');
      if (!await invoicesDir.exists()) {
        await invoicesDir.create(recursive: true);
      }

      final fileName = 'invoice_$orderNumber.pdf';
      final savePath = '${invoicesDir.path}/$fileName';

      final path = await _remoteDatasource.downloadInvoice(
        orderNumber: orderNumber,
        savePath: savePath,
        onProgress: onProgress,
      );

      log.infoWithContext('Invoice downloaded successfully', {
        'order_number': orderNumber,
        'save_path': path,
      });

      return Right(path);
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server exception downloading invoice',
        {'order_number': orderNumber, 'message': e.message},
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network exception downloading invoice',
        {'order_number': orderNumber, 'message': e.message},
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error downloading invoice',
        {
          'order_number': orderNumber,
          'error_type': e.runtimeType.toString(),
        },
        e,
        stackTrace,
      );
      return Left(ServerFailure('Failed to download invoice: $e'));
    }
  }
}
