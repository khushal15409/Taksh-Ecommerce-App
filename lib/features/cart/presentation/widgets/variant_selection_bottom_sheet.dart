import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart.dart';
import 'package:taksh_e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:taksh_e_commerce/features/cart/presentation/cubit/cart_state.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/product_variant_info.dart';

/// Bottom sheet for selecting a product variant before adding to cart.
/// Inspired by Blinkit's variant selection flow.
///
/// Shows a list of available variants with their prices and individual
/// ADD / quantity-control buttons.
class VariantSelectionBottomSheet extends StatelessWidget {
  /// Product name displayed at the top of the sheet
  final String productName;

  /// Product image URL for the header
  final String? productImageUrl;

  /// List of available variants to choose from
  final List<ProductVariantInfo> variants;

  /// Whether this sheet belongs to quick-delivery flow.
  final bool isQuickDelivery;

  const VariantSelectionBottomSheet({
    super.key,
    required this.productName,
    this.productImageUrl,
    required this.variants,
    this.isQuickDelivery = false,
  });

  /// Convenience method to show this bottom sheet
  static Future<void> show(
    BuildContext context, {
    required String productName,
    String? productImageUrl,
    required List<ProductVariantInfo> variants,
    bool isQuickDelivery = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CartCubit>(),
        child: VariantSelectionBottomSheet(
          productName: productName,
          productImageUrl: productImageUrl,
          variants: variants,
          isQuickDelivery: isQuickDelivery,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeVariants = variants.where((v) => v.isActive).toList();
    final sellableVariants = activeVariants
        .where((variant) => variant.isAvailableForSale)
        .length;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header with product name
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${activeVariants.length} option${activeVariants.length != 1 ? 's' : ''}'
                        '${sellableVariants < activeVariants.length ? ' • $sellableVariants available' : ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 22),
                  splashRadius: 20,
                  color: AppColors.grey600,
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.grey200),

          // Variant list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: activeVariants.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: AppColors.grey200,
              ),
              itemBuilder: (context, index) {
                return _VariantTile(
                  variant: activeVariants[index],
                  productName: productName,
                  isQuickDelivery: isQuickDelivery,
                );
              },
            ),
          ),

          // Bottom safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

/// Individual variant tile with price info and ADD/quantity button.
class _VariantTile extends StatelessWidget {
  final ProductVariantInfo variant;
  final String productName;
  final bool isQuickDelivery;

  const _VariantTile({
    required this.variant,
    required this.productName,
    required this.isQuickDelivery,
  });

  String get _deliveryType => isQuickDelivery
      ? CartCubit.deliveryTypeExpress
      : CartCubit.deliveryTypeStandard;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        final cart = _getCartFromState(cartState);
        final cartItem = cart?.items
            .where(
              (item) =>
                  item.productVariantId == variant.id &&
                  CartCubit.matchesDeliveryType(item, _deliveryType),
            )
            .firstOrNull;
        final quantity = cartItem?.qty ?? 0;
        final isSellable = !variant.hasStockInfo || variant.isAvailableForSale;
        final isLoading = _isOperationInProgress(
          cartState,
          variantId: variant.id,
          cartItemId: cartItem?.id,
          deliveryType: _deliveryType,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Variant info (label + price)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Variant label / SKU
                    Text(
                      variant.label ?? variant.sku,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey800,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (variant.hasStockInfo && !isSellable) ...[
                      const SizedBox(height: 4),
                      Text(
                        variant.outOfStockMessage ?? 'Out of stock',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE53935),
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    // Price row
                    Row(
                      children: [
                        Text(
                          '₹${variant.salePrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.grey900,
                          ),
                        ),
                        if (variant.discountPercentage != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '₹${variant.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey500,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppColors.grey500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E97E8).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${variant.discountPercentage}% off',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2E97E8),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // ADD button or quantity controls
              if (quantity > 0)
                _buildQuantityControls(
                  context,
                  quantity: quantity,
                  cartItemId: cartItem?.id ?? 0,
                  isLoading: isLoading,
                  canIncrement: isSellable,
                )
              else
                isSellable
                    ? _buildAddButton(context, isLoading: isLoading)
                    : _buildOutOfStockButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOutOfStockButton() {
    return Container(
      constraints: const BoxConstraints(minWidth: 72),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEF9A9A), width: 1.2),
      ),
      child: const Text(
        'Out of stock',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFFE53935),
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, {required bool isLoading}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : () => _addToCart(context),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(minWidth: 72),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.secondaryGreen, width: 1.5),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.secondaryGreen,
                    ),
                  ),
                )
              : const Text(
                  'ADD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryGreen,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls(
    BuildContext context, {
    required int quantity,
    required int cartItemId,
    required bool isLoading,
    required bool canIncrement,
  }) {
    return Container(
      constraints: const BoxConstraints(minWidth: 72),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildControlBtn(
            context,
            icon: quantity == 1 ? Icons.delete_outline : Icons.remove,
            onTap: isLoading
                ? null
                : () => _decrementQuantity(context, quantity, cartItemId),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 22),
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
                      fontSize: 13,
                    ),
                  ),
          ),
          _buildControlBtn(
            context,
            icon: Icons.add,
            onTap: isLoading || !canIncrement
                ? null
                : () => _incrementQuantity(context, quantity, cartItemId),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBtn(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }

  // ── Cart helpers ──

  Cart? _getCartFromState(CartState state) {
    if (state is CartLoaded) return state.cart;
    if (state is CartOperationSuccess) return state.cart;
    if (state is CartLoading) return state.previousCart;
    if (state is AddingToCart) return state.currentCart;
    if (state is UpdatingCartItem) return state.currentCart;
    if (state is RemovingFromCart) return state.currentCart;
    return null;
  }

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
    if (state is UpdatingCartItem) return state.cartItemId == cartItemId;
    if (state is RemovingFromCart) return state.cartItemId == cartItemId;
    return false;
  }

  void _addToCart(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final cart = _getCartFromState(cartCubit.state);

    // Check if this variant already exists in the cart
    final existingItem = cart?.items
      .where(
        (item) =>
          item.productVariantId == variant.id &&
          CartCubit.matchesDeliveryType(item, _deliveryType),
      )
        .firstOrNull;

    if (existingItem != null) {
      cartCubit.updateItem(
        cartItemId: existingItem.id,
        qty: existingItem.qty + 1,
        deliveryType: _deliveryType,
      );
    } else {
      cartCubit.addItemToCart(
        productVariantId: variant.id,
        qty: 1,
        deliveryType: _deliveryType,
      );
    }
  }

  void _incrementQuantity(
    BuildContext context,
    int currentQty,
    int cartItemId,
  ) {
    context.read<CartCubit>().updateItem(
      cartItemId: cartItemId,
      qty: currentQty + 1,
      deliveryType: _deliveryType,
    );
  }

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
    } else {
      context.read<CartCubit>().updateItem(
        cartItemId: cartItemId,
        qty: currentQty - 1,
        deliveryType: _deliveryType,
      );
    }
  }
}
