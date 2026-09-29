import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/cart/presentation/widgets/product_add_to_cart_button.dart';
import 'package:taksh_e_commerce/features/home/data/models/product_model.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_ecommerce_product_details.dart';

/// Enum to define different product card layouts
enum ProductCardVariant {
  /// Standard layout for 3-column grids (more spacious)
  standard,

  /// Compact layout for 4+ column grids (more condensed)
  compact,
}

/// Product card widget for displaying product in lists/grids
/// Clean Blinkit/Zepto inspired design
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
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVisualCard(product, isCompact),
              SizedBox(height: isCompact ? 1 : 3),
              if (widget.showDeliveryTime) ...[
                SizedBox(height: isCompact ? 5 : 6),
                _buildDeliveryChip(isCompact),
                SizedBox(height: isCompact ? 5 : 6),
              ] else ...[
                SizedBox(height: isCompact ? 8 : 10),
              ],
              _buildName(product, isCompact),
              SizedBox(height: isCompact ? 4 : 5),
              _buildRatingStars(product, isCompact),
              SizedBox(height: isCompact ? 4 : 5),
              _buildDiscountRow(discount, isCompact),
              SizedBox(height: isCompact ? 2 : 3),
              _buildFinalPrice(product, isCompact),
              if (discount != null)
                Padding(
                  padding: EdgeInsets.only(top: isCompact ? 1 : 2),
                  child: Text(
                    '₹${product.originalPrice.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: isCompact ? 12 : 13,
                      color: AppColors.grey500,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.grey500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisualCard(ProductModel product, bool isCompact) {
    final outerRadius = isCompact ? 20.0 : 22.0;
    final innerInset = isCompact ? 8.0 : 10.0;
    final innerRadius = outerRadius - 6;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imageUrl = _resolvedImageUrl;

    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 15,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF303030)
                    : const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(outerRadius),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF404040)
                      : const Color(0xFFE9E9E9),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.all(innerInset),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(innerRadius),
                        child: imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.image_outlined,
                                  size: isCompact ? 26 : 30,
                                  color: AppColors.grey400,
                                ),
                              )
                            : _isResolvingImage
                            ? const Center(
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.image_outlined,
                                size: isCompact ? 26 : 30,
                                color: AppColors.grey400,
                              ),
                      ),
                    ),
                  ),
                  Positioned(top: 8, left: 8, child: _buildHotBadge(isCompact)),
                  if (!product.inStock)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(outerRadius),
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
                    left: 12,
                    right: 12,
                    bottom: 0,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
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
          ),
        ],
      ),
    );
  }

  Widget _buildHotBadge(bool isCompact) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 7,
        vertical: isCompact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFF4A3D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'HOT',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: isCompact ? 10 : 11,
          letterSpacing: 0.4,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildDeliveryChip(bool isCompact) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 10,
        vertical: isCompact ? 1.5 : 2,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF404040) : const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '30 minutes',
        style: TextStyle(
          color: const Color(0xFFE46A61),
          fontSize: isCompact ? 11 : 12,
          fontWeight: FontWeight.w700,
          height: 1.1,
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
        fontSize: isCompact ? 13 : 14,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.bodyLarge?.color,
        height: 1.08,
      ),
    );
  }

  Widget _buildRatingStars(ProductModel product, bool isCompact) {
    final filled = ((product.averageRating ?? 4.5).round()).clamp(1, 5);
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return Icon(
            index < filled ? Icons.star_rounded : Icons.star_border_rounded,
            size: isCompact ? 17 : 18,
            color: const Color(0xFFF7C71A),
          );
        }),
      ),
    );
  }

  Widget _buildDiscountRow(int? discount, bool isCompact) {
    if (discount == null) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            '$discount% off',
            style: TextStyle(
              color: const Color(0xFF2E97E8),
              fontSize: isCompact ? 15 : 16,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFinalPrice(ProductModel product, bool isCompact) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            '₹${product.salePrice.toStringAsFixed(1)}',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: isCompact ? 16 : 17,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
