import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/utils/media_url.dart';
import 'package:taksh_e_commerce/core/widgets/taksh_ui.dart';
import 'package:taksh_e_commerce/features/product/presentation/widgets/product_image_gallery.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/core/widgets/expandable_text.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:taksh_e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:taksh_e_commerce/features/cart/presentation/cubit/cart_state.dart';
import 'package:taksh_e_commerce/features/cart/presentation/widgets/add_to_cart_button.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/selected_checkout_items.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product_image.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product_variant.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/delivery_check_cubit.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/delivery_check_state.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_cubit.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_state.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/similar_products_cubit.dart';
import 'package:taksh_e_commerce/features/product/presentation/widgets/similar_products_section.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/cubit/wishlist_state.dart';

/// Product details page for ecommerce products
class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  /// Selected variant for add to cart
  ProductVariant? _selectedVariant;

  bool _isBuyNowLoading = false;

  /// Cubit for managing similar products
  late final SimilarProductsCubit _similarProductsCubit;

  /// Cubit for checking delivery availability
  late final DeliveryCheckCubit _deliveryCheckCubit;

  final TextEditingController _pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _similarProductsCubit = getIt<SimilarProductsCubit>();
    _deliveryCheckCubit = getIt<DeliveryCheckCubit>();
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    _similarProductsCubit.close();
    _deliveryCheckCubit.close();
    super.dispose();
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    // No route underneath (e.g. deep link / thin post-auth stack) — land on home.
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    // Top artwork follows the product's category.
    final detailsState = context.watch<ProductCubit>().state;
    final artStyle = detailsState is ProductDetailsLoaded
        ? TakshArt.forCategory(
            detailsState.product.category?.name,
            seed: detailsState.product.categoryId,
          )
        : TakshArt.forCategory(null);

    return BlocProvider<SimilarProductsCubit>.value(
      value: _similarProductsCubit,
      child: BlocProvider<DeliveryCheckCubit>.value(
        value: _deliveryCheckCubit,
        child: PopScope(
          // Allow native back/swipe when a route is underneath; otherwise
          // intercept and send the user to home instead of exiting the app.
          canPop: context.canPop(),
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            context.go(AppRoutes.home);
          },
          child: TakshSoftBackground(
          art: artStyle.art,
          accent: artStyle.accent,
          artHeight: 230,
          child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(AppLocalizations.of(context)!.productDetails),
            leading: IconButton(
              style: IconButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () => _handleBack(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            ),
            actions: [
              BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, wishlistState) {
                  // Extract current product ID from ProductCubit state
                  final productState = context.watch<ProductCubit>().state;
                  int? productId;
                  if (productState is ProductDetailsLoaded) {
                    productId = productState.product.id;
                  }

                  final isWishlisted =
                      productId != null &&
                      context.read<WishlistCubit>().isWishlisted(productId);
                  final isLoading =
                      (wishlistState is AddingToWishlist &&
                          wishlistState.productId == productId) ||
                      (wishlistState is RemovingFromWishlist &&
                          wishlistState.productId == productId);

                  return IconButton(
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: productId == null || isLoading
                        ? null
                        : () {
                            context.read<WishlistCubit>().toggleWishlist(
                              productId: productId!,
                            );
                          },
                    icon: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            isWishlisted
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isWishlisted ? Colors.red : null,
                          ),
                  );
                },
              ),
            ],
          ),
          body: BlocConsumer<ProductCubit, ProductState>(
            listener: (context, state) {
              // Fetch similar products when product details are loaded
              if (state is ProductDetailsLoaded) {
                _similarProductsCubit.fetchSimilarProducts(
                  categoryId: state.product.categoryId,
                  currentProductId: state.product.id,
                  limit: 10,
                );
              }
            },
            builder: (context, state) {
              if (state is ProductDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProductError) {
                return _buildErrorState(context, state.message);
              }

              if (state is ProductDetailsLoaded) {
                // Auto-select first variant if available
                if (_selectedVariant == null &&
                    state.product.variants != null &&
                    state.product.variants!.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _selectedVariant =
                            _preferredVariant(state.product) ??
                            state.product.variants!.first;
                      });
                    }
                  });
                }
                return _buildProductContent(context, state.product);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        ),
        ),
      ),
    );
  }

  Widget _buildProductContent(BuildContext context, Product product) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 44),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 18,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageGallery(product),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
          _buildTopMetaRow(product),
          const SizedBox(height: 10),
          Text(
            product.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            _selectedWeightLabel(product),
            style: const TextStyle(
              color: AppColors.grey600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          _buildPriceRow(context, product),
          const SizedBox(height: 18),
          _buildDeliveryAvailabilitySection(product.id),
          if (product.variants != null && product.variants!.isNotEmpty) ...[
            const SizedBox(height: 18),
            _buildVariantsSection(product),
          ],
          if (product.ratingSummary != null) ...[
            const SizedBox(height: 18),
            _buildRatingSection(context, product),
          ],
          const SizedBox(height: 20),
          _buildActionButtons(product),
          const SizedBox(height: 18),
          _buildSection(
            context,
            title: AppLocalizations.of(context)!.description,
            child: ExpandableText(
              text: product.description ??
                  product.shortDescription ??
                  'No product details available.',
              style: const TextStyle(
                color: AppColors.grey700,
                fontSize: 16,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 22),
          SimilarProductsSection(
            title: AppLocalizations.of(context)!.similarProducts,
            cardWidth: 150,
            cardHeight: 210,
          ),
          const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Product product) {
    final selectedVariant = _selectedOrPreferredVariant(product);
    final variantId = selectedVariant?.id;
    final isInStock = _effectiveInStock(product);
    final outOfStockMessage = _effectiveOutOfStockMessage(product);

    // Out-of-stock banner + disabled buttons
    if (!isInStock) {
      return Column(
        children: [
          // Out-of-stock info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEF9A9A), width: 1),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFFE53935),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    outOfStockMessage,
                    style: const TextStyle(
                      color: Color(0xFFB71C1C),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Disabled Add to Cart
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: const Color(0xFFBDBDBD),
                disabledForegroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Disabled Buy Now
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: null,
              style: OutlinedButton.styleFrom(
                disabledForegroundColor: const Color(0xFFBDBDBD),
                side: const BorderSide(color: Color(0xFFBDBDBD), width: 1.6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      );
    }

    if (variantId == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        AddToCartButton(
          productVariantId: variantId,
          productId: product.id,
          size: 'large',
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isBuyNowLoading
                ? null
                : () {
                    // Guest users must log in before buying.
                    final authState = context.read<AuthBloc>().state;
                    if (authState is! Authenticated) {
                      final redirectTarget = AppRoutes.productDetails(
                        product.id,
                      );
                      context.push(
                        '${AppRoutes.login}?redirectAfter=${Uri.encodeComponent(redirectTarget)}',
                      );
                      return;
                    }
                    _handleBuyNow(product);
                  },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.secondaryGreenDark,
              side: const BorderSide(
                color: AppColors.secondaryGreen,
                width: 1.6,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isBuyNowLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.secondaryGreen,
                    ),
                  )
                : const Text(
                    'Buy Now',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleBuyNow(Product product) async {
    if (!_effectiveInStock(product)) {
      _showOutOfStockSnackBar(
        _effectiveOutOfStockMessage(product),
      );
      return;
    }

    final variantId = _selectedOrPreferredVariant(product)?.id;
    if (variantId == null) return;

    final cartCubit = context.read<CartCubit>();
    final cart = _getCartFromState(cartCubit.state);
    final existingItem = cart?.items
        .where(
          (item) =>
              item.productVariantId == variantId &&
              CartCubit.matchesDeliveryType(
                item,
                CartCubit.deliveryTypeStandard,
              ),
        )
        .firstOrNull;

    setState(() {
      _isBuyNowLoading = true;
    });

    if (existingItem == null) {
      await cartCubit.addItemToCart(
        productVariantId: variantId,
        qty: 1,
        deliveryType: CartCubit.deliveryTypeStandard,
      );
    }

    if (!mounted) return;

    final cartState = cartCubit.state;

    setState(() {
      _isBuyNowLoading = false;
    });

    if (cartState is CartError) {
      _showCalmErrorToast(context);
      return;
    }

    if (cartState is CartLoaded ||
        cartState is CartOperationSuccess ||
        existingItem != null) {
      final updatedCart = existingItem != null
          ? cart
          : _getCartFromState(cartState);
      if (updatedCart == null || updatedCart.items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cart is empty. Please try again.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Buy now should proceed with the currently selected variant only.
      final selectedItem = updatedCart.items
          .where(
            (item) =>
                item.productVariantId == variantId &&
                CartCubit.matchesDeliveryType(
                  item,
                  CartCubit.deliveryTypeStandard,
                ),
          )
          .firstOrNull;

      final checkoutItems = selectedItem != null
          ? <CartItem>[selectedItem]
          : updatedCart.items;

      final subtotal = checkoutItems.fold<int>(
        0,
        (sum, item) => sum + item.total,
      );
      final totalQuantity = checkoutItems.fold<int>(
        0,
        (sum, item) => sum + item.qty,
      );

      context.push(
        AppRoutes.checkout,
        extra: SelectedCheckoutItems(
          items: checkoutItems,
          itemIds: checkoutItems.map((item) => item.id).toList(),
          subtotal: subtotal,
          totalQuantity: totalQuantity,
          extraCharges: updatedCart.extraCharges,
        ),
      );
    } else {
      _showCalmErrorToast(context);
    }
  }

  void _showCalmErrorToast(BuildContext context) {
    AppErrorToast.show(context);
  }

  void _showOutOfStockSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFE53935),
        ),
      );
  }

  Cart? _getCartFromState(CartState state) {
    if (state is CartLoaded) return state.cart;
    if (state is CartOperationSuccess) return state.cart;
    if (state is AddingToCart) return state.currentCart;
    if (state is UpdatingCartItem) return state.currentCart;
    if (state is RemovingFromCart) return state.currentCart;
    if (state is CartLoading) return state.previousCart;
    return null;
  }

  Widget _buildImageGallery(Product product) {
    final urls = <String>[
      for (final image in product.images ?? const <ProductImage>[])
        if (resolveMediaUrl(image.imageUrl) case final url?) url,
    ];
    if (urls.isEmpty) {
      final primary = resolveMediaUrl(product.primaryImageUrl);
      if (primary != null) urls.add(primary);
    }

    return ProductImageGallery(urls: urls);
  }

  Widget _buildPriceRow(BuildContext context, Product product) {
    final salePrice = _displaySalePrice(product);
    final originalPrice = _displayOriginalPrice(product);
    final hasDiscount =
        salePrice != null &&
        originalPrice != null &&
        salePrice < originalPrice;
    final discountLabel = _displayDiscountLabel(product);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (salePrice != null)
          Text(
            '₹${_formatPrice(salePrice)}',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              height: 0.95,
            ),
          ),
        if (hasDiscount)
          Text(
            'MRP ₹${_formatPrice(originalPrice)}',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.grey600,
              decoration: TextDecoration.lineThrough,
              height: 1.3,
            ),
          ),
        if (discountLabel != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              discountLabel,
              style: const TextStyle(
                color: AppColors.primaryOrangeDark,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTopMetaRow(Product product) {
    final reviewCount = product.ratingSummary?.totalReviews ?? 0;

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_outlined, color: Color(0xFFE4C74A), size: 20),
            SizedBox(width: 4),
            Text(
              '25 MINS',
              style: TextStyle(
                color: AppColors.grey500,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
        if (product.ratingSummary != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  index < (product.ratingSummary!.averageRating.round())
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: const Color(0xFFE4B800),
                  size: 18,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '($reviewCount reviews)',
                style: const TextStyle(
                  color: AppColors.grey700,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        // In Stock / Out of Stock badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _effectiveInStock(product)
                ? const Color(0xFFE8F5E9)
                : const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _effectiveInStock(product)
                  ? AppColors.secondaryGreen
                  : const Color(0xFFE53935),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _effectiveInStock(product)
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                size: 15,
                color: _effectiveInStock(product)
                    ? AppColors.secondaryGreen
                    : const Color(0xFFE53935),
              ),
              const SizedBox(width: 5),
              Text(
                _effectiveInStock(product)
                    ? AppLocalizations.of(context)!.inStock
                    : AppLocalizations.of(context)!.outOfStock,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _effectiveInStock(product)
                      ? AppColors.secondaryGreen
                      : const Color(0xFFE53935),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryAvailabilitySection(int productId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: AppColors.secondaryGreen,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.checkDeliveryAvailability,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  // Reset result when the user edits the pincode
                  if (_deliveryCheckCubit.state is! DeliveryCheckInitial) {
                    _deliveryCheckCubit.reset();
                  }
                },
                decoration: InputDecoration(
                  counterText: '',
                  hintText: AppLocalizations.of(context)!.enterPincode,
                  hintStyle: const TextStyle(color: AppColors.grey500),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            BlocBuilder<DeliveryCheckCubit, DeliveryCheckState>(
              builder: (context, state) {
                final isLoading = state is DeliveryCheckLoading;
                return SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            final pincode = _pincodeController.text.trim();
                            if (pincode.length != 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.invalidPincode,
                                    style: const TextStyle(
                                      color: AppColors.white,
                                    ),
                                  ),
                                  backgroundColor: AppColors.error,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            context.read<DeliveryCheckCubit>().check(
                              productId: productId,
                              pincode: pincode,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryGreen,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.secondaryGreen
                          .withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)!.check,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
        // Result card
        BlocBuilder<DeliveryCheckCubit, DeliveryCheckState>(
          builder: (context, state) {
            if (state is DeliveryCheckInitial ||
                state is DeliveryCheckLoading) {
              return const SizedBox.shrink();
            }

            if (state is DeliveryCheckError) {
              return _buildDeliveryResultCard(
                icon: Icons.error_outline_rounded,
                iconColor: const Color(0xFFE53935),
                backgroundColor: const Color(0xFFFFEBEE),
                borderColor: const Color(0xFFEF9A9A),
                message: AppLocalizations.of(context)!.couldNotCheckDelivery,
                subMessage: null,
                isDeliverable: false,
              );
            }

            if (state is DeliveryCheckLoaded) {
              final r = state.result;
              return _buildDeliveryResultCard(
                icon: r.isDeliverable
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                iconColor: r.isDeliverable
                    ? AppColors.secondaryGreen
                    : const Color(0xFFE53935),
                backgroundColor: r.isDeliverable
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderColor: r.isDeliverable
                    ? AppColors.secondaryGreen
                    : const Color(0xFFEF9A9A),
                message: r.message,
                subMessage: r.vendor != null
                    ? AppLocalizations.of(
                        context,
                      )!.fulfilledBy(r.vendor!.shopName)
                    : null,
                isDeliverable: r.isDeliverable,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildDeliveryResultCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required Color borderColor,
    required String message,
    required String? subMessage,
    required bool isDeliverable,
  }) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        color: isDeliverable
                            ? const Color(0xFF1B5E20)
                            : const Color(0xFFB71C1C),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subMessage != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subMessage,
                        style: TextStyle(
                          color: isDeliverable
                              ? const Color(0xFF388E3C)
                              : const Color(0xFFE53935),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildVariantsSection(Product product) {
    final variants = product.variants ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.selectVariant,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: variants.map((variant) {
            final attributes =
                variant.variantAttributes
                    ?.map((attr) => attr.attributeValue?.value)
                    .whereType<String>()
                    .toList() ??
                [];
            final label = attributes.isNotEmpty
                ? attributes.join(' • ')
                : variant.sku;
            final isSelected = _selectedVariant?.id == variant.id;
            final isInStock = variant.isAvailableForSale;
            final canSelectVariant =
              !variant.hasStockInfo || variant.isAvailableForSale;
            final selectedBackground = isInStock
                ? Theme.of(context).primaryColor
                : const Color(0xFFFFEBEE);
            final selectedBorder = isInStock
                ? Theme.of(context).primaryColor
                : const Color(0xFFE53935);
            final idleBackground = isInStock
                ? AppColors.grey100
                : const Color(0xFFFFF5F5);
            final idleBorder = isInStock
                ? AppColors.grey300
                : const Color(0xFFEF9A9A);
            final selectedTextColor = isInStock
                ? Colors.white
                : const Color(0xFFB71C1C);
            final idleTextColor = isInStock
                ? AppColors.grey800
                : const Color(0xFFB71C1C);

            return GestureDetector(
              onTap: canSelectVariant
                  ? () {
                      setState(() {
                        _selectedVariant = variant;
                      });
                    }
                  : null,
              child: Chip(
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? selectedTextColor : idleTextColor,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                    if (!isInStock)
                      Text(
                        AppLocalizations.of(context)!.outOfStock,
                        style: TextStyle(
                          color:
                              isSelected ? selectedTextColor : idleTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
                backgroundColor:
                    isSelected ? selectedBackground : idleBackground,
                side: isSelected
                    ? BorderSide(color: selectedBorder)
                    : BorderSide(color: idleBorder),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  ProductVariant? _selectedOrPreferredVariant(Product product) {
    final variants = product.variants;
    if (variants == null || variants.isEmpty) return null;

    if (_selectedVariant != null) {
      for (final variant in variants) {
        if (variant.id == _selectedVariant!.id) {
          return variant;
        }
      }
    }

    return _preferredVariant(product);
  }

  ProductVariant? _preferredVariant(Product product) {
    final variants = product.variants;
    if (variants == null || variants.isEmpty) return null;

    for (final variant in variants) {
      if (variant.hasStockInfo && variant.isAvailableForSale) {
        return variant;
      }
    }

    if (product.inStock) {
      for (final variant in variants) {
        if (variant.isActive) {
          return variant;
        }
      }
    }

    return variants.first;
  }

  bool _effectiveInStock(Product product) {
    final selectedVariant = _selectedOrPreferredVariant(product);
    if (selectedVariant != null && selectedVariant.hasStockInfo) {
      return selectedVariant.isAvailableForSale;
    }

    return product.inStock;
  }

  String _effectiveOutOfStockMessage(Product product) {
    final selectedVariant = _selectedOrPreferredVariant(product);
    return (selectedVariant?.hasStockInfo == true
            ? selectedVariant?.outOfStockMessage
            : null) ??
        product.outOfStockMessage ??
        'This product is currently out of stock.';
  }

  num? _parsePriceValue(String? value) {
    if (value == null) return null;
    final normalized = value.trim();
    if (normalized.isEmpty) return null;
    return num.tryParse(normalized);
  }

  num? _displaySalePrice(Product product) {
    final selectedVariant = _selectedOrPreferredVariant(product);
    final variantSalePrice = _parsePriceValue(selectedVariant?.salePrice);
    if (variantSalePrice != null && variantSalePrice > 0) {
      return variantSalePrice;
    }

    final variantPrice = _parsePriceValue(selectedVariant?.price);
    if (variantPrice != null && variantPrice > 0) {
      return variantPrice;
    }

    return product.salePrice;
  }

  Widget _buildRatingSection(BuildContext context, Product product) {
    final rating = product.ratingSummary!;
    return _buildSection(
      context,
      title: AppLocalizations.of(context)!.ratings,
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 20),
          const SizedBox(width: 4),
          Text(
            '${rating.averageRating} (${rating.totalReviews} reviews)',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  num? _displayOriginalPrice(Product product) {
    final selectedVariant = _selectedOrPreferredVariant(product);
    final variantPrice = _parsePriceValue(selectedVariant?.price);
    if (variantPrice != null && variantPrice > 0) {
      return variantPrice;
    }

    return product.originalPrice;
  }

  String? _displayDiscountLabel(Product product) {
    final salePrice = _displaySalePrice(product);
    final originalPrice = _displayOriginalPrice(product);
    if (salePrice == null || originalPrice == null || salePrice >= originalPrice) {
      return null;
    }

    final discountPercentage =
        ((originalPrice - salePrice) / originalPrice * 100).round();
    if (discountPercentage <= 0) {
      return product.discountLabel;
    }

    return '$discountPercentage% OFF';
  }

  String _formatPrice(num value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }

  String _selectedWeightLabel(Product product) {
    final selectedWeight = _selectedVariant?.weight;
    if (selectedWeight != null && selectedWeight.trim().isNotEmpty) {
      return selectedWeight;
    }

    for (final variant in product.variants ?? <ProductVariant>[]) {
      if (variant.weight != null && variant.weight!.trim().isNotEmpty) {
        return variant.weight!;
      }
    }

    return '1 unit';
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.failedToLoadProduct,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ProductCubit>().fetchEcommerceProductDetails(1);
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }
}
