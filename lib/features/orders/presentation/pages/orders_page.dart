import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/core/widgets/guest_auth_wall.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_item.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_address.dart';
import 'package:taksh_e_commerce/features/orders/domain/usecases/get_order_details.dart';
import 'package:taksh_e_commerce/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:taksh_e_commerce/features/orders/presentation/cubit/orders_state.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_ecommerce_product_details.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Orders page - displays user's orders history
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    // Only fetch orders if the user is authenticated
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<OrdersCubit>().fetchOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! Authenticated) {
          return const GuestAuthWall(
            redirectToRoute: AppRoutes.orders,
            contentLabel: 'your orders',
            icon: Icons.receipt_long_outlined,
          );
        }
        return _buildOrdersContent(context);
      },
    );
  }

  Widget _buildOrdersContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: AppColors.secondaryGreen,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.myOrders,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: BlocBuilder<OrdersCubit, OrdersState>(
                        builder: (context, state) {
                          if (state is OrdersLoaded) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${state.orders.total} orders',
                                style: const TextStyle(
                                  color: AppColors.secondaryGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Track and manage your orders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is OrdersError) {
              AppErrorToast.show(context);
            } else if (state is OrderStatusUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrdersLoaded) {
              final orders = state.orders.orders;
              final cubit = context.read<OrdersCubit>();

              if (orders.isEmpty &&
                  cubit.currentStatusFilter == null &&
                  cubit.currentDeliveryTypeFilter == null &&
                  cubit.currentDateFilter == null) {
                return _buildEmptyOrders(context);
              }

              return Column(
                children: [
                  // Filter and Sort Controls
                  _buildFilterSortControls(cubit, state.filter),
                  // Orders List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<OrdersCubit>().fetchOrders();
                      },
                      child: orders.isEmpty
                          ? _buildNoResultsFound()
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                                return _buildOrderCard(context, orders[index]);
                              },
                            ),
                    ),
                  ),
                ],
              );
            }

            // Initial state or error state
            return _buildEmptyOrders(context);
          },
        ),
      ),
    );
  }

  /// Build filter and sort controls
  Widget _buildFilterSortControls(
    OrdersCubit cubit,
    String? currentFilterState,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final deliveryOptions = <Map<String, String?>>[
      {'key': null, 'label': 'All Delivery Types'},
      {'key': 'normal', 'label': l10n.standardDelivery},
      {'key': '30_min', 'label': l10n.quickDelivery},
    ];
    final statusOptions = <Map<String, String?>>[
      {'key': null, 'label': 'All Statuses'},
      {'key': 'ready_for_dispatch', 'label': 'Processing'},
      {'key': 'pending', 'label': 'Pending'},
    ];

    final statusFilterValue = currentFilterState == 'all'
        ? null
        : (currentFilterState ?? cubit.currentStatusFilter);
    final selectedDeliveryType =
        deliveryOptions.any(
          (option) => option['key'] == cubit.currentDeliveryTypeFilter,
        )
        ? cubit.currentDeliveryTypeFilter
        : null;
    final selectedStatus =
        statusOptions.any((option) => option['key'] == statusFilterValue)
        ? statusFilterValue
        : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.secondaryGreen),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String?>(
              initialValue: selectedDeliveryType,
              isExpanded: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                hintText: l10n.deliveryType,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              items: deliveryOptions.map((option) {
                return DropdownMenuItem<String?>(
                  value: option['key'],
                  child: Text(option['label']!),
                );
              }).toList(),
              onChanged: cubit.updateDeliveryTypeFilter,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String?>(
              initialValue: selectedStatus,
              isExpanded: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                hintText: 'Delivery Status',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              items: statusOptions.map((option) {
                return DropdownMenuItem<String?>(
                  value: option['key'],
                  child: Text(option['label']!),
                );
              }).toList(),
              onChanged: cubit.updateStatusFilter,
            ),
          ),
          const SizedBox(width: 8),
          _buildDateFilterChip(cubit),
        ],
      ),
    );
  }

  /// Build the calendar date filter chip placed beside the dropdown filters.
  ///
  /// Shows a compact calendar icon when no date is selected and a pill with
  /// the selected date plus a clear button when a date is active.
  Widget _buildDateFilterChip(OrdersCubit cubit) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDate = cubit.currentDateFilter;
    final hasDate = selectedDate != null;

    return Tooltip(
      message: l10n.filterByDate,
      child: GestureDetector(
        onTap: _showDateFilterPicker,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: hasDate ? 10 : 12,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: hasDate ? AppColors.secondaryGreen : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: hasDate
                ? Border.all(color: Colors.white.withOpacity(0.6))
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: hasDate ? Colors.white : AppColors.secondaryGreen,
              ),
              if (hasDate) ...[
                const SizedBox(width: 6),
                Text(
                  _formatDateLong(selectedDate),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 2),
                GestureDetector(
                  onTap: () => cubit.updateDateFilter(null),
                  behavior: HitTestBehavior.opaque,
                  child: Tooltip(
                    message: l10n.clearDateFilter,
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Open the Material date picker to choose an order date filter.
  ///
  /// The selectable range is bounded to the last two years up to today so that
  /// users cannot pick future dates (which would always yield no orders).
  Future<void> _showDateFilterPicker() async {
    final cubit = context.read<OrdersCubit>();
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 2, now.month, now.day);

    // Clamp the initial date into the selectable range to satisfy the picker's
    // assertion that firstDate <= initialDate <= lastDate.
    DateTime initialDate = cubit.currentDateFilter ?? now;
    if (initialDate.isBefore(firstDate)) initialDate = firstDate;
    if (initialDate.isAfter(now)) initialDate = now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: now,
      helpText: AppLocalizations.of(context)!.filterByDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.secondaryGreen,
              onPrimary: Colors.white,
              onSurface:
                  Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      cubit.updateDateFilter(picked);
    }
  }

  /// Build no results found view
  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noOrdersFound,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.tryAdjustingFilters,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty orders view
  Widget _buildEmptyOrders(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.2),
                  blurRadius: 20,
                ),
              ],
            ),
            child: const Icon(
              Icons.receipt_long,
              size: 60,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.noOrdersYet,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.yourOrdersAppearHere,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              gradient: IndiaGradients.greenGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondaryGreen.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                context.push(AppRoutes.home);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.startShopping,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual order card
  Widget _buildOrderCard(BuildContext context, Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          final statusMessage = await context.push<String?>(
            AppRoutes.orderDetails(order.id.toString()),
          );

          if (!mounted || statusMessage == null) {
            return;
          }

          this.context.read<OrdersCubit>().fetchOrders();
          ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              content: Text(statusMessage),
              backgroundColor: Colors.green,
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID and Statuses
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#ORD-${order.orderNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(child: _buildStatusChip(order.orderStatus)),
                        // Payment status chip intentionally hidden for now.
                        // Keep this commented so we can re-enable quickly if
                        // product requirements change.
                        // const SizedBox(width: 4),
                        // Flexible(
                        //   child: _buildPaymentStatusChip(
                        //     order.paymentStatus,
                        //     order.paymentMethod,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Price and Date Row
              Row(
                children: [
                  Text(
                    '₹${order.totalAmount}',
                    style: const TextStyle(
                      color: AppColors.secondaryGreen,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 1, height: 14, color: Colors.grey.shade300),
                  const SizedBox(width: 8),
                  Text(
                    'Placed on ${_formatDateLong(order.createdAt)}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Delivery Type Info
              Row(
                children: [
                  Icon(
                    order.isExpress || order.deliveryType.toLowerCase() == '30_min'
                        ? Icons.flash_on_outlined
                        : Icons.local_shipping_outlined,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDeliveryTypeLabel(context, order),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Address Section
              if (order.address != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: AppColors.secondaryGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _formatAddress(order.address!),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              // Product Preview Section
              _OrderProductPreview(
                order: order,
                resolveImageUrl: _resolveOrderItemImageUrl,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDeliveryTypeLabel(BuildContext context, Order order) {
    final l10n = AppLocalizations.of(context)!;
    if (order.isExpress || order.deliveryType.toLowerCase() == '30_min') {
      return l10n.quickDelivery;
    }

    return l10n.standardDelivery;
  }

  String? _resolveOrderItemImageUrl(String? rawImageUrl) {
    final normalized = rawImageUrl?.trim();
    if (normalized == null ||
        normalized.isEmpty ||
        normalized.toLowerCase() == 'null') {
      return null;
    }

    final imageUri = Uri.tryParse(normalized);
    if (imageUri != null && imageUri.hasScheme) {
      return normalized;
    }

    final apiBaseUri = Uri.parse(ApiConstants.prodBaseUrl);
    final originUri = apiBaseUri.replace(path: '', query: '', fragment: '');
    final origin = originUri.toString().replaceAll(RegExp(r'/$'), '');

    if (normalized.startsWith('/')) {
      return '$origin$normalized';
    }

    return '$origin/$normalized';
  }

  /// Build status chip
  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText = status.toUpperCase().replaceAll('_', ' ');

    switch (status.toLowerCase()) {
      case 'ready_for_dispatch':
      case 'processing':
        backgroundColor = const Color(0xFFFFE0B2);
        textColor = const Color(0xFFE65100);
        displayText = 'Processing';
        break;
      case 'dispatched':
        backgroundColor = const Color(0xFFE1F5FE);
        textColor = const Color(0xFF01579B);
        break;
      case 'delivered':
        backgroundColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        break;
      case 'cancelled':
        backgroundColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFB71C1C);
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Build payment status chip
  // ignore: unused_element
  Widget _buildPaymentStatusChip(String status, String method) {
    bool isPaid = status.toLowerCase() == 'paid';
    Color backgroundColor = isPaid
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFF3E0);
    Color textColor = isPaid
        ? const Color(0xFF2E7D32)
        : const Color(0xFFEF6C00);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Format address object to string
  String _formatAddress(OrderAddress address) {
    final parts =
        [
              address.addressLine1,
              if (address.addressLine2 != null &&
                  address.addressLine2!.isNotEmpty)
                address.addressLine2,
              if (address.landmark != null && address.landmark!.isNotEmpty)
                address.landmark,
              address.state?.name,
              address.city?.name,
              address.area?.name,
              address.pincode,
            ]
            .where((part) => part != null && part.toString().trim().isNotEmpty)
            .toList();

    return parts.join(', ');
  }

  /// Format date to long format (e.g. Sep 27, 2025)
  String _formatDateLong(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _OrderProductPreview extends StatefulWidget {
  const _OrderProductPreview({
    required this.order,
    required this.resolveImageUrl,
  });

  final Order order;
  final String? Function(String?) resolveImageUrl;

  @override
  State<_OrderProductPreview> createState() => _OrderProductPreviewState();
}

class _OrderProductPreviewState extends State<_OrderProductPreview> {
  static final Map<int, List<OrderItem>> _orderItemsCache = {};
  static final Map<int, Future<List<OrderItem>>> _pendingOrderItems = {};
  static final Map<int, String?> _productImageCache = {};
  static final Map<int, Future<String?>> _pendingProductImages = {};

  late List<OrderItem> _items;
  final Map<int, String?> _resolvedItemImages = <int, String?>{};

  @override
  void initState() {
    super.initState();
    _initializePreview();
  }

  @override
  void didUpdateWidget(covariant _OrderProductPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.order.id != widget.order.id ||
        oldWidget.order.items != widget.order.items) {
      _initializePreview();
    }
  }

  void _initializePreview() {
    _items = widget.order.items;
    _resolvedItemImages.clear();

    if (_needsRemoteResolution(_items)) {
      _resolveMissingPreviewData();
    }
  }

  bool _needsRemoteResolution(List<OrderItem> items) {
    if (items.isEmpty) {
      return false;
    }

    for (final item in _previewItems(items)) {
      if (_resolvedImageUrl(item) == null) {
        return true;
      }
    }

    return false;
  }

  Iterable<OrderItem> _previewItems(List<OrderItem> items) {
    if (items.length <= 1) {
      return items.take(1);
    }

    return items.take(3);
  }

  String? _resolvedImageUrl(OrderItem item) {
    return widget.resolveImageUrl(_resolvedItemImages[item.id] ?? item.image);
  }

  Future<void> _resolveMissingPreviewData() async {
    final orderId = widget.order.id;
    var resolvedItems = widget.order.items;

    final detailItems = await _fetchOrderItems(orderId);
    if (detailItems.isNotEmpty) {
      resolvedItems = detailItems;
    }

    final resolvedProductImages = await _resolveProductImages(resolvedItems);

    if (!mounted || widget.order.id != orderId) {
      return;
    }

    setState(() {
      _items = resolvedItems;
      _resolvedItemImages
        ..clear()
        ..addAll(resolvedProductImages);
    });
  }

  Future<List<OrderItem>> _fetchOrderItems(int orderId) async {
    if (_orderItemsCache.containsKey(orderId)) {
      return _orderItemsCache[orderId]!;
    }

    final future = _pendingOrderItems.putIfAbsent(orderId, () async {
      final result = await getIt<GetOrderDetails>()(orderId);

      return result.fold((_) => <OrderItem>[], (order) => order.items);
    });

    final items = await future;
    _pendingOrderItems.remove(orderId);
    _orderItemsCache[orderId] = items;
    return items;
  }

  Future<Map<int, String?>> _resolveProductImages(List<OrderItem> items) async {
    final resolvedImages = <int, String?>{};

    for (final item in _previewItems(items)) {
      if (_resolvedImageUrl(item) != null) {
        continue;
      }

      final productId = item.productVariant?.product?.id;
      if (productId == null) {
        continue;
      }

      final productImage = await _fetchProductImage(productId);
      if (productImage != null) {
        resolvedImages[item.id] = productImage;
      }
    }

    return resolvedImages;
  }

  Future<String?> _fetchProductImage(int productId) async {
    if (_productImageCache.containsKey(productId)) {
      return _productImageCache[productId];
    }

    final future = _pendingProductImages.putIfAbsent(productId, () async {
      final result = await getIt<GetEcommerceProductDetails>()(
        GetEcommerceProductDetailsParams(productId: productId),
      );

      return result.fold(
        (_) => null,
        (product) => product.primaryImageUrl?.trim(),
      );
    });

    final imageUrl = await future;
    _pendingProductImages.remove(productId);
    _productImageCache[productId] = imageUrl;
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_items.length == 1) {
      return _buildSingleItemPreview(context, _items.first);
    }

    return _buildMultiItemPreview(context, _items);
  }

  Widget _buildSingleItemPreview(BuildContext context, OrderItem item) {
    final imageUrl = _resolvedImageUrl(item);

    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_outlined, color: Colors.grey),
                  )
                : const Icon(Icons.image_outlined, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName ??
                    item.productVariant?.product?.name ??
                    'Product',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (item.brandName != null ||
                  item.productVariant?.product != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    item.brandName != null
                        ? 'by ${item.brandName}'
                        : 'Qty: ${item.qty}',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '₹${item.price} × ${item.qty}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMultiItemPreview(BuildContext context, List<OrderItem> items) {
    return Row(
      children: [
        ...items.take(3).map((item) {
          final imageUrl = _resolvedImageUrl(item);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.image_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                      )
                    : const Icon(
                        Icons.image_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
              ),
            ),
          );
        }),
        if (items.length > 3)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Text(
                '+${items.length - 3}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        const SizedBox(width: 12),
        Text(
          '${items.length} items',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
