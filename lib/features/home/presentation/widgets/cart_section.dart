import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';

/// Cart section - view and manage shopping cart
class CartSection extends StatefulWidget {
  const CartSection({super.key});

  @override
  State<CartSection> createState() => _CartSectionState();
}

class _CartSectionState extends State<CartSection> {
  // Mock cart items
  final List<_CartItem> _cartItems = [
    _CartItem(
      id: '1',
      name: 'Margherita Pizza',
      restaurant: 'Pizza Palace',
      price: 299,
      quantity: 2,
      imageIcon: Icons.local_pizza,
    ),
    _CartItem(
      id: '2',
      name: 'Chicken Burger',
      restaurant: 'Burger King',
      price: 199,
      quantity: 1,
      imageIcon: Icons.fastfood,
    ),
    _CartItem(
      id: '3',
      name: 'Chocolate Cake',
      restaurant: 'Sweet Treats',
      price: 149,
      quantity: 1,
      imageIcon: Icons.cake,
    ),
  ];

  void _updateQuantity(String id, int delta) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final newQuantity = _cartItems[index].quantity + delta;
        if (newQuantity > 0) {
          _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
        } else {
          _cartItems.removeAt(index);
        }
      }
    });
  }

  double get _subtotal {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get _deliveryFee => 40.0;
  double get _tax => _subtotal * 0.05;
  double get _total => _subtotal + _deliveryFee + _tax;

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
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.paddingMD),
                child: Row(
                  children: [
                    Text(
                      'My Cart',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (_cartItems.isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _cartItems.clear();
                          });
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Clear'),
                      ),
                  ],
                ),
              ),
            ),

            // Cart Content
            Expanded(
              child: _cartItems.isEmpty
                  ? _EmptyCart(colorScheme: colorScheme)
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(AppSpacing.paddingMD),
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return _CartItemCard(
                          item: item,
                          colorScheme: colorScheme,
                          onQuantityChanged: (delta) => _updateQuantity(item.id, delta),
                        );
                      },
                    ),
            ),

            // Cart Summary
            if (_cartItems.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.paddingMD),
                    child: Column(
                      children: [
                        _SummaryRow(
                          label: 'Subtotal',
                          value: '${AppConstants.currencySymbol}${_subtotal.toStringAsFixed(2)}',
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Delivery Fee',
                          value: '${AppConstants.currencySymbol}${_deliveryFee.toStringAsFixed(2)}',
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Tax',
                          value: '${AppConstants.currencySymbol}${_tax.toStringAsFixed(2)}',
                          colorScheme: colorScheme,
                        ),
                        const Divider(height: 24),
                        _SummaryRow(
                          label: 'Total',
                          value: '${AppConstants.currencySymbol}${_total.toStringAsFixed(2)}',
                          colorScheme: colorScheme,
                          isBold: true,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              // TODO: Navigate to checkout
                            },
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Proceed to Checkout'),
                          ),
                        ),
                      ],
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

/// Cart item data model
class _CartItem {
  final String id;
  final String name;
  final String restaurant;
  final double price;
  final int quantity;
  final IconData imageIcon;

  _CartItem({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.price,
    required this.quantity,
    required this.imageIcon,
  });

  _CartItem copyWith({
    String? id,
    String? name,
    String? restaurant,
    double? price,
    int? quantity,
    IconData? imageIcon,
  }) {
    return _CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      restaurant: restaurant ?? this.restaurant,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageIcon: imageIcon ?? this.imageIcon,
    );
  }
}

/// Empty cart widget
class _EmptyCart extends StatelessWidget {
  final ColorScheme colorScheme;

  const _EmptyCart({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cart item card widget
class _CartItemCard extends StatelessWidget {
  final _CartItem item;
  final ColorScheme colorScheme;
  final ValueChanged<int> onQuantityChanged;

  const _CartItemCard({
    required this.item,
    required this.colorScheme,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingMD),
        child: Row(
          children: [
            // Item Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.imageIcon,
                size: 40,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            // Item Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.restaurant,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${AppConstants.currencySymbol}${item.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity Controls
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.outline,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => onQuantityChanged(-1),
                    iconSize: 20,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                  Text(
                    item.quantity.toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => onQuantityChanged(1),
                    iconSize: 20,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
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

/// Summary row widget
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.colorScheme,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 16 : 14,
            color: isBold ? colorScheme.primary : null,
          ),
        ),
      ],
    );
  }
}
