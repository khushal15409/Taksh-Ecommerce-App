import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/paginated_orders.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart'
    as order_entity;

/// Repository interface for order operations
abstract class OrderRepository {
  /// Get all orders with pagination
  Future<Either<Failure, PaginatedOrders>> getOrders({int page = 1});

  /// Get order details by ID
  Future<Either<Failure, order_entity.Order>> getOrderDetails(int orderId);

  /// Place a new order
  Future<Either<Failure, order_entity.Order>> placeOrder({
    required int addressId,
    required int warehouseId,
    required String deliveryType,
    required String paymentMethod,
  });

  /// Request a return for an order item
  Future<Either<Failure, DataMap>> requestReturn({
    required int orderId,
    required int orderItemId,
    required String reason,
    String? resolution,
  });

  /// Upload images for a return request
  Future<Either<Failure, DataMap>> uploadReturnMedia({
    required String returnId,
    required List<String> imagePaths,
  });

  /// Cancel an order
  Future<Either<Failure, order_entity.Order>> cancelOrder(int orderId);

  /// Download the invoice PDF for an order and save it to local storage.
  ///
  /// Returns the absolute file path of the saved invoice on success.
  Future<Either<Failure, String>> downloadInvoice({
    required String orderNumber,
    DownloadProgressCallback? onProgress,
  });
}
