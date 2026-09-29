import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/features/home_service/domain/entities/service_inquiry.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/cubit/home_service_cubit.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/cubit/home_service_state.dart';
import 'package:url_launcher/url_launcher.dart';

/// History page for courier bookings with tracking stepper and detail view.
class CourierHistoryPage extends StatelessWidget {
  final int? serviceId;

  const CourierHistoryPage({super.key, this.serviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<HomeServiceCubit>()..fetchHistory(serviceId: serviceId),
      child: _CourierHistoryBody(serviceId: serviceId),
    );
  }
}

// ─── Constants ─────────────────────────────────────────────────────────────

final _dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

String _formatDate(DateTime? date) =>
    date != null ? _dateFormat.format(date) : '—';

const _gradientOrange = [Color(0xFFFF6B35), Color(0xFFFFA726)];

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'delivered':
    case 'completed':
      return const Color(0xFF2E7D32);
    case 'pending':
      return const Color(0xFFF57F17);
    case 'confirmed':
    case 'shipped':
      return const Color(0xFF1565C0);
    case 'cancelled':
      return const Color(0xFFC62828);
    case 'rto':
    case 'return':
      return const Color(0xFF6A1B9A);
    case 'in_progress':
    case 'in-progress':
    case 'out_for_delivery':
      return const Color(0xFF00695C);
    default:
      return const Color(0xFF616161);
  }
}

// ─── Tracking Step Data ────────────────────────────────────────────────────

class _TrackingStep {
  final String title;
  final bool isCompleted;
  final bool isCurrent;
  final bool isCancelled;

  const _TrackingStep({
    required this.title,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isCancelled = false,
  });
}

/// Build tracking steps based on order flow.
/// Three flows: Delivered, Pending, RTO (Return to Origin).
List<_TrackingStep> _buildTrackingSteps(String status) {
  final s = status.toLowerCase();

  // ── Delivered flow ──
  if (s == 'delivered' || s == 'completed') {
    return const [
      _TrackingStep(title: 'Order Booked', isCompleted: true),
      _TrackingStep(title: 'Out for Pickup', isCompleted: true),
      _TrackingStep(title: 'Order Picked Up', isCompleted: true),
      _TrackingStep(title: 'Shipped', isCompleted: true),
      _TrackingStep(title: 'Out for Delivery', isCompleted: true),
      _TrackingStep(
        title: 'Order Delivered',
        isCompleted: true,
        isCurrent: true,
      ),
    ];
  }

  // ── RTO / Cancelled flow ──
  if (s == 'cancelled' || s == 'rto' || s == 'return') {
    return const [
      _TrackingStep(title: 'Order Booked', isCompleted: true),
      _TrackingStep(title: 'Out for Pickup', isCompleted: true),
      _TrackingStep(title: 'Order Picked Up', isCompleted: true),
      _TrackingStep(title: 'Shipped', isCompleted: true),
      _TrackingStep(title: 'Out for Delivery', isCompleted: true),
      _TrackingStep(
        title: 'Order Cancelled',
        isCompleted: true,
        isCancelled: true,
      ),
      _TrackingStep(title: 'Return to Seller', isCompleted: true),
      _TrackingStep(title: 'RTO Shipped', isCompleted: true),
      _TrackingStep(title: 'Out for Delivery to Seller', isCompleted: true),
      _TrackingStep(
        title: 'Delivered to Seller',
        isCompleted: true,
        isCurrent: true,
      ),
    ];
  }

  // ── Pending / In-progress flow (default) ──
  // Determine how far along the order is
  final pendingSteps = [
    'Order Booked',
    'Out for Pickup',
    'Order Picked Up',
    'Shipped',
    'Out for Delivery',
    'Order Delivered',
  ];

  int currentIndex;
  switch (s) {
    case 'booked':
    case 'order_booked':
      currentIndex = 0;
      break;
    case 'out_for_pickup':
      currentIndex = 1;
      break;
    case 'picked_up':
    case 'order_picked_up':
      currentIndex = 2;
      break;
    case 'shipped':
      currentIndex = 3;
      break;
    case 'out_for_delivery':
      currentIndex = 4;
      break;
    default:
      // pending or other → show at "Shipped" stage with pending marker
      currentIndex = 3;
      break;
  }

  return List.generate(pendingSteps.length, (i) {
    return _TrackingStep(
      title: pendingSteps[i],
      isCompleted: i <= currentIndex,
      isCurrent: i == currentIndex,
    );
  });
}

// ─── Main Body ─────────────────────────────────────────────────────────────

class _CourierHistoryBody extends StatelessWidget {
  final int? serviceId;

  const _CourierHistoryBody({this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Courier History'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: _gradientOrange),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.add_circle_outline,
              size: 20,
              color: Colors.white,
            ),
            label: const Text(
              'New Booking',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeServiceCubit, HomeServiceState>(
        builder: (context, state) {
          if (state is HomeServiceHistoryLoading) {
            return _buildLoadingView();
          }
          if (state is HomeServiceHistoryError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => context.read<HomeServiceCubit>().fetchHistory(
                serviceId: serviceId,
              ),
            );
          }
          if (state is HomeServiceHistoryLoaded) {
            // Filter courier orders only
            final orders = state.orders
                .where((o) => o.service.slug == 'courier-booking')
                .toList();
            if (orders.isEmpty) {
              return const _EmptyView();
            }
            return RefreshIndicator(
              onRefresh: () => context.read<HomeServiceCubit>().fetchHistory(
                serviceId: serviceId,
              ),
              color: AppColors.primaryOrange,
              child: ListView.builder(
                padding: const EdgeInsets.all(
                  AppSpacing.screenPaddingHorizontal,
                ),
                itemCount: orders.length + 1, // +1 for header
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildHeader(context, orders.length);
                  }
                  final order = orders[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _CourierOrderCard(
                      order: order,
                      onTap: () => _openDetail(context, order),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _openDetail(BuildContext context, ServiceInquiry order) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _CourierOrderDetailPage(order: order)),
    );
  }

  Widget _buildHeader(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md, top: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: _gradientOrange),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            count == 1 ? 'Order' : 'Orders',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
      child: Column(
        children: List.generate(
          3,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Courier Order Card ────────────────────────────────────────────────────

class _CourierOrderCard extends StatelessWidget {
  final ServiceInquiry order;
  final VoidCallback onTap;

  const _CourierOrderCard({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sColor = _statusColor(order.status);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: icon + IDs + status ──
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: _gradientOrange),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_shipping_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.serviceInquiryId}',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (order.trackingId != null)
                          Text(
                            'Tracking: ${order.trackingId}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Product image thumbnail (if exists)
                  if (order.productImage != null) ...[
                    const SizedBox(width: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        order.productImage!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.image,
                            size: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: sColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: sColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      order.status.toUpperCase().replaceAll('_', ' '),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: sColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // ── Dates ──
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _DateChip(
                        label: 'Placed on',
                        value: _formatDate(order.bookingDate),
                        icon: Icons.calendar_today_rounded,
                      ),
                    ),
                    Container(width: 1, height: 28, color: Colors.grey[300]),
                    Expanded(
                      child: _DateChip(
                        label:
                            order.status.toLowerCase() == 'delivered' ||
                                order.status.toLowerCase() == 'completed'
                            ? 'Delivered on'
                            : 'Status',
                        value:
                            order.status.toLowerCase() == 'delivered' ||
                                order.status.toLowerCase() == 'completed'
                            ? _formatDate(order.completedDate)
                            : order.status.toUpperCase().replaceAll('_', ' '),
                        icon:
                            order.status.toLowerCase() == 'delivered' ||
                                order.status.toLowerCase() == 'completed'
                            ? Icons.check_circle_outline
                            : Icons.hourglass_top_rounded,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Seller / Customer label ──
              if (order.customerName != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Cust: ${order.customerName}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.sm),

              // ── Cancel + Invoice ──
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement cancel
                        },
                        icon: Icon(
                          Icons.cancel_outlined,
                          size: 16,
                          color: Colors.red[400],
                        ),
                        label: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.red[400],
                            fontSize: 12,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red[200]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement invoice download
                        },
                        icon: Icon(
                          Icons.download_rounded,
                          size: 16,
                          color: _gradientOrange.first,
                        ),
                        label: Text(
                          'Invoice',
                          style: TextStyle(
                            color: _gradientOrange.first,
                            fontSize: 12,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _gradientOrange.first.withValues(alpha: 0.4),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DateChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[500]),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Order Detail Page ─────────────────────────────────────────────────────

class _CourierOrderDetailPage extends StatelessWidget {
  final ServiceInquiry order;

  const _CourierOrderDetailPage({required this.order});

  @override
  Widget build(BuildContext context) {
    final sColor = _statusColor(order.status);
    final steps = _buildTrackingSteps(order.status);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Order #${order.serviceInquiryId}'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: _gradientOrange),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
        children: [
          const SizedBox(height: AppSpacing.sm),

          // ── Order header ──
          _Card(
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: _gradientOrange),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.local_shipping_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.serviceInquiryId}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (order.trackingId != null)
                        Text(
                          'Tracking: ${order.trackingId}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: sColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: sColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    order.status.toUpperCase().replaceAll('_', ' '),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: sColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Dates ──
          _Card(
            child: Column(
              children: [
                _InfoRow(
                  label: 'Order Placed On',
                  value: _formatDate(order.bookingDate),
                ),
                _InfoRow(
                  label: 'Order Delivered On',
                  value: _formatDate(order.completedDate),
                ),
                if (order.customerName != null)
                  _InfoRow(
                    label: 'Customer / Seller',
                    value: order.customerName!,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Address Info ──
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel(
                  icon: Icons.location_on_rounded,
                  title: 'Address Details',
                ),
                const SizedBox(height: AppSpacing.sm),
                _InfoRow(
                  label: 'Pickup Address',
                  value: order.pickupAddress ?? '—',
                ),
                _InfoRow(
                  label: 'Pickup Pincode',
                  value: order.pickupPincode ?? '—',
                ),
                _InfoRow(
                  label: 'Delivery Address',
                  value: order.deliveryAddress ?? '—',
                ),
                _InfoRow(
                  label: 'Delivery Pincode',
                  value: order.deliveryPincode ?? '—',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Order Status Tracking ──
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel(
                  icon: Icons.track_changes_rounded,
                  title: 'Order Status',
                ),
                const SizedBox(height: AppSpacing.md),
                ...List.generate(steps.length, (i) {
                  final step = steps[i];
                  final isLast = i == steps.length - 1;
                  return _TrackingStepWidget(step: step, isLast: isLast);
                }),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Payment Information ──
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel(
                  icon: Icons.payment_rounded,
                  title: 'Payment Information',
                ),
                const SizedBox(height: AppSpacing.sm),
                _PriceRow(
                  label: 'Booking Charge',
                  amount: order.bookingCharge ?? order.tokenAmount,
                ),
                _PriceRow(
                  label: 'Platform Fees',
                  amount: order.platformFees ?? 0,
                ),
                _PriceRow(label: 'CGST', amount: order.cgst ?? 0),
                _PriceRow(label: 'SGST', amount: order.sgst ?? 0),
                _PriceRow(
                  label: 'Other Charges',
                  amount: order.otherCharges ?? 0,
                ),
                const Divider(height: 20),
                _PriceRow(
                  label: 'Total Charges',
                  amount: order.totalCharges ?? order.tokenAmount,
                  isBold: true,
                ),
                if ((order.discount ?? 0) > 0)
                  _PriceRow(
                    label: 'Discount',
                    amount: -(order.discount ?? 0),
                    isDiscount: true,
                  ),
                const Divider(height: 20),
                _PriceRow(
                  label: 'Final Amount',
                  amount: order.finalAmount ?? order.tokenAmount,
                  isBold: true,
                  color: _gradientOrange.first,
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Mode',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(
                            order.paymentStatus,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          order.paymentMode?.toUpperCase() ??
                              order.paymentStatus.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: _statusColor(order.paymentStatus),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Cancel + Invoice ──
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement cancel
                    },
                    icon: Icon(
                      Icons.cancel_outlined,
                      size: 18,
                      color: Colors.red[400],
                    ),
                    label: Text(
                      'Cancel Order',
                      style: TextStyle(
                        color: Colors.red[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red[200]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: _gradientOrange),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement invoice download
                      },
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text(
                        'Download Invoice',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Need Help ──
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.help_outline_rounded,
                      color: AppColors.primaryOrange,
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Need Help?',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Do you have any issues with this order?',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () => _openWhatsApp(),
                    icon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 18,
                    ),
                    label: const Text('Chat with us'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () => _openEmail(),
                    icon: const Icon(Icons.email_outlined, size: 18),
                    label: const Text('Send us an email'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryOrange),
                      foregroundColor: AppColors.primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement callback request
                    },
                    icon: const Icon(
                      Icons.phone_callback_rounded,
                      size: 18,
                      color: AppColors.secondaryGreen,
                    ),
                    label: const Text(
                      'Call me back',
                      style: TextStyle(color: AppColors.secondaryGreen),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.secondaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    const phoneNumber = '919518365510';
    final whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openEmail() async {
    final emailUrl = Uri.parse(
      'mailto:customersupport@takshallinone.in?subject=Courier Order Support&body=Hi, I need help with my courier order #${order.serviceInquiryId}',
    );
    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl);
    }
  }
}

// ─── Tracking Step Widget ──────────────────────────────────────────────────

class _TrackingStepWidget extends StatelessWidget {
  final _TrackingStep step;
  final bool isLast;

  const _TrackingStepWidget({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    Color lineColor;
    IconData? dotIcon;

    if (step.isCancelled) {
      dotColor = const Color(0xFFC62828);
      lineColor = const Color(0xFFC62828);
      dotIcon = Icons.close_rounded;
    } else if (step.isCompleted) {
      dotColor = const Color(0xFF2E7D32);
      lineColor = const Color(0xFF2E7D32);
      dotIcon = Icons.check_rounded;
    } else {
      dotColor = Colors.grey[300]!;
      lineColor = Colors.grey[300]!;
      dotIcon = null;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Timeline column ──
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Dot
                Container(
                  width: step.isCurrent ? 22 : 18,
                  height: step.isCurrent ? 22 : 18,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: step.isCurrent
                        ? Border.all(
                            color: dotColor.withValues(alpha: 0.3),
                            width: 3,
                          )
                        : null,
                    boxShadow: step.isCurrent
                        ? [
                            BoxShadow(
                              color: dotColor.withValues(alpha: 0.3),
                              blurRadius: 6,
                            ),
                          ]
                        : null,
                  ),
                  child: dotIcon != null
                      ? Icon(
                          dotIcon,
                          size: step.isCurrent ? 14 : 12,
                          color: Colors.white,
                        )
                      : null,
                ),
                // Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: lineColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // ── Label ──
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Text(
                step.title,
                style: TextStyle(
                  fontSize: step.isCurrent ? 14 : 13,
                  fontWeight: step.isCurrent
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: step.isCancelled
                      ? const Color(0xFFC62828)
                      : step.isCompleted
                      ? Colors.grey[800]
                      : Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Widgets ──────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionLabel({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: _gradientOrange),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isBold;
  final bool isDiscount;
  final Color? color;

  const _PriceRow({
    required this.label,
    required this.amount,
    this.isBold = false,
    this.isDiscount = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final displayAmount = isDiscount
        ? '- ₹${amount.abs().toStringAsFixed(2)}'
        : '₹${amount.toStringAsFixed(2)}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[isBold ? 800 : 600],
              fontSize: isBold ? 14 : 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
          Text(
            displayAmount,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
              fontSize: isBold ? 16 : 13,
              color: isDiscount
                  ? const Color(0xFF2E7D32)
                  : (color ?? Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty View ────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOrange.withValues(alpha: 0.1),
                    AppColors.primaryOrange.withValues(alpha: 0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_shipping_rounded,
                size: 44,
                color: AppColors.primaryOrange.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No courier orders',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your courier booking history\nwill appear here',
              style: TextStyle(color: Colors.grey[600], height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error View ────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: AppColors.error.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Could not load history',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 44,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
