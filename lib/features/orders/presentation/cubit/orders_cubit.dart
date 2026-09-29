import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/paginated_orders.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/cancel_order.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/download_invoice.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/get_orders.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/get_order_details.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/place_order.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/request_return.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/upload_return_media.dart';
import 'package:taksh_e_commerce/features/orders/presentation/cubit/orders_state.dart';

/// Enum for order sort options
enum OrderSortBy {
  dateDesc,
  dateAsc,
  amountDesc,
  amountAsc,
  updatedDesc,
  updatedAsc,
}

/// Cubit for managing orders state
class OrdersCubit extends Cubit<OrdersState> {
  final GetOrders getOrders;
  final GetOrderDetails getOrderDetails;
  final PlaceOrder placeOrder;
  final RequestReturn requestReturn;
  final UploadReturnMedia uploadReturnMedia;
  final CancelOrder cancelOrderUsecase;
  final DownloadInvoice downloadInvoiceUsecase;

  // Filter and sort state
  String? _selectedStatus;
  String? _selectedDeliveryType;
  DateTime? _selectedDate;
  OrderSortBy _sortBy = OrderSortBy.dateDesc;
  PaginatedOrders? _originalOrders;

  OrdersCubit({
    required this.getOrders,
    required this.getOrderDetails,
    required this.placeOrder,
    required this.requestReturn,
    required this.uploadReturnMedia,
    required this.cancelOrderUsecase,
    required this.downloadInvoiceUsecase,
  }) : super(const OrdersInitial());

  /// Fetch orders with pagination
  Future<void> fetchOrders({int page = 1}) async {
    emit(const OrdersLoading());

    final result = await getOrders(page: page);

    result.fold((failure) => emit(OrdersError(failure.message)), (orders) {
      _originalOrders = orders;
      _applyFiltersAndSort();
    });
  }

  /// Update filter by status
  void updateStatusFilter(String? status) {
    _selectedStatus = status;
    _applyFiltersAndSort();
  }

  /// Update filter by delivery type ('normal' or '30_min'); pass null to clear
  void updateDeliveryTypeFilter(String? type) {
    _selectedDeliveryType = type;
    _applyFiltersAndSort();
  }

  /// Update filter by a specific date; pass null to clear the date filter
  void updateDateFilter(DateTime? date) {
    _selectedDate = date;
    _applyFiltersAndSort();
  }

  /// Update sort criteria
  void updateSortBy(OrderSortBy sortBy) {
    _sortBy = sortBy;
    _applyFiltersAndSort();
  }

  /// Apply filters and sorting to orders
  void _applyFiltersAndSort() {
    if (_originalOrders == null) return;

    // Apply filtering
    final filteredOrders = _filterOrders(_originalOrders!.orders);

    // Apply sorting
    final sortedOrders = _sortOrders(filteredOrders);

    // Create new PaginatedOrders with filtered and sorted data
    final processedOrders = PaginatedOrders(
      orders: sortedOrders,
      currentPage: _originalOrders!.currentPage,
      firstPageUrl: _originalOrders!.firstPageUrl,
      from: _originalOrders!.from,
      lastPage: _originalOrders!.lastPage,
      lastPageUrl: _originalOrders!.lastPageUrl,
      links: _originalOrders!.links,
      nextPageUrl: _originalOrders!.nextPageUrl,
      path: _originalOrders!.path,
      perPage: _originalOrders!.perPage,
      prevPageUrl: _originalOrders!.prevPageUrl,
      to: _originalOrders!.to,
      total: _originalOrders!.total,
    );

    // Convert sortBy enum to string for the state
    final sortByString = _sortBy.toString().split('.').last;

    emit(
      OrdersLoaded(
        processedOrders,
        filter: _selectedStatus ?? 'all',
        sort: sortByString,
        deliveryTypeFilter: _selectedDeliveryType,
        dateFilter: _selectedDate,
      ),
    );
  }

  /// Filter orders based on selected status, delivery type and/or date (AND logic)
  List<Order> _filterOrders(List<Order> orders) {
    return orders.where((order) {
      final statusMatch = _selectedStatus == null ||
          _selectedStatus == 'all' ||
          order.orderStatus.toLowerCase() == _selectedStatus!.toLowerCase();

      final deliveryMatch = _selectedDeliveryType == null ||
          order.deliveryType.toLowerCase() == _selectedDeliveryType!.toLowerCase();

      final dateMatch = _selectedDate == null ||
          _isSameDay(order.createdAt, _selectedDate!);

      return statusMatch && deliveryMatch && dateMatch;
    }).toList();
  }

  /// Whether two [DateTime]s fall on the same calendar day.
  /// Compares year/month/day so that time-of-day and timezone offsets do not
  /// affect filtering. This matches how the order date is rendered on cards.
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Sort orders based on selected criteria
  List<Order> _sortOrders(List<Order> orders) {
    final sortedOrders = List<Order>.from(orders);

    switch (_sortBy) {
      case OrderSortBy.dateDesc:
        sortedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case OrderSortBy.dateAsc:
        sortedOrders.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case OrderSortBy.amountDesc:
        sortedOrders.sort((a, b) {
          final amountA = double.tryParse(a.totalAmount) ?? 0;
          final amountB = double.tryParse(b.totalAmount) ?? 0;
          return amountB.compareTo(amountA);
        });
        break;
      case OrderSortBy.amountAsc:
        sortedOrders.sort((a, b) {
          final amountA = double.tryParse(a.totalAmount) ?? 0;
          final amountB = double.tryParse(b.totalAmount) ?? 0;
          return amountA.compareTo(amountB);
        });
        break;
      case OrderSortBy.updatedDesc:
        sortedOrders.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case OrderSortBy.updatedAsc:
        sortedOrders.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
    }

    return sortedOrders;
  }

  /// Get current filter status
  String? get currentStatusFilter => _selectedStatus;

  /// Get current delivery type filter
  String? get currentDeliveryTypeFilter => _selectedDeliveryType;

  /// Get current date filter
  DateTime? get currentDateFilter => _selectedDate;

  /// Get current sort criteria
  OrderSortBy get currentSortBy => _sortBy;

  /// Fetch order details by ID
  Future<void> fetchOrderDetails(int orderId) async {
    emit(const OrderDetailsLoading());

    final result = await getOrderDetails(orderId);

    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (order) => emit(OrderDetailsLoaded(order)),
    );
  }

  /// Place a new order
  Future<void> placeNewOrder({
    required int addressId,
    required int warehouseId,
    required String deliveryType,
    required String paymentMethod,
  }) async {
    emit(const PlacingOrder());

    final result = await placeOrder(
      PlaceOrderParams(
        addressId: addressId,
        warehouseId: warehouseId,
        deliveryType: deliveryType,
        paymentMethod: paymentMethod,
      ),
    );

    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (order) => emit(OrderPlaced(order, 'Order placed successfully')),
    );
  }

  /// Request a return for an order item
  Future<void> requestOrderReturn({
    required int orderId,
    required int orderItemId,
    required String reason,
    String? resolution,
  }) async {
    emit(const RequestingReturn());

    final result = await requestReturn(
      RequestReturnParams(
        orderId: orderId,
        orderItemId: orderItemId,
        reason: reason,
        resolution: resolution,
      ),
    );

    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (data) =>
          emit(ReturnRequested('Return request submitted successfully', data)),
    );
  }

  /// Upload images for a return request
  Future<void> uploadReturnImages({
    required String returnId,
    required List<String> imagePaths,
  }) async {
    emit(const UploadingReturnMedia());

    final result = await uploadReturnMedia(
      UploadReturnMediaParams(returnId: returnId, imagePaths: imagePaths),
    );

    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (data) => emit(
        ReturnMediaUploaded('Return images uploaded successfully', data),
      ),
    );
  }

  /// Complete return flow - request return and upload images
  Future<void> completeReturnRequest({
    required int orderId,
    required int orderItemId,
    required String reason,
    required List<String> imagePaths,
    String? resolution,
  }) async {
    // First, request the return
    emit(const RequestingReturn());

    final returnResult = await requestReturn(
      RequestReturnParams(
        orderId: orderId,
        orderItemId: orderItemId,
        reason: reason,
        resolution: resolution,
      ),
    );

    await returnResult.fold(
      (failure) async {
        emit(OrdersError(failure.message));
      },
      (returnData) async {
        // Extract return ID from response data
        final returnId = _extractReturnId(returnData);

        if (returnId == null || imagePaths.isEmpty) {
          // If no return ID or no images, just complete with return request
          emit(
            ReturnRequested(
              'Return request submitted successfully',
              returnData,
            ),
          );
          return;
        }

        // Upload images
        emit(const UploadingReturnMedia());

        final uploadResult = await uploadReturnMedia(
          UploadReturnMediaParams(returnId: returnId, imagePaths: imagePaths),
        );

        uploadResult.fold(
          (failure) => emit(
            OrdersError(
              'Return created but failed to upload images: ${failure.message}',
            ),
          ),
          (uploadData) => emit(
            ReturnCompleted(
              'Return request completed successfully',
              returnData,
              uploadData,
            ),
          ),
        );
      },
    );
  }

  /// Helper method to extract return ID from response data
  String? _extractReturnId(DataMap data) {
    String? fromMap(DataMap map) {
      if (map.containsKey('id') && map['id'] != null) {
        return map['id'].toString();
      }
      if (map.containsKey('return_id') && map['return_id'] != null) {
        return map['return_id'].toString();
      }
      if (map.containsKey('returnId') && map['returnId'] != null) {
        return map['returnId'].toString();
      }
      return null;
    }

    final directId = fromMap(data);
    if (directId != null) {
      return directId;
    }

    final nestedData = data['data'];
    if (nestedData is Map<String, dynamic>) {
      final nestedId = fromMap(nestedData);
      if (nestedId != null) {
        return nestedId;
      }
    }

    final nestedReturn = data['return'];
    if (nestedReturn is Map<String, dynamic>) {
      final nestedId = fromMap(nestedReturn);
      if (nestedId != null) {
        return nestedId;
      }
    }

    return null;
  }

  /// Cancel an order
  Future<void> cancelOrder(int orderId) async {
    emit(const OrderStatusUpdating());

    final result = await cancelOrderUsecase(orderId);

    result.fold((failure) => emit(OrdersError(failure.message)), (order) {
      emit(OrderStatusUpdated('Order cancelled successfully', orderId));
      // Refresh the orders list to reflect the new status
      fetchOrders();
    });
  }

  /// Download the invoice PDF for the given order number.
  ///
  /// Emits [DownloadingInvoice] with progress updates while the file is
  /// being fetched, and [InvoiceDownloaded] with the local file path on
  /// success. On failure, emits [OrdersError] with a user-friendly
  /// message.
  Future<void> downloadInvoice(String orderNumber) async {
    emit(const DownloadingInvoice());

    final result = await downloadInvoiceUsecase(
      orderNumber,
      onProgress: (progress) {
        if (isClosed) return;
        if (state is DownloadingInvoice) {
          emit(DownloadingInvoice(progress: progress));
        }
      },
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (filePath) => emit(
        InvoiceDownloaded(
          orderNumber: orderNumber,
          filePath: filePath,
          message: 'Invoice downloaded successfully',
        ),
      ),
    );
  }
}
