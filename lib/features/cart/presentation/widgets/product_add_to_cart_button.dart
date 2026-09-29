import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart.dart';
import 'package:taksh_e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:taksh_e_commerce/features/cart/presentation/cubit/cart_state.dart';
import 'package:taksh_e_commerce/features/cart/presentation/services/variant_cache_service.dart';
import 'package:taksh_e_commerce/features/cart/presentation/widgets/variant_selection_bottom_sheet.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/product_variant_info.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_ecommerce_product_details.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_products.dart';

enum ProductAddToCartButtonStyle { elevatedWhite, outlinedGreen }

/// A compact add to cart button for product cards that handles products
/// with or without variant IDs.
///
/// Flow:
/// 1. When "Add" is clicked:
///    - If multiple variants: opens variant selection bottom sheet
///    - If variant ID is available: adds directly to cart
///    - If variant ID is NOT available: fetches product details first,
///      gets the variant ID, then adds to cart
/// 2. Once added, shows quantity controls (- qty +)
/// 3. All cart operations sync with CartCubit for consistent state
class ProductAddToCartButton extends StatefulWidget {
  /// The product ID (required)
  final int productId;

  /// The product variant ID (optional - may not be available in list views)
  final int? productVariantId;

  /// Optional callback when item is added
  final VoidCallback? onAdded;

  /// Optional callback when quantity changes
  final void Function(int qty)? onQuantityChanged;

  /// Visual style for the button
  final ProductAddToCartButtonStyle style;

  /// Whether the product is in stock — when false, shows disabled out-of-stock chip
  final bool inStock;

  /// Whether this product belongs to quick-delivery flow.
  final bool isQuickDelivery;

  /// List of available variants (from API). When the product has multiple
  /// variants, the button shows "ADD\nX options" and opens a selection sheet.
  final List<ProductVariantInfo>? variants;

  /// Product name used in the variant selection bottom sheet header
  final String? productName;

  /// Product image URL used in the variant selection bottom sheet header
  final String? productImageUrl;

  const ProductAddToCartButton({
    super.key,
    required this.productId,
    this.productVariantId,
    this.onAdded,
    this.onQuantityChanged,
    this.style = ProductAddToCartButtonStyle.elevatedWhite,
    this.inStock = true,
    this.isQuickDelivery = false,
    this.variants,
    this.productName,
    this.productImageUrl,
  });

  @override
  State<ProductAddToCartButton> createState() => _ProductAddToCartButtonState();
}

class _ProductAddToCartButtonState extends State<ProductAddToCartButton> {
  static const BoxConstraints _outlinedGreenFixedSize = BoxConstraints.tightFor(
    width: 72,
    height: 26,
  );

  /// Larger height for button when showing "X options" subtitle
  static const BoxConstraints _outlinedGreenWithOptionsSize =
      BoxConstraints.tightFor(width: 72, height: 34);

  /// Whether we're currently fetching product details
  bool _isFetchingVariant = false;

  /// Variants discovered via product-details API for homepage products
  /// where the dashboard API doesn't include a variants array.
  List<ProductVariantInfo>? _discoveredVariants;

  /// Static cache so we don't re-fetch for the same product across rebuilds.
  static final Map<int, List<ProductVariantInfo>> _variantCache = {};

  /// Effective variants: discovered > widget-provided > null
  List<ProductVariantInfo>? get _effectiveVariants =>
      _discoveredVariants ?? widget.variants;

  List<ProductVariantInfo> get _activeVariants =>
      _effectiveVariants?.where((variant) => variant.isActive).toList() ??
      const [];

  bool _variantHasResolvedCartStock(ProductVariantInfo variant) {
    if (widget.isQuickDelivery) {
      return variant.hasStockInfo && variant.availableStock != null;
    }

    return variant.hasStockInfo;
  }

  bool _variantUsableForCart(ProductVariantInfo variant) {
    if (!variant.isActive || !variant.inStock) {
      return false;
    }

    if (widget.isQuickDelivery) {
      return variant.availableStock != null && variant.availableStock! > 0;
    }

    return variant.availableStock == null || variant.availableStock! > 0;
  }

  List<ProductVariantInfo> get _sellableVariants =>
      _effectiveVariants?.where(_variantUsableForCart).toList() ?? const [];

  String get _deliveryType => widget.isQuickDelivery
      ? CartCubit.deliveryTypeExpress
      : CartCubit.deliveryTypeStandard;

  /// Whether this product has multiple active variants to choose from
  bool get _hasMultipleVariants {
    return !widget.isQuickDelivery && _activeVariants.length > 1;
  }

  bool get _needsVariantEnrichment {
    final variants = widget.variants;
    if (variants == null || variants.isEmpty) {
      return widget.isQuickDelivery;
    }

    final activeVariants = variants
        .where((variant) => variant.isActive)
        .toList();
    if (activeVariants.isEmpty) return widget.isQuickDelivery;

    return activeVariants.any(
      (variant) => !_variantHasResolvedCartStock(variant),
    );
  }

  /// Number of active variants
  int get _activeVariantCount => _activeVariants.length;

  bool get _hasResolvedNoSellableVariants =>
      _effectiveVariants != null &&
      _activeVariants.isNotEmpty &&
      _activeVariants.every(_variantHasResolvedCartStock) &&
      _sellableVariants.isEmpty;

  bool _activeVariantsHaveResolvedStock(List<ProductVariantInfo> variants) {
    final activeVariants = variants
        .where((variant) => variant.isActive)
        .toList();
    return activeVariants.isNotEmpty &&
        activeVariants.every(_variantHasResolvedCartStock);
  }

  void _cacheResolvedVariants(List<ProductVariantInfo> infos) {
    final sellableInfos = infos.where(_variantUsableForCart).toList();

    _variantCache[widget.productId] = infos;
    if (sellableInfos.isNotEmpty) {
      VariantCacheService.instance.cacheVariantId(
        widget.productId,
        sellableInfos.first.id,
      );
    }
  }

  void _showOutOfStockMessage(List<ProductVariantInfo> infos) {
    final l10n = AppLocalizations.of(context);
    final message =
        infos
            .map((variant) => variant.outOfStockMessage)
            .firstWhere(
              (message) => message != null && message.trim().isNotEmpty,
              orElse: () => null,
            ) ??
        l10n?.outOfStock ??
        'Out of stock';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<List<ProductVariantInfo>?> _lookupVariantsFromProductCatalog() async {
    final searchTerm = widget.productName?.trim();
    if (searchTerm == null || searchTerm.isEmpty) {
      return null;
    }

    final getProducts = getIt<GetProducts>();
    final result = await getProducts(
      GetProductsParams(search: searchTerm, limit: 20),
    );

    if (!mounted) return null;

    return result.fold((_) => null, (paginatedProducts) {
      for (final product in paginatedProducts.products) {
        if (product.id != widget.productId) continue;

        final infos = ProductVariantInfo.fromProductVariants(product.variants);
        if (infos != null && infos.isNotEmpty) {
          return infos;
        }
      }

      return null;
    });
  }

  /// Get effective variant ID from: widget prop > global cache
  int? get _effectiveVariantId {
    final cachedVariantId = VariantCacheService.instance.getVariantId(
      widget.productId,
    );
    final variants = _effectiveVariants;

    if (variants != null && variants.isNotEmpty) {
      for (final candidateId in [widget.productVariantId, cachedVariantId]) {
        if (candidateId == null) continue;

        for (final variant in variants) {
          if (variant.id == candidateId && _variantUsableForCart(variant)) {
            return candidateId;
          }
        }
      }

      if (_sellableVariants.isNotEmpty) {
        return _sellableVariants.first.id;
      }
    }

    return widget.productVariantId ?? cachedVariantId;
  }

  @override
  void initState() {
    super.initState();
    _discoverVariantsIfNeeded();
  }

  @override
  void didUpdateWidget(covariant ProductAddToCartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productId != widget.productId) {
      _discoveredVariants = null;
      _discoverVariantsIfNeeded();
    }
  }

  /// Proactively fetch product details to discover variants when the widget
  /// doesn't have them (e.g., dashboard / homepage products).
  Future<void> _discoverVariantsIfNeeded() async {
    // Skip only when the provided variants are already good enough.
    if (widget.variants != null &&
        widget.variants!.isNotEmpty &&
        !_needsVariantEnrichment) {
      return;
    }

    // Skip top-level out-of-stock products only when there is nothing to enrich.
    if (!widget.inStock && !_needsVariantEnrichment) return;

    // Check the static cache first
    final cached = _variantCache[widget.productId];
    if (cached != null) {
      if (mounted) setState(() => _discoveredVariants = cached);
      return;
    }

    await _fetchVariantsFromDetails(showErrors: false);
  }

  Future<bool> _fetchVariantsFromDetails({required bool showErrors}) async {
    if (_isFetchingVariant) {
      return _discoveredVariants != null;
    }

    if (mounted) {
      setState(() => _isFetchingVariant = true);
    }

    try {
      if (widget.isQuickDelivery) {
        final catalogInfos = await _lookupVariantsFromProductCatalog();
        if (!mounted) return false;

        if (catalogInfos != null && catalogInfos.isNotEmpty) {
          final hasResolvedStockForAllActive = _activeVariantsHaveResolvedStock(
            catalogInfos,
          );

          _cacheResolvedVariants(catalogInfos);
          setState(() {
            _discoveredVariants = catalogInfos;
            _isFetchingVariant = false;
          });

          if (showErrors &&
              catalogInfos.where(_variantUsableForCart).isEmpty &&
              (hasResolvedStockForAllActive || widget.isQuickDelivery)) {
            _showOutOfStockMessage(catalogInfos);
          }

          return true;
        }
      }

      final getEcommerceProductDetails = getIt<GetEcommerceProductDetails>();
      final result = await getEcommerceProductDetails(
        GetEcommerceProductDetailsParams(productId: widget.productId),
      );

      if (!mounted) return false;

      return await result.fold<Future<bool>>(
        (_) async {
          setState(() => _isFetchingVariant = false);

          if (!showErrors) return false;

          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n?.couldNotLoadProduct ??
                    'Could not load product details. Please try again.',
                style: const TextStyle(color: AppColors.white),
              ),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return false;
        },
        (product) async {
          var infos = product.variants
              ?.map((variant) => ProductVariantInfo.fromProductVariant(variant))
              .toList();

          final needsCatalogFallback =
              infos == null ||
              infos.isEmpty ||
              !_activeVariantsHaveResolvedStock(infos);

          if (needsCatalogFallback) {
            final catalogInfos = await _lookupVariantsFromProductCatalog();
            if (!mounted) return false;
            if (catalogInfos != null && catalogInfos.isNotEmpty) {
              infos = catalogInfos;
            }
          }

          if (infos == null || infos.isEmpty) {
            setState(() => _isFetchingVariant = false);

            if (!showErrors) return false;

            final l10n = AppLocalizations.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n?.noVariantsAvailable ??
                      'This product is currently unavailable.',
                  style: const TextStyle(color: AppColors.white),
                ),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return false;
          }

          final hasResolvedStockForAllActive = _activeVariantsHaveResolvedStock(
            infos,
          );

          _cacheResolvedVariants(infos);

          setState(() {
            _discoveredVariants = infos;
            _isFetchingVariant = false;
          });

          if (showErrors &&
              infos.where(_variantUsableForCart).isEmpty &&
              (hasResolvedStockForAllActive || widget.isQuickDelivery)) {
            _showOutOfStockMessage(infos);
          }

          return true;
        },
      );
    } catch (_) {
      if (!mounted) return false;

      setState(() => _isFetchingVariant = false);

      if (!showErrors) return false;

      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n?.cartUnexpectedError ??
                'Something went wrong. Please try again.',
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Short-circuit: show disabled out-of-stock chip, no cart interaction needed
    if (!widget.inStock || _hasResolvedNoSellableVariants) {
      return _buildOutOfStockChip();
    }

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        final cart = _getCartFromState(cartState);

        // ── Multi-variant path ──
        if (_hasMultipleVariants) {
          // Check if ANY variant of this product is already in the cart
          final variantIds = _effectiveVariants!
              .where((v) => v.isActive)
              .map((v) => v.id)
              .toSet();
          final cartItemsForProduct =
              cart?.items
                  .where(
                    (item) =>
                        variantIds.contains(item.productVariantId) &&
                        CartCubit.matchesDeliveryType(item, _deliveryType),
                  )
                  .toList() ??
              [];
          final totalQty = cartItemsForProduct.fold<int>(
            0,
            (sum, item) => sum + item.qty,
          );

          if (totalQty > 0) {
            // Show combined quantity badge that opens the variant sheet
            return _buildMultiVariantQuantityBadge(context, totalQty: totalQty);
          }

          // No items in cart yet – show "ADD / X options"
          return _buildAddButton(
            context,
            isLoading: _isFetchingVariant,
            showOptionsCount: true,
          );
        }

        // ── Single variant path (original behavior) ──
        final cartItem = _effectiveVariantId != null
            ? cart?.items
                  .where(
                    (item) =>
                        item.productVariantId == _effectiveVariantId &&
                        CartCubit.matchesDeliveryType(item, _deliveryType),
                  )
                  .firstOrNull
            : null;

        final quantity = cartItem?.qty ?? 0;
        final isCartLoading = _isOperationInProgress(
          cartState,
          variantId: _effectiveVariantId,
          cartItemId: cartItem?.id,
          deliveryType: _deliveryType,
        );

        if (quantity > 0 && _effectiveVariantId != null) {
          return _buildQuantityControls(
            context,
            quantity: quantity,
            cartItemId: cartItem?.id ?? 0,
            isLoading: isCartLoading,
          );
        }

        return _buildAddButton(
          context,
          isLoading: isCartLoading || _isFetchingVariant,
        );
      },
    );
  }

  /// Get cart from various state types (including loading states that preserve cart)
  Cart? _getCartFromState(CartState state) {
    if (state is CartLoaded) return state.cart;
    if (state is CartOperationSuccess) return state.cart;
    if (state is CartLoading) return state.previousCart;
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

  /// Tappable ADD button shown when the product is out of stock.
  /// Looks identical to the normal ADD button but shows a snackbar on tap
  /// instead of adding the item to the cart.
  Widget _buildOutOfStockChip() {
    final isOutlinedGreen =
        widget.style == ProductAddToCartButtonStyle.outlinedGreen;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final l10n = AppLocalizations.of(context);
          final message = l10n?.outOfStock ?? 'Out of stock';
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  message,
                  style: const TextStyle(color: AppColors.white),
                ),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
        },
        borderRadius: BorderRadius.circular(isOutlinedGreen ? 17 : 12),
        child: Container(
          constraints: isOutlinedGreen ? _outlinedGreenFixedSize : null,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: isOutlinedGreen ? 0 : 16,
            vertical: isOutlinedGreen ? 0 : 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(isOutlinedGreen ? 17 : 12),
            border: isOutlinedGreen
                ? Border.all(color: AppColors.secondaryGreen, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: isOutlinedGreen ? 2 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'ADD',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isOutlinedGreen
                    ? AppColors.secondaryGreen
                    : AppColors.primaryOrange,
                fontWeight: FontWeight.w800,
                fontSize: isOutlinedGreen ? 13 : 12,
                letterSpacing: isOutlinedGreen ? 1.5 : 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build the initial "Add" button
  Widget _buildAddButton(
    BuildContext context, {
    required bool isLoading,
    bool showOptionsCount = false,
  }) {
    final isOutlinedGreen =
        widget.style == ProductAddToCartButtonStyle.outlinedGreen;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading
            ? null
            : () {
                if (_hasMultipleVariants) {
                  _showVariantSheet();
                } else {
                  _addToCart();
                }
              },
        borderRadius: BorderRadius.circular(isOutlinedGreen ? 17 : 12),
        child: Container(
          constraints: isOutlinedGreen
              ? (showOptionsCount
                    ? _outlinedGreenWithOptionsSize
                    : _outlinedGreenFixedSize)
              : null,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: isOutlinedGreen ? 0 : 16,
            vertical: isOutlinedGreen ? 0 : 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(isOutlinedGreen ? 17 : 12),
            border: isOutlinedGreen
                ? Border.all(color: AppColors.secondaryGreen, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: isOutlinedGreen ? 2 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOutlinedGreen
                          ? AppColors.secondaryGreen
                          : AppColors.primaryOrange,
                    ),
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ADD',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isOutlinedGreen
                              ? AppColors.secondaryGreen
                              : AppColors.primaryOrange,
                          fontWeight: FontWeight.w800,
                          fontSize: isOutlinedGreen ? 13 : 12,
                          letterSpacing: isOutlinedGreen ? 1.5 : 0.5,
                          height: 1,
                        ),
                      ),
                      if (showOptionsCount && _activeVariantCount > 1) ...[
                        const SizedBox(height: 1),
                        Text(
                          '$_activeVariantCount options',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isOutlinedGreen
                                ? AppColors.secondaryGreen
                                : AppColors.primaryOrange,
                            fontWeight: FontWeight.w600,
                            fontSize: 9,
                            letterSpacing: 0.2,
                            height: 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
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
    final isOutlinedGreen =
        widget.style == ProductAddToCartButtonStyle.outlinedGreen;

    return Container(
      constraints: isOutlinedGreen ? _outlinedGreenFixedSize : null,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOutlinedGreen
              ? const [Color(0xFF43A047), Color(0xFF2E7D32)]
              : [AppColors.primaryOrange, AppColors.primaryOrangeDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isOutlinedGreen ? 17 : 12),
        border: isOutlinedGreen
            ? Border.all(color: const Color(0xFF2E7D32), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color:
                (isOutlinedGreen
                        ? const Color(0xFF2E7D32)
                        : AppColors.primaryOrange)
                    .withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isOutlinedGreen ? 2 : 4,
        vertical: isOutlinedGreen ? 0 : 2,
      ),
      child: Row(
        mainAxisSize: isOutlinedGreen ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildControlButton(
            context,
            icon: quantity == 1 ? Icons.delete_outline : Icons.remove,
            isOutlinedGreen: isOutlinedGreen,
            onTap: isLoading
                ? null
                : () => _decrementQuantity(context, quantity, cartItemId),
          ),
          Container(
            constraints: BoxConstraints(minWidth: isOutlinedGreen ? 18 : 24),
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
          _buildControlButton(
            context,
            icon: Icons.add,
            isOutlinedGreen: isOutlinedGreen,
            onTap: isLoading
                ? null
                : () => _incrementQuantity(context, quantity, cartItemId),
          ),
        ],
      ),
    );
  }

  /// Build individual control button (+ or -)
  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required bool isOutlinedGreen,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isOutlinedGreen ? 9 : 6),
      child: Padding(
        padding: EdgeInsets.all(isOutlinedGreen ? 2 : 4),
        child: Icon(icon, size: isOutlinedGreen ? 14 : 16, color: Colors.white),
      ),
    );
  }

  /// Build a combined quantity badge for multi-variant products.
  /// Tapping opens the variant selection sheet for fine-grained control.
  Widget _buildMultiVariantQuantityBadge(
    BuildContext context, {
    required int totalQty,
  }) {
    final isOutlinedGreen =
        widget.style == ProductAddToCartButtonStyle.outlinedGreen;

    return GestureDetector(
      onTap: _showVariantSheet,
      child: Container(
        constraints: isOutlinedGreen ? _outlinedGreenWithOptionsSize : null,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isOutlinedGreen
                ? const [Color(0xFF43A047), Color(0xFF2E7D32)]
                : [AppColors.primaryOrange, AppColors.primaryOrangeDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(isOutlinedGreen ? 17 : 12),
          border: isOutlinedGreen
              ? Border.all(color: const Color(0xFF2E7D32), width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color:
                  (isOutlinedGreen
                          ? const Color(0xFF2E7D32)
                          : AppColors.primaryOrange)
                      .withValues(alpha: 0.35),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isOutlinedGreen ? 6 : 8,
          vertical: isOutlinedGreen ? 2 : 4,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_cart, size: 11, color: Colors.white),
                const SizedBox(width: 3),
                Text(
                  '$totalQty',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 1),
            Text(
              '$_activeVariantCount options',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 8,
                letterSpacing: 0.2,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show the variant selection bottom sheet
  Future<void> _showVariantSheet() async {
    if (_needsVariantEnrichment && _discoveredVariants == null) {
      final resolved = await _fetchVariantsFromDetails(showErrors: true);
      if (!mounted || !resolved || _hasResolvedNoSellableVariants) {
        return;
      }
    }

    final activeVariants = _activeVariants;
    if (activeVariants.isEmpty) return;

    VariantSelectionBottomSheet.show(
      context,
      productName: widget.productName ?? 'Select Variant',
      productImageUrl: widget.productImageUrl,
      variants: activeVariants,
      isQuickDelivery: widget.isQuickDelivery,
    );
  }

  /// Add item to cart - fetches variant ID if not available
  Future<void> _addToCart() async {
    if (_needsVariantEnrichment && _discoveredVariants == null) {
      final resolved = await _fetchVariantsFromDetails(showErrors: true);
      if (!mounted || !resolved || _hasResolvedNoSellableVariants) {
        return;
      }
    }

    // If multiple variants are known (widget-provided or discovered), show sheet
    if (_hasMultipleVariants) {
      await _showVariantSheet();
      return;
    }

    // If we already have a variant ID and variants are resolved, add directly
    if (_effectiveVariantId != null) {
      _addToCartWithVariant(_effectiveVariantId!);
      return;
    }

    final resolved = await _fetchVariantsFromDetails(showErrors: true);
    if (!mounted || !resolved || _hasResolvedNoSellableVariants) {
      return;
    }

    if (_hasMultipleVariants) {
      await _showVariantSheet();
      return;
    }

    if (_effectiveVariantId != null) {
      _addToCartWithVariant(_effectiveVariantId!);
    } else if (_effectiveVariants != null && mounted) {
      _showOutOfStockMessage(_effectiveVariants!);
    }
  }

  /// Add to cart with known variant ID
  /// Checks if item already exists in cart and updates quantity instead of adding duplicate
  void _addToCartWithVariant(int variantId) {
    if (widget.isQuickDelivery) {
      debugPrint(
        'Quick add variant resolution: '
        'productId=${widget.productId}, '
        'widgetVariantId=${widget.productVariantId}, '
        'resolvedVariantId=$variantId, '
        'providedVariantIds=${widget.variants?.map((variant) => variant.id).toList()}',
      );
    }

    final cartCubit = context.read<CartCubit>();
    final cart = _getCartFromState(cartCubit.state);

    // Check if this variant already exists in the cart
    final existingItem = cart?.items
        .where(
          (item) =>
              item.productVariantId == variantId &&
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
      widget.onQuantityChanged?.call(newQty);
    } else {
      // Item doesn't exist - add new
      cartCubit.addItemToCart(
        productVariantId: variantId,
        qty: 1,
        deliveryType: _deliveryType,
      );
      widget.onAdded?.call();
      widget.onQuantityChanged?.call(1);
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
    widget.onQuantityChanged?.call(newQty);
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
      widget.onQuantityChanged?.call(0);
    } else {
      final newQty = currentQty - 1;
      context.read<CartCubit>().updateItem(
        cartItemId: cartItemId,
        qty: newQty,
        deliveryType: _deliveryType,
      );
      widget.onQuantityChanged?.call(newQty);
    }
  }
}
