import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/cubit/wishlist_state.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Wishlist page – displays all products the user has added to their wishlist.
/// Supports pull-to-refresh and item removal via swipe or icon button.
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(l10n.wishlist),
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: BlocConsumer<WishlistCubit, WishlistState>(
        listener: (context, state) {
          if (state is WishlistOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
          if (state is WishlistError) {
            AppErrorToast.show(context);
          }
        },
        builder: (context, state) {
          // Extract items from any state that carries them
          final items = _extractItems(state);
          final isLoading =
              state is WishlistLoading || state is WishlistInitial;

          if (isLoading && (items == null || items.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          }

          if (items == null || items.isEmpty) {
            return _buildEmptyState(context, l10n);
          }

          return RefreshIndicator(
            onRefresh: () => context.read<WishlistCubit>().fetchWishlist(),
            color: AppColors.primaryOrange,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                final isRemoving =
                    state is RemovingFromWishlist &&
                    state.productId == item.productId;

                return _WishlistItemCard(
                  item: item,
                  isRemoving: isRemoving,
                  onRemove: () => _confirmRemove(context, item),
                  onTap: () =>
                      context.push(AppRoutes.productDetails(item.productId)),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Extract items from any state that carries them.
  List<WishlistItem>? _extractItems(WishlistState state) {
    return switch (state) {
      WishlistLoaded(:final items) => items,
      WishlistOperationSuccess(:final items) => items,
      AddingToWishlist(:final currentItems) => currentItems,
      RemovingFromWishlist(:final currentItems) => currentItems,
      WishlistLoading(:final previousItems) => previousItems,
      _ => null,
    };
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.grey100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 56,
                color: AppColors.grey400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.wishlistEmpty,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.wishlistEmptySubtitle,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.grey600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.home),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: Text(l10n.startShopping),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmRemove(BuildContext context, WishlistItem item) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.removeFromWishlistConfirm,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        content: Text(
          item.productName.isNotEmpty
              ? '${l10n.remove} "${item.productName}"?'
              : l10n.removeFromWishlistConfirm,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<WishlistCubit>().removeProductFromWishlist(
                productId: item.productId,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.remove),
          ),
        ],
      ),
    );
  }
}

// ─── Wishlist Item Card ───────────────────────────────────────────────────────

class _WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  final bool isRemoving;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _WishlistItemCard({
    required this.item,
    required this.isRemoving,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isRemoving ? 0.5 : 1.0,
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey200, width: 1),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                _buildImage(),
                const SizedBox(width: 14),
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName.isNotEmpty
                            ? item.productName
                            : 'Product',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey900,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      _buildPriceRow(),
                      const SizedBox(height: 8),
                      _buildStockBadge(),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Remove button
                _buildRemoveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 90,
        height: 90,
        child: item.productImage != null && item.productImage!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: item.productImage!,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.grey100,
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.grey100,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.grey400,
                    size: 32,
                  ),
                ),
              )
            : Container(
                color: AppColors.grey100,
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.grey400,
                  size: 32,
                ),
              ),
      ),
    );
  }

  Widget _buildPriceRow() {
    if (item.salePrice == null && item.originalPrice == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (item.salePrice != null)
          Text(
            '₹${item.salePrice}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
        if (item.hasDiscount && item.originalPrice != null) ...[
          const SizedBox(width: 8),
          Text(
            '₹${item.originalPrice}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.grey500,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStockBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: item.inStock ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        item.inStock ? 'In Stock' : 'Out of Stock',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: item.inStock
              ? AppColors.secondaryGreen
              : const Color(0xFFE53935),
        ),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return Column(
      children: [
        const SizedBox(height: 4),
        if (isRemoving)
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: Color(0xFFE53935),
                size: 20,
              ),
            ),
          ),
      ],
    );
  }
}
