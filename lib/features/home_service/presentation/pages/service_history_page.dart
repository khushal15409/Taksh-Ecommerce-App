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

/// Page displaying service booking history with rich detail view.
class ServiceHistoryPage extends StatelessWidget {
  final int? serviceId;

  const ServiceHistoryPage({super.key, this.serviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<HomeServiceCubit>()..fetchHistory(serviceId: serviceId),
      child: _ServiceHistoryBody(serviceId: serviceId),
    );
  }
}

// ─── Helpers ───────────────────────────────────────────────────────────────

final _dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

String _formatDate(DateTime? date) =>
    date != null ? _dateFormat.format(date) : '—';

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
      return const Color(0xFF2E7D32);
    case 'pending':
      return const Color(0xFFF57F17);
    case 'confirmed':
      return const Color(0xFF1565C0);
    case 'cancelled':
      return const Color(0xFFC62828);
    case 'in_progress':
    case 'in-progress':
      return const Color(0xFF6A1B9A);
    default:
      return const Color(0xFF616161);
  }
}

List<Color> _serviceGradient(String slug) {
  switch (slug) {
    case 'courier-booking':
      return [const Color(0xFFFF6B35), const Color(0xFFFF8F5E)];
    case 'electrician':
      return [const Color(0xFF1976D2), const Color(0xFF42A5F5)];
    case 'plumber':
      return [const Color(0xFF2E7D32), const Color(0xFF66BB6A)];
    case 'salon-parlor':
      return [const Color(0xFFC2185B), const Color(0xFFEC407A)];
    default:
      return [const Color(0xFF5E35B1), const Color(0xFF7E57C2)];
  }
}

IconData _serviceIcon(String slug) {
  switch (slug) {
    case 'courier-booking':
      return Icons.local_shipping_rounded;
    case 'electrician':
      return Icons.electrical_services_rounded;
    case 'plumber':
      return Icons.plumbing_rounded;
    case 'salon-parlor':
      return Icons.content_cut_rounded;
    default:
      return Icons.home_repair_service_rounded;
  }
}

// ─── Main Body ─────────────────────────────────────────────────────────────

class _ServiceHistoryBody extends StatelessWidget {
  final int? serviceId;

  const _ServiceHistoryBody({this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Service History'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFFA726)],
            ),
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
            if (state.orders.isEmpty) {
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
                itemCount: state.orders.length + 1, // +1 for header
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildHistoryHeader(context, state.orders.length);
                  }
                  final order = state.orders[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _OrderCard(
                      order: order,
                      onTap: () => _openOrderDetails(context, order),
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

  void _openOrderDetails(BuildContext context, ServiceInquiry order) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => _OrderDetailPage(order: order)));
  }

  Widget _buildHistoryHeader(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md, top: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFFA726)],
              ),
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
            count == 1 ? 'Booking' : 'Bookings',
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
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Container(
              height: 140,
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
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 80,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
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

// ─── Order Card ────────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final ServiceInquiry order;
  final VoidCallback onTap;

  const _OrderCard({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final grad = _serviceGradient(order.service.slug);
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
              // ── Top row: icon + name + status ──
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: grad),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _serviceIcon(order.service.slug),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.service.name,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Order #${order.serviceInquiryId}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
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

              // ── Dates row ──
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
                      child: _DateInfo(
                        label: 'Booked on',
                        value: _formatDate(order.bookingDate),
                        icon: Icons.calendar_today_rounded,
                      ),
                    ),
                    Container(width: 1, height: 28, color: Colors.grey[300]),
                    Expanded(
                      child: _DateInfo(
                        label: order.status.toLowerCase() == 'completed'
                            ? 'Completed on'
                            : 'Status',
                        value: order.status.toLowerCase() == 'completed'
                            ? _formatDate(order.completedDate)
                            : order.status.toUpperCase().replaceAll('_', ' '),
                        icon: order.status.toLowerCase() == 'completed'
                            ? Icons.check_circle_outline
                            : Icons.hourglass_top_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // ── Cancel + Download Invoice ──
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
                          color: grad.first,
                        ),
                        label: Text(
                          'Invoice',
                          style: TextStyle(color: grad.first, fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: grad.first.withValues(alpha: 0.4),
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

class _DateInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DateInfo({
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

class _OrderDetailPage extends StatelessWidget {
  final ServiceInquiry order;

  const _OrderDetailPage({required this.order});

  @override
  Widget build(BuildContext context) {
    final grad = _serviceGradient(order.service.slug);
    final sColor = _statusColor(order.status);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Order #${order.serviceInquiryId}'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: LinearGradient(colors: grad)),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
        children: [
          const SizedBox(height: AppSpacing.sm),

          // ── Service + Status header ──
          _SectionCard(
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: grad),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _serviceIcon(order.service.slug),
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
                        order.service.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Order #${order.serviceInquiryId}',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
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

          // ── Customer Details ──
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(
                  icon: Icons.person_rounded,
                  title: 'Customer Details',
                  gradient: grad,
                ),
                const SizedBox(height: AppSpacing.sm),
                _DetailRow(label: 'Name', value: order.customerName ?? '—'),
                _DetailRow(label: 'Mobile', value: order.customerMobile ?? '—'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Address Details ──
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(
                  icon: Icons.location_on_rounded,
                  title: 'Address Details',
                  gradient: grad,
                ),
                const SizedBox(height: AppSpacing.sm),
                if (order.service.slug == 'courier-booking') ...[
                  _DetailRow(
                    label: 'Pickup Address',
                    value: order.pickupAddress ?? '—',
                  ),
                  _DetailRow(
                    label: 'Pickup Pincode',
                    value: order.pickupPincode ?? '—',
                  ),
                  _DetailRow(
                    label: 'Delivery Address',
                    value: order.deliveryAddress ?? '—',
                  ),
                  _DetailRow(
                    label: 'Delivery Pincode',
                    value: order.deliveryPincode ?? '—',
                  ),
                ] else ...[
                  _DetailRow(
                    label: 'Full Address',
                    value: order.fullAddress ?? '—',
                  ),
                  _DetailRow(label: 'Pincode', value: order.pincode ?? '—'),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Description ──
          if ((order.description ?? order.message).isNotEmpty)
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(
                    icon: Icons.description_rounded,
                    title: 'Description',
                    gradient: grad,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    order.description ?? order.message,
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          if ((order.description ?? order.message).isNotEmpty)
            const SizedBox(height: AppSpacing.sm),

          // ── Payment Information ──
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(
                  icon: Icons.payment_rounded,
                  title: 'Payment Information',
                  gradient: grad,
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
                  label: 'Final Booking Amount',
                  amount: order.finalAmount ?? order.tokenAmount,
                  isBold: true,
                  color: grad.first,
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

          // ── Cancel + Download Invoice ──
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
                      gradient: LinearGradient(colors: grad),
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
          _SectionCard(
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
      'mailto:customersupport@takshallinone.in?subject=Service Order Support&body=Hi, I need help with my service order #${order.serviceInquiryId}',
    );
    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl);
    }
  }
}

// ─── Reusable Widgets ──────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

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

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Color> gradient;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

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
                Icons.history_rounded,
                size: 44,
                color: AppColors.primaryOrange.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No previous orders',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your service booking history\nwill appear here',
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
