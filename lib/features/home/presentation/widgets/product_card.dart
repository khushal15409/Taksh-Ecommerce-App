import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/taksh_ui.dart';
import 'package:taksh_e_commerce/features/cart/presentation/widgets/product_add_to_cart_button.dart';
import 'package:taksh_e_commerce/features/home/data/models/product_model.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_ecommerce_product_details.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/widgets/wishlist_heart_button.dart';

/// Enum to define different product card layouts
enum ProductCardVariant {
  /// Standard layout for 3-column grids (more spacious)
  standard,

  /// Compact layout for 4+ column grids (more condensed)
  compact,
}

/// Product card widget for displaying product in lists/grids
/// White rounded card: image with discount badge and add button, then name,
/// rating and price
class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final bool showDeliveryTime;

  /// Layout variant - use [ProductCardVariant.compact] for 4+ column grids
  final ProductCardVariant variant;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.variant = ProductCardVariant.standard,
    this.showDeliveryTime = true,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  static final Map<int, String?> _resolvedImageCache = <int, String?>{};
  static final Map<int, Future<String?>> _pendingImageRequests =
      <int, Future<String?>>{};

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  String? _resolvedImageUrl;
  bool _isResolvingImage = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
    _initializeImageResolution();
  }

  @override
  void didUpdateWidget(covariant ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.product.id != widget.product.id ||
        oldWidget.product.imageUrl != widget.product.imageUrl) {
      _initializeImageResolution();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _scaleController.forward();
  void _onTapUp(TapUpDetails details) => _scaleController.reverse();
  void _onTapCancel() => _scaleController.reverse();

  String? _normalizeImageUrl(String? imageUrl) {
    final normalized = imageUrl?.trim();
    if (normalized == null ||
        normalized.isEmpty ||
        normalized.toLowerCase() == 'null') {
      return null;
    }

    return normalized;
  }

  void _initializeImageResolution() {
    final directImageUrl = _normalizeImageUrl(widget.product.imageUrl);
    if (directImageUrl != null) {
      _resolvedImageCache[widget.product.id] = directImageUrl;
      _resolvedImageUrl = directImageUrl;
      _isResolvingImage = false;
      return;
    }

    if (_resolvedImageCache.containsKey(widget.product.id)) {
      _resolvedImageUrl = _resolvedImageCache[widget.product.id];
      _isResolvingImage = false;
      return;
    }

    _resolvedImageUrl = null;
    _isResolvingImage = true;
    _resolveMissingImageUrl(widget.product.id);
  }

  Future<void> _resolveMissingImageUrl(int productId) async {
    final imageFuture = _pendingImageRequests.putIfAbsent(productId, () async {
      final result = await getIt<GetEcommerceProductDetails>()(
        GetEcommerceProductDetailsParams(productId: productId),
      );

      return result.fold(
        (_) => null,
        (product) => _normalizeImageUrl(product.primaryImageUrl),
      );
    });

    final imageUrl = await imageFuture;
    _pendingImageRequests.remove(productId);
    _resolvedImageCache[productId] = imageUrl;

    if (!mounted || widget.product.id != productId) {
      return;
    }

    setState(() {
      _resolvedImageUrl = imageUrl;
      _isResolvingImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isCompact = widget.variant == ProductCardVariant.compact;
    final discount = _discountPercentage(product);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.grey200),
            boxShadow: takshSoftShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.05,
                child: _buildImageArea(product, discount, isCompact),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.showDeliveryTime) ...[
                        _buildDeliveryChip(isCompact),
                        const SizedBox(height: 4),
                      ],
                      _buildName(product, isCompact),
                      _buildRating(product),
                      const Spacer(),
                      _buildPriceRow(product, discount != null, isCompact),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageArea(ProductModel product, int? discount, bool isCompact) {
    final imageUrl = _resolvedImageUrl;
    const radius = Radius.circular(17);

    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: radius),
            child: Container(
              color: AppColors.grey50,
              padding: const EdgeInsets.all(8),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => _buildImageLoader(),
                      errorWidget: (context, url, error) =>
                          _buildImageFallback(isCompact),
                    )
                  : _isResolvingImage
                  ? _buildImageLoader()
                  : _buildImageFallback(isCompact),
            ),
          ),
        ),
        if (discount != null)
          Positioned(top: 8, left: 8, child: TakshDiscountBadge(percent: discount)),
        Positioned(
          top: 6,
          right: 6,
          child: WishlistHeartButton(productId: product.id),
        ),
        if (!product.inStock)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: radius),
              child: Container(
                color: Colors.white.withOpacity(0.72),
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.62),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Out of\nStock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: isCompact ? 11 : 12,
                      height: 1.2,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          right: 8,
          bottom: 8,
          child: ProductAddToCartButton(
            productId: product.id,
            productVariantId: product.productVariantId,
            style: ProductAddToCartButtonStyle.outlinedGreen,
            inStock: product.inStock,
            isQuickDelivery: widget.showDeliveryTime,
            variants: product.variants,
            productName: product.name,
            productImageUrl: imageUrl,
          ),
        ),
      ],
    );
  }

  Widget _buildImageLoader() {
    return const Center(
      child: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildImageFallback(bool isCompact) {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: isCompact ? 26 : 30,
        color: AppColors.grey400,
      ),
    );
  }

  Widget _buildDeliveryChip(bool isCompact) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 7 : 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondaryGreen.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '30 minutes',
        style: TextStyle(
          color: AppColors.secondaryGreenDark,
          fontSize: isCompact ? 10 : 11,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildName(ProductModel product, bool isCompact) {
    return Text(
      product.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: isCompact ? 12 : 13,
        fontWeight: FontWeight.w600,
        color: AppColors.grey900,
        height: 1.2,
      ),
    );
  }

  /// Shows the real rating only when the backend provided one.
  Widget _buildRating(ProductModel product) {
    final rating = product.averageRating;
    if (rating == null || rating <= 0) return const SizedBox(height: 2);

    final reviews = product.totalReviews;
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: AppColors.rating),
          const SizedBox(width: 2),
          Flexible(
            child: Text(
              reviews != null && reviews > 0
                  ? '${rating.toStringAsFixed(1)} ($reviews)'
                  : rating.toStringAsFixed(1),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.grey600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(ProductModel product, bool hasDiscount, bool isCompact) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 5,
      children: [
        Text(
          formatRupees(product.salePrice),
          maxLines: 1,
          style: TextStyle(
            color: AppColors.grey900,
            fontSize: isCompact ? 14 : 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (hasDiscount)
          Text(
            formatRupees(product.originalPrice),
            maxLines: 1,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.grey500,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColors.grey500,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  int? _discountPercentage(ProductModel product) {
    if (product.originalPrice <= 0 ||
        product.salePrice >= product.originalPrice) {
      return null;
    }
    final value =
        ((product.originalPrice - product.salePrice) /
                product.originalPrice *
                100)
            .round();
    return value > 0 ? value : null;
  }
}
