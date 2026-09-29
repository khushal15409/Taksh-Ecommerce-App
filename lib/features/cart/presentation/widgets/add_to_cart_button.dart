import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart.dart';
import 'package:taksh_e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:taksh_e_commerce/features/cart/presentation/cubit/cart_state.dart';

/// A reusable add to cart button widget that shows:
/// - "Add" button when product is not in cart
/// - Quantity controls (- qty +) when product is in cart
///
/// This widget syncs with CartCubit to maintain consistent cart state
/// across all screens (product card, product details, etc.)
class AddToCartButton extends StatelessWidget {
  /// The product variant ID to add to cart
  final int productVariantId;

  /// The product ID (for tracking purposes)
  final int productId;

  /// Size variant of the button: 'small' for product cards, 'large' for product details
  final String size;

  /// Whether this button belongs to quick-delivery flow.
  final bool isQuickDelivery;

  /// Optional callback when item is added
  final VoidCallback? onAdded;

  /// Optional callback when quantity changes
  final void Function(int qty)? onQuantityChanged;

  const AddToCartButton({
    super.key,
    required this.productVariantId,
    required this.productId,
    this.size = 'small',
    this.isQuickDelivery = false,
    this.onAdded,
    this.onQuantityChanged,
  });

  String get _deliveryType => isQuickDelivery
      ? CartCubit.deliveryTypeExpress
      : CartCubit.deliveryTypeStandard;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        // Get current cart and find this item
        final cart = _getCartFromState(state);
        final cartItem = cart?.items
            .where(
              (item) =>
                  item.productVariantId == productVariantId &&
                  CartCubit.matchesDeliveryType(item, _deliveryType),
            )
            .firstOrNull;

        final quantity = cartItem?.qty ?? 0;
        final isLoading = _isOperationInProgress(
          state,
          variantId: productVariantId,
          cartItemId: cartItem?.id,
          deliveryType: _deliveryType,
        );

        if (quantity > 0) {
          return _buildQuantityControls(
            context,
            quantity: quantity,
            cartItemId: cartItem?.id ?? 0,
            isLoading: isLoading,
          );
        }

        return _buildAddButton(context, isLoading: isLoading);
      },
    );
  }

  /// Get cart from various state types
  Cart? _getCartFromState(CartState state) {
    if (state is CartLoaded) return state.cart;
    if (state is CartOperationSuccess) return state.cart;
    if (state is CartLoading) return state.previousCart;
    // Handle loading states that preserve cart
    if (state is AddingToCart) return state.currentCart;
    if (state is UpdatingCartItem) return state.currentCart;
    if (state is RemovingFromCart) return state.currentCart;
    return null;
  }

  /// Check if an operation is in progress for THIS specific product/variant
  bool _isOperationInProgress(
    CartState state, {
    int? variantId,
    int? cartItemId,
    required String deliveryType,
  }) {
    if (state is AddingToCart) {
      return state.productVariantId == variantId &&
          state.deliveryType == deliveryType;
    }
    if (state is UpdatingCartItem) {
      return state.cartItemId == cartItemId;
    }
    if (state is RemovingFromCart) {
      return state.cartItemId == cartItemId;
    }
    return false;
  }

  /// Build the initial "Add" button
  Widget _buildAddButton(BuildContext context, {required bool isLoading}) {
    final isSmall = size == 'small';

    if (isSmall) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : () => _addToCart(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
      );
    }

    // Large button for product details page
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _addToCart(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined),
                  SizedBox(width: 8),
                  Text(
                    'Add to Cart',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }

  /// Build quantity controls (- qty +)
  Widget _buildQuantityControls(
    BuildContext context, {
    required int quantity,
    required int cartItemId,
    required bool isLoading,
  }) {
    final isSmall = size == 'small';

    if (isSmall) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildControlButton(
              context,
              icon: quantity == 1 ? Icons.delete_outline : Icons.remove,
              onTap: isLoading
                  ? null
                  : () => _decrementQuantity(context, quantity, cartItemId),
              isSmall: true,
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 24),
              alignment: Alignment.center,
              child: isLoading
                  ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      '$quantity',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
            ),
            _buildControlButton(
              context,
              icon: Icons.add,
              onTap: isLoading
                  ? null
                  : () => _incrementQuantity(context, quantity, cartItemId),
              isSmall: true,
            ),
          ],
        ),
      );
    }

    // Large quantity controls for product details page
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildControlButton(
            context,
            icon: quantity == 1 ? Icons.delete_outline : Icons.remove,
            onTap: isLoading
                ? null
                : () => _decrementQuantity(context, quantity, cartItemId),
            isSmall: false,
          ),
          Expanded(
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : Text(
                      '$quantity',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
            ),
          ),
          _buildControlButton(
            context,
            icon: Icons.add,
            onTap: isLoading
                ? null
                : () => _incrementQuantity(context, quantity, cartItemId),
            isSmall: false,
          ),
        ],
      ),
    );
  }

  /// Build individual control button (+ or -)
  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onTap,
    required bool isSmall,
  }) {
    if (isSmall) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 16, color: Colors.white),
        ),
      );
    }

    return Material(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 24, color: Colors.white),
        ),
      ),
    );
  }

  /// Add item to cart
  /// Checks if item already exists in cart and updates quantity instead of adding duplicate
  void _addToCart(BuildContext context) {
    // Guest users must log in before adding items to cart.
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      context.push(
        '${AppRoutes.login}?redirectAfter=${Uri.encodeComponent(AppRoutes.home)}',
      );
      return;
    }

    final cartCubit = context.read<CartCubit>();
    final cart = _getCartFromState(cartCubit.state);

    // Check if this variant already exists in the cart
    final existingItem = cart?.items
      .where(
        (item) =>
          item.productVariantId == productVariantId &&
          CartCubit.matchesDeliveryType(item, _deliveryType),
      )
        .firstOrNull;

    if (existingItem != null) {
      // Item exists - update quantity instead of adding
      final newQty = existingItem.qty + 1;
      cartCubit.updateItem(
        cartItemId: existingItem.id,
        qty: newQty,
        deliveryType: _deliveryType,
      );
      onQuantityChanged?.call(newQty);
    } else {
      // Item doesn't exist - add new
      cartCubit.addItemToCart(
        productVariantId: productVariantId,
        qty: 1,
        deliveryType: _deliveryType,
      );
      onAdded?.call();
      onQuantityChanged?.call(1);
    }
  }

  /// Increment quantity
  void _incrementQuantity(
    BuildContext context,
    int currentQty,
    int cartItemId,
  ) {
    final newQty = currentQty + 1;
    context.read<CartCubit>().updateItem(
      cartItemId: cartItemId,
      qty: newQty,
      deliveryType: _deliveryType,
    );
    onQuantityChanged?.call(newQty);
  }

  /// Decrement quantity (removes item if qty becomes 0)
  void _decrementQuantity(
    BuildContext context,
    int currentQty,
    int cartItemId,
  ) {
    if (currentQty <= 1) {
      context.read<CartCubit>().removeItem(
        cartItemId,
        deliveryType: _deliveryType,
      );
      onQuantityChanged?.call(0);
    } else {
      final newQty = currentQty - 1;
      context.read<CartCubit>().updateItem(
        cartItemId: cartItemId,
        qty: newQty,
        deliveryType: _deliveryType,
      );
      onQuantityChanged?.call(newQty);
    }
  }
}
