import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';

/// Orders section - view order history and track orders
class OrdersSection extends StatefulWidget {
  const OrdersSection({super.key});

  @override
  State<OrdersSection> createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<OrdersSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock orders data
  final List<_Order> _activeOrders = [
    _Order(
      id: 'ORD001',
      restaurant: 'Pizza Palace',
      items: 3,
      total: 599,
      status: OrderStatus.preparing,
      date: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    _Order(
      id: 'ORD002',
      restaurant: 'Burger King',
      items: 2,
      total: 399,
      status: OrderStatus.onTheWay,
      date: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  final List<_Order> _pastOrders = [
    _Order(
      id: 'ORD003',
      restaurant: 'Sweet Treats',
      items: 1,
      total: 149,
      status: OrderStatus.delivered,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    _Order(
      id: 'ORD004',
      restaurant: 'Asian Delight',
      items: 4,
      total: 799,
      status: OrderStatus.delivered,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    _Order(
      id: 'ORD005',
      restaurant: 'Coffee House',
      items: 2,
      total: 299,
      status: OrderStatus.delivered,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              color: colorScheme.surface,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.paddingMD),
                    child: Row(
                      children: [
                        Text(
                          'My Orders',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            // TODO: Implement search
                          },
                        ),
                      ],
                    ),
                  ),
                  // Tabs
                  TabBar(
                    controller: _tabController,
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
                    indicatorColor: colorScheme.primary,
                    tabs: const [
                      Tab(text: 'Active'),
                      Tab(text: 'Past Orders'),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  // Active Orders
                  _activeOrders.isEmpty
                      ? _EmptyOrders(
                          message: 'No active orders',
                          colorScheme: colorScheme,
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(AppSpacing.paddingMD),
                          itemCount: _activeOrders.length,
                          itemBuilder: (context, index) {
                            return _OrderCard(
                              order: _activeOrders[index],
                              colorScheme: colorScheme,
                              isActive: true,
                            );
                          },
                        ),

                  // Past Orders
                  _pastOrders.isEmpty
                      ? _EmptyOrders(
                          message: 'No past orders',
                          colorScheme: colorScheme,
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(AppSpacing.paddingMD),
                          itemCount: _pastOrders.length,
                          itemBuilder: (context, index) {
                            return _OrderCard(
                              order: _pastOrders[index],
                              colorScheme: colorScheme,
                              isActive: false,
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Order status enum
enum OrderStatus {
  preparing,
  onTheWay,
  delivered,
  cancelled,
}

/// Order data model
class _Order {
  final String id;
  final String restaurant;
  final int items;
  final double total;
  final OrderStatus status;
  final DateTime date;

  _Order({
    required this.id,
    required this.restaurant,
    required this.items,
    required this.total,
    required this.status,
    required this.date,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.onTheWay:
        return 'On the way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color getStatusColor(ColorScheme colorScheme) {
    switch (status) {
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.onTheWay:
        return Colors.blue;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return colorScheme.error;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.onTheWay:
        return Icons.delivery_dining;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }
}

/// Empty orders widget
class _EmptyOrders extends StatelessWidget {
  final String message;
  final ColorScheme colorScheme;

  const _EmptyOrders({
    required this.message,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 120,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start ordering to see your orders here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Order card widget
class _OrderCard extends StatelessWidget {
  final _Order order;
  final ColorScheme colorScheme;
  final bool isActive;

  const _OrderCard({
    required this.order,
    required this.colorScheme,
    required this.isActive,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = order.getStatusColor(colorScheme);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to order details
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.restaurant,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Order #${order.id}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
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
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          order.statusIcon,
                          size: 16,
                          color: statusColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.statusText,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Order Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 16,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${order.items} items',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${AppConstants.currencySymbol}${order.total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(order.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),

              // Action Buttons
              if (isActive) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Track order
                        },
                        icon: const Icon(Icons.location_on_outlined, size: 18),
                        label: const Text('Track Order'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          // TODO: Contact support
                        },
                        icon: const Icon(Icons.headset_mic_outlined, size: 18),
                        label: const Text('Help'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Reorder
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Reorder'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
}
