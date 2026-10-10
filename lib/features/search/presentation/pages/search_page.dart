import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/theme/app_spacing.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/recent_search.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/search_product.dart';
import 'package:taksh_e_commerce/features/search/presentation/cubit/search_cubit.dart';
import 'package:taksh_e_commerce/features/search/presentation/cubit/search_state.dart';
import 'package:taksh_e_commerce/core/widgets/taksh_ui.dart';

/// Search page for ecommerce products
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      context.read<SearchCubit>().loadRecentSearches();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDebounceTime, () {
      context.read<SearchCubit>().search(query);
    });
  }

  void _onClear() {
    _controller.clear();
    context.read<SearchCubit>().clear();
    setState(() {});
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TakshSoftBackground(
      art: TakshArt.home,
      artHeight: 210,
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(AppLocalizations.of(context)!.search),
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingMD),
            child: _buildSearchInput(),
          ),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchRecentLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is SearchInitial) {
                  // Show recent searches if available
                  if (state.recentSearches != null &&
                      state.recentSearches!.isNotEmpty) {
                    return _buildRecentSearches(state.recentSearches!);
                  }

                  return _buildEmptyState(
                    icon: Icons.search_rounded,
                    title: AppLocalizations.of(context)!.searchForProductsHint, // Reusing existing or add new
                    subtitle:
                        AppLocalizations.of(context)!.typeMinCharsToSearch(AppConstants.minSearchLength),
                  );
                }

                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is SearchError) {
                  return _buildEmptyState(
                    icon: Icons.error_outline,
                    title: AppLocalizations.of(context)!.somethingWentWrong,
                    subtitle: state.message,
                  );
                }

                if (state is SearchLoaded) {
                  if (state.results.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: AppLocalizations.of(context)!.noResultsFound,
                      subtitle:
                          AppLocalizations.of(context)!.tryAdjustingFilters, // Reusing or add new
                    );
                  }

                  return _buildResults(state.results);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        onChanged: _onQueryChanged,
        onSubmitted: (value) => context.read<SearchCubit>().search(value),
        decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchForProducts,
          hintStyle: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 14),
          prefixIcon: Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryOrange, AppColors.primaryOrangeLight],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.search, color: Theme.of(context).colorScheme.onPrimary, size: 18),
          ),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: _onClear,
                ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildResults(List<SearchProduct> results) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingMD),
      itemCount: results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = results[index];
        return _SearchResultCard(
          product: product,
          onTap: () => context.push(
            AppRoutes.productDetails(product.id),
            extra: ProductDetailsExtra(inStock: product.inStock),
          ),
        );
      },
    );
  }

  Widget _buildRecentSearches(List<RecentSearch> searches) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.paddingMD,
              AppSpacing.paddingSM,
              AppSpacing.paddingMD,
              AppSpacing.paddingXS,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  size: 18,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.recentSearches,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.paddingMD,
                AppSpacing.paddingXS,
                AppSpacing.paddingMD,
                AppSpacing.paddingMD,
              ),
              itemCount: searches.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final search = searches[index];
                return _RecentSearchItem(
                  searchTerm: search.searchTerm,
                  onTap: () {
                    _controller.text = search.searchTerm;
                    context.read<SearchCubit>().search(search.searchTerm);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryOrange, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final SearchProduct product;
  final VoidCallback onTap;

  const _SearchResultCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildImage(theme),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfo(context, theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme) {
    if (product.imageUrl == null || product.imageUrl!.isEmpty) {
      return Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.image_not_supported, size: 30),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: product.imageUrl!,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 72,
          height: 72,
          color: theme.colorScheme.surfaceContainerHighest,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 72,
          height: 72,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.broken_image, size: 28),
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context, ThemeData theme) {
    final price = '${AppConstants.currencySymbol}${product.price}';
    final mrp = product.mrp != null
        ? '${AppConstants.currencySymbol}${product.mrp}'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 4),
        if (product.brand != null && product.brand!.isNotEmpty)
          Text(
            product.brand!,
            style: TextStyle(
              fontSize: 12,
              color: theme.textTheme.bodySmall?.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              price,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryOrange,
              ),
            ),
            if (product.hasDiscount && mrp != null) ...[
              const SizedBox(width: 8),
              Text(
                mrp,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.bodySmall?.color,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
            const Spacer(),
            _buildStockChip(context),
          ],
        ),
      ],
    );
  }

  Widget _buildStockChip(BuildContext context) {
    final isInStock = product.inStock;
    final color = isInStock ? AppColors.inStock : AppColors.outOfStock;
    final label = isInStock ? AppLocalizations.of(context)!.inStock : AppLocalizations.of(context)!.outOfStock;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// Widget for displaying a recent search item
class _RecentSearchItem extends StatelessWidget {
  final String searchTerm;
  final VoidCallback onTap;

  const _RecentSearchItem({
    required this.searchTerm,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  size: 16,
                  color: AppColors.primaryOrange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  searchTerm,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.north_west,
                size: 16,
                color: Theme.of(context).disabledColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
