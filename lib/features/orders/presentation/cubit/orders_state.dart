import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/paginated_orders.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart'
    as order_entity;

/// Base state for orders operations
abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

/// Loading state for fetching orders
class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

/// Success state for orders loaded
class OrdersLoaded extends OrdersState {
  final PaginatedOrders orders;
  final String? filter;
  final String? sort;
  final String? deliveryTypeFilter;
  final DateTime? dateFilter;

  const OrdersLoaded(
    this.orders, {
    this.filter,
    this.sort,
    this.deliveryTypeFilter,
    this.dateFilter,
  });

  @override
  List<Object?> get props => [orders, filter, sort, deliveryTypeFilter, dateFilter];
}

/// State when updating order status (e.g., cancelling)
class OrderStatusUpdating extends OrdersState {
  const OrderStatusUpdating();
}

/// State when order status has been updated successfully
class OrderStatusUpdated extends OrdersState {
  final String message;
  final int orderId;

  const OrderStatusUpdated(this.message, this.orderId);

  @override
  List<Object?> get props => [message, orderId];
}

/// Loading state for fetching order details
class OrderDetailsLoading extends OrdersState {
  const OrderDetailsLoading();
}

/// Success state for order details loaded
class OrderDetailsLoaded extends OrdersState {
  final order_entity.Order order;

  const OrderDetailsLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

/// Loading state for placing order
class PlacingOrder extends OrdersState {
  const PlacingOrder();
}

/// Success state for order placed
class OrderPlaced extends OrdersState {
  final order_entity.Order order;
  final String message;

  const OrderPlaced(this.order, this.message);

  @override
  List<Object?> get props => [order, message];
}

/// Loading state for requesting return
class RequestingReturn extends OrdersState {
  const RequestingReturn();
}

/// Success state for return requested
class ReturnRequested extends OrdersState {
  final String message;
  final DataMap data;

  const ReturnRequested(this.message, this.data);

  @override
  List<Object?> get props => [message, data];
}

/// Loading state for uploading return media
class UploadingReturnMedia extends OrdersState {
  const UploadingReturnMedia();
}

/// Success state for return media uploaded
class ReturnMediaUploaded extends OrdersState {
  final String message;
  final DataMap data;

  const ReturnMediaUploaded(this.message, this.data);

  @override
  List<Object?> get props => [message, data];
}

/// Success state for complete return flow (request + upload)
class ReturnCompleted extends OrdersState {
  final String message;
  final DataMap returnData;
  final DataMap uploadData;

  const ReturnCompleted(this.message, this.returnData, this.uploadData);

  @override
  List<Object?> get props => [message, returnData, uploadData];
}

/// Error state
class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Loading state while downloading an order invoice.
class DownloadingInvoice extends OrdersState {
  /// Current progress in the range 0.0 to 1.0.
  final double progress;

  const DownloadingInvoice({this.progress = 0.0});

  @override
  List<Object?> get props => [progress];
}

/// Success state after an order invoice has been downloaded and saved
/// to local storage. [filePath] is the absolute path of the PDF on the
/// device.
class InvoiceDownloaded extends OrdersState {
  final String orderNumber;
  final String filePath;
  final String message;

  const InvoiceDownloaded({
    required this.orderNumber,
    required this.filePath,
    required this.message,
  });

  @override
  List<Object?> get props => [orderNumber, filePath, message];
}
