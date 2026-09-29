import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_item.dart';
import 'package:taksh_e_commerce/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:taksh_e_commerce/features/orders/presentation/cubit/orders_state.dart';
import 'package:taksh_e_commerce/features/orders/presentation/pages/return_request_page.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_ecommerce_product_details.dart';
import 'package:url_launcher/url_launcher.dart';

/// Order details page - displays detailed information about a specific order
class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  bool _isCancellingOrder = false;

  /// Cached order details so the page keeps rendering the content even
  /// when the cubit briefly transitions through transient states such as
  /// [DownloadingInvoice] or [OrdersInitial] (e.g. on first build
  /// before [fetchOrderDetails] emits [OrderDetailsLoading]).
  Order? _lastLoadedOrder;

  @override
  void initState() {
    super.initState();
    // Fetch order details when page loads
    context.read<OrdersCubit>().fetchOrderDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.orderDetails),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? AppColors.primaryOrange
            : Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.light
              ? IndiaGradients.subtleTricolor
              : null,
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).scaffoldBackgroundColor
              : null,
        ),
        child: BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is OrdersError) {
              if (_isCancellingOrder) {
                setState(() {
                  _isCancellingOrder = false;
                });
              }
              AppErrorToast.show(context, message: state.message);
            } else if (state is OrderDetailsLoaded) {
              // Cache the latest order so the page keeps rendering
              // content while transient states (e.g. DownloadingInvoice)
              // flow through the cubit.
              _lastLoadedOrder = state.order;
            } else if (state is OrderStatusUpdating) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Processing update...'),
                  duration: Duration(seconds: 1),
                ),
              );
            } else if (state is OrderStatusUpdated) {
              if (_isCancellingOrder) {
                _isCancellingOrder = false;
                _completeCancelFlow(state.message);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                context.read<OrdersCubit>().fetchOrderDetails(state.orderId);
              }
            }
          },
          builder: (context, state) {
            if (state is OrderDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrderDetailsLoaded) {
              return _buildOrderDetails(context, state.order);
            }

            if (state is OrderStatusUpdating) {
              return const Center(child: CircularProgressIndicator());
            }

            // While an invoice is being downloaded we keep the order
            // details visible (the progress is shown in a modal
            // dialog). The same applies to the OrdersInitial state
            // and the post-success InvoiceDownloaded state.
            final cached = _lastLoadedOrder;
            if (cached != null &&
                (state is DownloadingInvoice ||
                    state is InvoiceDownloaded ||
                    state is OrdersInitial)) {
              return _buildOrderDetails(context, cached);
            }

            return Center(
              child: Text(AppLocalizations.of(context)!.somethingWentWrong),
            );
          },
        ),
      ),
    );
  }

  /// Build order details content
  Widget _buildOrderDetails(BuildContext context, Order order) {
    return SingleChildScrollView(
      // padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header card
          _buildOrderHeaderCard(order),
          const SizedBox(height: 16),

          // Order status timeline
          _buildOrderTimelineSection(order),
          const SizedBox(height: 16),

          // Order items
          _buildOrderItemsSection(order),
          const SizedBox(height: 16),

          // Order summary with payment details
          _buildOrderSummarySection(order),
          const SizedBox(height: 16),

          // Delivery address
          if (order.address != null) ...[
            _buildDeliveryAddressSection(order),
            const SizedBox(height: 16),
          ],

          const SizedBox(height: 8),

          // Action buttons
          _buildActionButtons(order),
        ],
      ),
    );
  }

  /// Build order header card
  Widget _buildOrderHeaderCard(Order order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.orderNumber(order.orderNumber),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.placedOn(_formatDate(order.createdAt)),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(order.orderStatus),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.local_shipping_outlined,
              AppLocalizations.of(context)!.deliveryType,
              _formatDeliveryType(context, order.deliveryType, order.isExpress),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.payment_outlined,
              AppLocalizations.of(context)!.paymentMethod,
              order.paymentMethod.toUpperCase(),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.account_balance_wallet_outlined,
              AppLocalizations.of(context)!.paymentStatus,
              order.paymentStatus.toUpperCase(),
              valueColor: order.paymentStatus.toLowerCase() == 'paid'
                  ? Colors.green
                  : Colors.orange,
            ),
            if (order.estimatedDeliveryTime != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.access_time,
                AppLocalizations.of(context)!.estimatedDelivery,
                _formatDate(order.estimatedDeliveryTime!),
              ),
            ],
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _downloadInvoice(order),
                    icon: const Icon(Icons.download_outlined, size: 18),
                    label: Text(AppLocalizations.of(context)!.invoice),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: const BorderSide(color: Colors.green, width: 1.5),
                      foregroundColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (![
                  'delivered',
                  'cancelled',
                  'returned',
                ].contains(order.orderStatus.toLowerCase()))
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _cancelOrder(order),
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: Text(AppLocalizations.of(context)!.cancelOrder),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build order status timeline section
  Widget _buildOrderTimelineSection(Order order) {
    final timelineSteps = _buildTimelineSteps(order);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              timelineSteps.length,
              (index) => _buildTimelineStepTile(
                step: timelineSteps[index],
                isLast: index == timelineSteps.length - 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStepTile({
    required _OrderTimelineStep step,
    required bool isLast,
  }) {
    const completedColor = Colors.green;
    final pendingColor = Colors.grey.shade400;
    final indicatorColor = step.isCompleted ? completedColor : pendingColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: step.isCompleted ? completedColor : Colors.white,
                    border: Border.all(color: indicatorColor, width: 2),
                  ),
                  child: step.isCompleted
                      ? const Icon(Icons.check, size: 10, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: step.isCompleted ? completedColor : pendingColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: step.isCompleted
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  if (step.timeLabel.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      step.timeLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<_OrderTimelineStep> _buildTimelineSteps(Order order) {
    final normalizedStatus = order.orderStatus.toLowerCase();
    final currentRank = _timelineStatusRank(normalizedStatus);

    return [
      _OrderTimelineStep(
        title: 'Order Placed',
        subtitle: 'Your order has been placed successfully',
        timeLabel: _formatTimelineDateTime(order.createdAt),
        isCompleted: currentRank >= 0,
      ),
      _OrderTimelineStep(
        title: 'Order Confirmed',
        subtitle: 'Seller has processed your order',
        timeLabel: _formatTimelineDateTime(order.confirmedAt),
        isCompleted: currentRank >= 1,
      ),
      _OrderTimelineStep(
        title: 'Shipped',
        subtitle: 'Your item has been picked up by the courier',
        timeLabel: _formatTimelineDateTime(_inferShippedTime(order)),
        isCompleted: currentRank >= 2,
      ),
      _OrderTimelineStep(
        title: 'Out for Delivery',
        subtitle: 'Your item is out for delivery',
        timeLabel: _formatTimelineDateTime(_inferOutForDeliveryTime(order)),
        isCompleted: currentRank >= 3,
      ),
      _OrderTimelineStep(
        title: 'Delivered',
        subtitle: 'Your order has been delivered',
        timeLabel: _formatTimelineDateTime(order.deliveredAt),
        isCompleted: currentRank >= 4,
      ),
    ];
  }

  int _timelineStatusRank(String status) {
    switch (status) {
      case 'placed':
      case 'pending':
      case 'new':
        return 0;
      case 'confirmed':
      case 'ready_for_dispatch':
      case 'processing':
        return 1;
      case 'shipped':
      case 'dispatched':
      case 'picked_up':
        return 2;
      case 'out_for_delivery':
        return 3;
      case 'delivered':
        return 4;
      case 'cancelled':
      case 'returned':
        if (status == 'cancelled') {
          return 0;
        }
        return 4;
      default:
        return 0;
    }
  }

  DateTime? _inferShippedTime(Order order) {
    if (_timelineStatusRank(order.orderStatus.toLowerCase()) < 2) {
      return null;
    }

    return order.deliveredAt ??
        order.estimatedDeliveryTime ??
        order.confirmedAt ??
        order.updatedAt;
  }

  DateTime? _inferOutForDeliveryTime(Order order) {
    if (_timelineStatusRank(order.orderStatus.toLowerCase()) < 3) {
      return null;
    }

    return order.deliveredAt ?? order.estimatedDeliveryTime ?? order.updatedAt;
  }

  String _formatTimelineDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }

    return _formatDateTimeWithMonth(dateTime);
  }

  /// Build order items section
  Widget _buildOrderItemsSection(Order order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.orderItems(order.items.length),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...order.items.map((item) => _buildOrderItemCard(order, item)),
          ],
        ),
      ),
    );
  }

  /// Build individual order item card
  Widget _buildOrderItemCard(Order order, OrderItem item) {
    final productName =
        item.productName ?? item.productVariant?.product?.name ?? 'Product';
    final sku = item.productVariant?.sku ?? '';
    final qty = item.qty;
    final price = item.price;
    final totalPrice = (double.tryParse(price) ?? 0) * qty;
    final canReturn = order.orderStatus.toLowerCase() == 'delivered';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OrderItemThumbnail(item: item),
              const SizedBox(width: 12),
              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    if (sku.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'SKU: $sku',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.qtyPrice(qty, price),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Price
              Text(
                '₹${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.primaryOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          // Return button (only for delivered orders)
          if (canReturn) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showReturnRequest(item),
                icon: const Icon(Icons.keyboard_return, size: 18),
                label: Text(AppLocalizations.of(context)!.returnItem),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  side: const BorderSide(
                    color: AppColors.primaryOrange,
                    width: 1.5,
                  ),
                  foregroundColor: AppColors.primaryOrange,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build delivery address section
  Widget _buildDeliveryAddressSection(Order order) {
    final address = order.address!;
    final addressLine = [
      address.addressLine1,
      address.addressLine2,
    ].where((line) => line != null && line.trim().isNotEmpty).join(', ');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryOrange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.deliveryAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              address.name,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              address.mobile,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              addressLine,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${address.landmark != null && address.landmark!.isNotEmpty ? '${address.landmark}, ' : ''}${address.pincode}',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build order summary section
  Widget _buildOrderSummarySection(Order order) {
    final subtotal =
        _parseAmount(order.subtotalAmount) ??
        order.items.fold<double>(
          0,
          (sum, item) => sum + ((double.tryParse(item.price) ?? 0) * item.qty),
        );
    final deliveryCharges = _parseAmount(order.deliveryCharges);
    final platformFee = _parseAmount(order.platformFee);
    final cgst = _parseAmount(order.cgst);
    final sgst = _parseAmount(order.sgst);
    final discount = _parseAmount(order.discountAmount);
    final explicitTotalAmount = _parseAmount(order.totalAmount);
    final hasKnownPaymentBreakdown =
        deliveryCharges != null ||
        platformFee != null ||
        cgst != null ||
        sgst != null ||
        discount != null ||
        order.extraCharges.isNotEmpty;

    final extraChargesNet = order.extraCharges.fold<double>(0, (sum, charge) {
      final amount = _parseAmount(charge.amount) ?? 0;
      final isDiscount = charge.isDiscount || amount < 0;
      return sum + (isDiscount ? -amount.abs() : amount.abs());
    });

    final fallbackCalculatedTotal =
        subtotal +
        (deliveryCharges ?? 0) +
        (platformFee ?? 0) +
        (cgst ?? 0) +
        (sgst ?? 0) -
        (discount?.abs() ?? 0) +
        extraChargesNet;

    final hasReliableExplicitTotal =
        explicitTotalAmount != null &&
        (explicitTotalAmount > 0 ||
            (hasKnownPaymentBreakdown && explicitTotalAmount == 0));

    final totalAmount = hasReliableExplicitTotal
        ? explicitTotalAmount
        : (fallbackCalculatedTotal > 0 ? fallbackCalculatedTotal : subtotal);

    final inferredOtherCharges =
        !hasKnownPaymentBreakdown && hasReliableExplicitTotal
        ? (totalAmount - subtotal)
        : null;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.orderSummary,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              AppLocalizations.of(context)!.paymentMethod,
              order.paymentMethod.toUpperCase(),
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
              AppLocalizations.of(context)!.paymentStatus,
              order.paymentStatus.toUpperCase(),
              valueColor: order.paymentStatus.toLowerCase() == 'paid'
                  ? Colors.green
                  : Colors.orange,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              AppLocalizations.of(context)!.subtotal,
              '₹${subtotal.toStringAsFixed(2)}',
            ),

            if (deliveryCharges != null) ...[
              const SizedBox(height: 8),
              _buildSummaryRow(
                AppLocalizations.of(context)!.deliveryCharges,
                '₹${deliveryCharges.toStringAsFixed(2)}',
                valueColor: deliveryCharges == 0 ? Colors.green : null,
              ),
            ],

            if (platformFee != null) ...[
              const SizedBox(height: 8),
              _buildSummaryRow(
                AppLocalizations.of(context)!.platformFee,
                '₹${platformFee.toStringAsFixed(2)}',
              ),
            ],

            if (cgst != null) ...[
              const SizedBox(height: 8),
              _buildSummaryRow(
                AppLocalizations.of(context)!.cgst,
                '₹${cgst.toStringAsFixed(2)}',
              ),
            ],

            if (sgst != null) ...[
              const SizedBox(height: 8),
              _buildSummaryRow(
                AppLocalizations.of(context)!.sgst,
                '₹${sgst.toStringAsFixed(2)}',
              ),
            ],

            if (discount != null && discount != 0) ...[
              const SizedBox(height: 8),
              _buildSummaryRow(
                AppLocalizations.of(context)!.discountLabel,
                '- ₹${discount.abs().toStringAsFixed(2)}',
                valueColor: Colors.green,
              ),
            ],

            ...order.extraCharges.map((charge) {
              final amount = _parseAmount(charge.amount) ?? 0;
              final isDiscount = charge.isDiscount || amount < 0;
              final normalizedAmount = amount.abs();

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildSummaryRow(
                  charge.label,
                  '${isDiscount ? '- ' : ''}₹${normalizedAmount.toStringAsFixed(2)}',
                  valueColor: isDiscount ? Colors.green : null,
                ),
              );
            }),

            if (inferredOtherCharges != null && inferredOtherCharges != 0) ...[
              const SizedBox(height: 8),
              _buildSummaryRow(
                AppLocalizations.of(context)!.otherCharges,
                '${inferredOtherCharges < 0 ? '- ' : ''}₹${inferredOtherCharges.abs().toStringAsFixed(2)}',
                valueColor: inferredOtherCharges < 0 ? Colors.green : null,
              ),
            ],

            const Divider(height: 24),
            _buildSummaryRow(
              AppLocalizations.of(context)!.totalAmount,
              '₹${totalAmount.toStringAsFixed(2)}',
              isBold: true,
              valueColor: AppColors.primaryOrange,
            ),
          ],
        ),
      ),
    );
  }

  double? _parseAmount(String? value) {
    if (value == null) {
      return null;
    }

    final normalized = value.replaceAll(',', '').trim();
    if (normalized.isEmpty) {
      return null;
    }

    return double.tryParse(normalized);
  }

  /// Build action buttons
  Widget _buildActionButtons(Order order) {
    final canReturn = order.orderStatus.toLowerCase() == 'delivered';

    return Column(
      children: [
        if (canReturn)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _openReturnRequestPage(order: order);
              },
              icon: const Icon(Icons.keyboard_return),
              label: Text(AppLocalizations.of(context)!.returnOrder),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: AppColors.primaryOrange),
                foregroundColor: AppColors.primaryOrange,
              ),
            ),
          ),
        if (canReturn) const SizedBox(height: 16),

        // Need Help Section
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.help_outline,
                      color: AppColors.primaryOrange,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.needHelp,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.orderIssues,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openWhatsApp,
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: Text(AppLocalizations.of(context)!.chatWithUs),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openEmail,
                    icon: const Icon(Icons.email_outlined),
                    label: Text(AppLocalizations.of(context)!.sendEmail),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.primaryOrange),
                      foregroundColor: AppColors.primaryOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build info row
  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.grey600),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// Build summary row
  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Build status chip
  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'ready_for_dispatch':
        backgroundColor = Colors.orange.withOpacity(0.15);
        textColor = Colors.orange.shade400;
        displayText = AppLocalizations.of(
          context,
        )!.readyForDispatch.toUpperCase();
        break;
      case 'dispatched':
        backgroundColor = Colors.blue.withOpacity(0.15);
        textColor = Colors.blue.shade400;
        displayText = AppLocalizations.of(context)!.dispatched.toUpperCase();
        break;
      case 'delivered':
        backgroundColor = Colors.green.withOpacity(0.15);
        textColor = Colors.green.shade400;
        displayText = AppLocalizations.of(context)!.delivered.toUpperCase();
        break;
      default:
        backgroundColor = Theme.of(context).dividerColor.withOpacity(0.1);
        textColor =
            Theme.of(context).textTheme.bodySmall?.color ?? AppColors.grey700;
        displayText = status.toUpperCase().replaceAll('_', ' ');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Format date to readable string
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Format date to DD month YYYY (e.g. 09 March 2026)
  String _formatDateWithMonth(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];

    return '$day $month ${date.year}';
  }

  /// Format datetime to DD month YYYY at HH:mm (e.g. 09 March 2026 at 20:08)
  String _formatDateTimeWithMonth(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '${_formatDateWithMonth(date)} at $hour:$minute';
  }

  /// Format delivery type
  String _formatDeliveryType(
    BuildContext context,
    String type,
    bool isExpress,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (isExpress || type.toLowerCase() == '30_min') {
      return '${l10n.quickDelivery} (30 min)';
    }
    switch (type.toLowerCase()) {
      case 'normal':
      case '1_day':
        return 'Normal Delivery';
      default:
        return type.toUpperCase();
    }
  }

  /// Show return request bottom sheet for specific item
  Future<void> _showReturnRequest(OrderItem item) async {
    final didSubmit = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<OrdersCubit>(),
          child: ReturnRequestPage(
            orderId: widget.orderId,
            items: [item],
            initialSelectedItem: item,
          ),
        ),
      ),
    );

    if (didSubmit == true && mounted) {
      context.read<OrdersCubit>().fetchOrderDetails(widget.orderId);
    }
  }

  /// Open return request page for full order flow.
  Future<void> _openReturnRequestPage({required Order order}) async {
    final didSubmit = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<OrdersCubit>(),
          child: ReturnRequestPage(orderId: order.id, items: order.items),
        ),
      ),
    );

    if (didSubmit == true && mounted) {
      context.read<OrdersCubit>().fetchOrderDetails(order.id);
    }
  }

  /// Download the invoice PDF for the given order.
  ///
  /// Shows a modal progress dialog while the file is being downloaded
  /// and opens the PDF with the system viewer once the download
  /// completes. On failure, the error is surfaced through the existing
  /// OrdersError toast.
  Future<void> _downloadInvoice(Order order) async {
    if (order.orderNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invoice is not available for this order.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Capture the cubit from the page's context BEFORE showing the
    // dialog. The dialog is rendered in a separate Navigator overlay
    // that does not inherit the BlocProvider from the page, so we
    // re-provide it inside the dialog via BlocProvider.value.
    final cubit = context.read<OrdersCubit>();
    _showInvoiceDownloadDialog(context, cubit, order.orderNumber);

    await cubit.downloadInvoice(order.orderNumber);
  }

  void _showInvoiceDownloadDialog(
    BuildContext context,
    OrdersCubit cubit,
    String orderNumber,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider<OrdersCubit>.value(
          value: cubit,
          child: BlocConsumer<OrdersCubit, OrdersState>(
            listenWhen: (previous, current) =>
                current is DownloadingInvoice ||
                current is InvoiceDownloaded ||
                current is OrdersError,
            listener: (dialogContext, state) {
              if (state is InvoiceDownloaded &&
                  state.orderNumber == orderNumber) {
                Navigator.of(dialogContext).pop();
                _onInvoiceDownloaded(context, state);
              } else if (state is OrdersError) {
                Navigator.of(dialogContext).pop();
              }
            },
            buildWhen: (previous, current) => current is DownloadingInvoice,
            builder: (dialogContext, state) {
              final progress = state is DownloadingInvoice
                  ? state.progress.clamp(0.0, 1.0)
                  : 0.0;
              return PopScope(
                canPop: false,
                child: AlertDialog(
                  title: const Text('Downloading invoice'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.receipt_long,
                        size: 48,
                        color: AppColors.primaryOrange,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Order #$orderNumber',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryOrange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: Theme.of(dialogContext)
                              .textTheme
                              .bodySmall
                              ?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _onInvoiceDownloaded(BuildContext context, InvoiceDownloaded state) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Invoice for order #${state.orderNumber} downloaded successfully',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OPEN',
          textColor: Colors.white,
          onPressed: () => _openInvoiceFile(context, state.filePath),
        ),
      ),
    );
  }

  Future<void> _openInvoiceFile(
    BuildContext context,
    String filePath,
  ) async {
    try {
      final result = await OpenFilex.open(filePath);
      if (result.type != ResultType.done && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open invoice (${result.message}). '
              'File saved at: $filePath',
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open invoice. File saved at: $filePath',
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  /// Mock function to cancel order (simulates API call)
  Future<void> _cancelOrder(Order order) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.cancelOrder),
        content: Text(
          'Are you sure you want to cancel order #${order.orderNumber}?', // Keep number formatted
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context)!.exit, // Or 'Yes, Cancel'
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _isCancellingOrder = true;
      });
      context.read<OrdersCubit>().cancelOrder(order.id);
    }
  }

  void _completeCancelFlow(String message) {
    if (!mounted) {
      return;
    }

    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop<String>(message);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
    context.go(AppRoutes.orders);
  }

  /// Open WhatsApp chat
  Future<void> _openWhatsApp() async {
    final whatsappUrl = Uri.parse(
      'https://wa.me/919999999999?text=Hi, I need help with my order',
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        AppErrorToast.show(context);
      }
    }
  }

  /// Open email client
  Future<void> _openEmail() async {
    final emailUrl = Uri.parse(
      'mailto:support@taksh.com?subject=Order Support Request&body=Hi, I need help with my order',
    );

    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl);
    } else {
      if (mounted) {
        AppErrorToast.show(context);
      }
    }
  }
}

class _OrderItemThumbnail extends StatefulWidget {
  const _OrderItemThumbnail({required this.item});

  final OrderItem item;

  @override
  State<_OrderItemThumbnail> createState() => _OrderItemThumbnailState();
}

class _OrderItemThumbnailState extends State<_OrderItemThumbnail> {
  static final Map<int, String?> _productImageCache = <int, String?>{};
  static final Map<int, Future<String?>> _pendingProductImages =
      <int, Future<String?>>{};

  String? _resolvedImageUrl;

  @override
  void initState() {
    super.initState();
    _initializeImage();
  }

  @override
  void didUpdateWidget(covariant _OrderItemThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.item.id != widget.item.id ||
        oldWidget.item.image != widget.item.image ||
        oldWidget.item.productVariant?.product?.id !=
            widget.item.productVariant?.product?.id ||
        oldWidget.item.productVariant?.productId !=
            widget.item.productVariant?.productId) {
      _initializeImage();
    }
  }

  void _initializeImage() {
    _resolvedImageUrl = _normalizeImageUrl(widget.item.image);
    if (_resolvedImageUrl != null) {
      return;
    }

    final productId =
        widget.item.productVariant?.product?.id ??
        widget.item.productVariant?.productId;
    if (productId == null) {
      return;
    }

    if (_productImageCache.containsKey(productId)) {
      _resolvedImageUrl = _normalizeImageUrl(_productImageCache[productId]);
      return;
    }

    _resolveMissingImage(productId);
  }

  Future<void> _resolveMissingImage(int productId) async {
    final future = _pendingProductImages.putIfAbsent(productId, () async {
      final result = await getIt<GetEcommerceProductDetails>()(
        GetEcommerceProductDetailsParams(productId: productId),
      );

      return result.fold(
        (_) => null,
        (product) => _normalizeImageUrl(product.primaryImageUrl),
      );
    });

    final imageUrl = await future;
    _pendingProductImages.remove(productId);
    _productImageCache[productId] = imageUrl;

    if (!mounted) {
      return;
    }

    setState(() {
      _resolvedImageUrl = imageUrl;
    });
  }

  String? _normalizeImageUrl(String? rawImageUrl) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: _resolvedImageUrl != null
            ? Image.network(
                _resolvedImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.shopping_bag_outlined,
                  color: Theme.of(context).disabledColor,
                  size: 30,
                ),
              )
            : Icon(
                Icons.shopping_bag_outlined,
                color: Theme.of(context).disabledColor,
                size: 30,
              ),
      ),
    );
  }
}

class _OrderTimelineStep {
  final String title;
  final String subtitle;
  final String timeLabel;
  final bool isCompleted;

  const _OrderTimelineStep({
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.isCompleted,
  });
}
