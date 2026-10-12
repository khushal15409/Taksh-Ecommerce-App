import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/widgets/taksh_ui.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_bloc.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_event.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_state.dart';
import 'package:taksh_e_commerce/features/address/presentation/widgets/address_selection_bottom_sheet.dart';
import 'package:taksh_e_commerce/features/categories/presentation/widgets/category_chip_strip.dart';
import 'package:taksh_e_commerce/features/categories/presentation/widgets/widgets.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/delivery_type_selector.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_cubit.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_state.dart';

/// Categories page - displays categories on left, subcategories and products on right
class CategoriesPage extends StatefulWidget {
  final int? initialCategoryId;
  final int? initialSubcategoryId;
  final DeliveryType? initialDeliveryType;

  const CategoriesPage({
    super.key,
    this.initialCategoryId,
    this.initialSubcategoryId,
    this.initialDeliveryType,
  });

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> _categories = [];
  int _selectedIndex = 0;
  Category? _selectedSubcategory;
  DeliveryType _homeDeliveryType = DeliveryType.standard;
  Address? _selectedAddress;
  bool _hasLoadedInitialProducts = false;
  // Identity (address + coordinates) of the last Express request, so a new
  // selection triggers exactly one reload and an unchanged one none.
  String? _expressProductsKey;

  bool get _isQuickDelivery => _homeDeliveryType == DeliveryType.quick;

  /// Express-30 needs the selected address's real position; there is no
  /// fallback to a fixed city.
  bool get _hasUsableLocation =>
      _selectedAddress?.location.hasValidCoordinates ?? false;

  String? _expressKey() {
    final address = _selectedAddress;
    if (address == null || !address.location.hasValidCoordinates) return null;
    return '${address.id}|${address.location.latitude}|'
        '${address.location.longitude}';
  }

  Address? _addressFromBloc() {
    final state = context.read<AddressBloc>().state;
    return state is AddressesLoaded ? state.selectedAddress : null;
  }

  /// Reloads Express products when the selected address changed since the
  /// last request. No-op for standard delivery or before categories load.
  void _reloadExpressIfAddressChanged() {
    if (!_isQuickDelivery || _categories.isEmpty) return;
    if (_expressKey() == _expressProductsKey) return;
    _fetchProductsForCategory(_categories[_selectedIndex].id);
  }

  @override
  void initState() {
    super.initState();
    _homeDeliveryType = widget.initialDeliveryType ?? DeliveryType.standard;
    _selectedAddress = _addressFromBloc();
    context.read<ProductCubit>().fetchCategories(
      deliveryType: _mapApiDeliveryType(_homeDeliveryType),
    );
  }

  void _fetchProductsForCategory(int categoryId) {
    if (_isQuickDelivery) {
      _expressProductsKey = _expressKey();
      final location = _selectedAddress?.location;
      if (location == null || !location.hasValidCoordinates) {
        // No usable location: do not request products for another place.
        // The grid shows a "choose a location" state instead.
        setState(() {});
        return;
      }
      context.read<ProductCubit>().fetchExpressProducts(
        categoryId: categoryId,
        latitude: location.latitude,
        longitude: location.longitude,
      );
    } else {
      context.read<ProductCubit>().fetchProducts(
        categoryId: categoryId,
        page: 1,
        limit: AppConstants.defaultPageSize,
      );
    }
  }

  void _selectCategory(int index) {
    if (_selectedIndex == index && _hasLoadedInitialProducts) return;
    _hasLoadedInitialProducts = true;

    setState(() {
      _selectedIndex = index;
      _selectedSubcategory = null;
    });

    final category = _categories[index];

    // Debug logging
    print('🏷️ Selected category: ${category.name} (id: ${category.id})');
    print('🏷️ Has children: ${category.hasChildren}');
    print('🏷️ Children count: ${category.children?.length ?? 0}');

    // Auto-select first subcategory if available
    if (category.hasChildren && category.children!.isNotEmpty) {
      setState(() {
        _selectedSubcategory = category.children!.first;
      });

      // Debug logging
      print(
        '🏷️ Auto-selected subcategory: ${_selectedSubcategory!.name} (id: ${_selectedSubcategory!.id})',
      );
      print(
        '🏷️ Fetching products for PARENT category: ${category.name} (id: ${category.id})',
      );

      // Fetch products for the PARENT category (products are assigned to parent categories in backend)
      _fetchProductsForCategory(category.id);
    } else {
      // Debug logging
      print(
        '🏷️ No subcategories, fetching products for category: ${category.name} (id: ${category.id})',
      );

      // Fetch products for this category if no subcategories
      _fetchProductsForCategory(category.id);
    }
  }

  void _handleSubcategoryChanged(Category? subcategory) {
    if (subcategory != null && _selectedSubcategory?.id != subcategory.id) {
      setState(() => _selectedSubcategory = subcategory);

      // Get the parent category
      final parentCategory = _categories[_selectedIndex];

      // Debug logging
      print(
        '🏷️ Subcategory changed to: ${subcategory.name} (id: ${subcategory.id})',
      );
      print(
        '🏷️ Fetching products for PARENT category: ${parentCategory.name} (id: ${parentCategory.id})',
      );

      // Fetch products for the PARENT category (products are assigned to parent categories in backend)
      _fetchProductsForCategory(parentCategory.id);
    }
  }

  void _retryFetchCategories() {
    context.read<ProductCubit>().fetchCategories(
      deliveryType: _mapApiDeliveryType(_homeDeliveryType),
    );
  }

  void _retryFetchProducts() {
    _fetchProductsForCategory(_categories[_selectedIndex].id);
  }

  void _navigateToHome() {
    context.go(AppRoutes.homeWithDelivery('services'));
  }

  String _mapApiDeliveryType(DeliveryType type) {
    switch (type) {
      case DeliveryType.quick:
        return 'express_30';
      case DeliveryType.standard:
      case DeliveryType.services:
        return 'standard_delivery';
    }
  }

  Future<void> _handleDeliveryTypeSelection(DeliveryType type) async {
    if (type == DeliveryType.services) {
      setState(() => _homeDeliveryType = type);
      _navigateToHome();
      return;
    }

    if (type == DeliveryType.quick) {
      // Guest users must log in before using quick delivery.
      final authState = context.read<AuthBloc>().state;
      if (authState is! Authenticated) {
        context.push(
          '${AppRoutes.login}?redirectAfter=${Uri.encodeComponent(AppRoutes.categories)}',
        );
        return;
      }

      // Always show the address selection popup for quick delivery,
      // even if an address is already saved.
      final selectedAddress = await AddressSelectionBottomSheet.show(
        context,
        currentAddress: _selectedAddress,
      );

      if (selectedAddress == null) {
        return;
      }

      if (!mounted) return;
      setState(() {
        _selectedAddress = selectedAddress;
      });
      // Keep the app-wide selected address (used by the home screen) in sync.
      context.read<AddressBloc>().add(
        SelectAddressForDeliveryEvent(selectedAddress),
      );
    }

    if (_homeDeliveryType == type && _categories.isNotEmpty) {
      // Already on this tab: only an address change needs a reload.
      _reloadExpressIfAddressChanged();
      return;
    }

    setState(() {
      _homeDeliveryType = type;
      _categories = [];
      _selectedIndex = 0;
      _selectedSubcategory = null;
      _hasLoadedInitialProducts = false;
      _expressProductsKey = null;
    });

    context.read<ProductCubit>().fetchCategories(
      deliveryType: _mapApiDeliveryType(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = TakshArt.forCategory(
      _categories.isEmpty ? null : _categories[_selectedIndex].name,
      seed: _categories.isEmpty ? null : _categories[_selectedIndex].id,
    );

    return TakshSoftBackground(
      art: style.art,
      accent: style.accent,
      artHeight: 170,
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 16,
        automaticallyImplyLeading: false,
        title: _buildHeading(),
        actions: [
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.white),
            tooltip: AppLocalizations.of(context)!.searchForProducts,
            onPressed: () => context.push(AppRoutes.search),
            icon: const Icon(Icons.search_rounded),
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: _buildModeSelector(),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: BlocListener<AddressBloc, AddressState>(
        // Selected address changed elsewhere (e.g. on the home screen).
        listenWhen: (previous, current) => current is AddressesLoaded,
        listener: (context, state) {
          final selected = (state as AddressesLoaded).selectedAddress;
          if (selected == null) return;
          setState(() => _selectedAddress = selected);
          _reloadExpressIfAddressChanged();
        },
        child: BlocConsumer<ProductCubit, ProductState>(
        listener: _handleStateChange,
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductError && _categories.isEmpty) {
            return ErrorView(
              message: state.message,
              onRetry: _retryFetchCategories,
            );
          }

          if (_categories.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noCategoriesAvailable),
            );
          }

          return Column(
            children: [
              CategoryChipStrip(
                categories: _categories,
                selectedIndex: _selectedIndex,
                onCategorySelected: _selectCategory,
              ),
              Expanded(child: _buildProductsPanel(state)),
            ],
          );
        },
        ),
      ),
      ),
    );
  }

  Widget _buildHeading() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        final name = _categories.isEmpty
            ? AppLocalizations.of(context)!.categoriesTab
            : _categories[_selectedIndex].name;
        final total = state is ProductListLoaded
            ? state.paginatedProducts.total
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            if (total != null)
              Text(
                '$total products',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildModeSelector() {
    return Container(
          width: double.infinity,
          height: 52,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: takshSoftShadow,
          ),
          child: SegmentedButton<DeliveryType>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: DeliveryType.standard,
                label: Text(AppLocalizations.of(context)!.standard),
              ),
              ButtonSegment(
                value: DeliveryType.quick,
                label: Text(AppLocalizations.of(context)!.quick),
              ),
              ButtonSegment(
                value: DeliveryType.services,
                label: Text(AppLocalizations.of(context)!.services),
              ),
            ],
            selected: {_homeDeliveryType},
            onSelectionChanged: (selection) {
              final type = selection.first;
              _handleDeliveryTypeSelection(type);
            },
            style: ButtonStyle(
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryOrange;
                }
                return Colors.transparent;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.7);
              }),
              overlayColor: WidgetStatePropertyAll(
                AppColors.primaryOrange.withOpacity(0.08),
              ),
              textStyle: const WidgetStatePropertyAll(
                TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              side: const WidgetStatePropertyAll(BorderSide.none),
            ),
          ),
        );
  }

  void _handleStateChange(BuildContext context, ProductState state) {
    if (state is CategoryLoaded) {
      final categories = state.categories
          .where((cat) => cat.parentId == null)
          .toList();

      // Debug logging
      print('🏷️ Categories loaded: ${categories.length} parent categories');
      for (var cat in categories) {
        print(
          '🏷️   - ${cat.name} (id: ${cat.id}, children: ${cat.children?.length ?? 0})',
        );
      }

      if (categories.isNotEmpty && _categories.isEmpty) {
        setState(() => _categories = categories);

        // Auto-select category/subcategory if provided
        if (widget.initialSubcategoryId != null) {
          final subcategoryMatch = _findParentForSubcategory(
            categories,
            widget.initialSubcategoryId!,
          );

          if (subcategoryMatch != null) {
            _selectCategory(subcategoryMatch.parentIndex);
            setState(() => _selectedSubcategory = subcategoryMatch.subcategory);
            return;
          }
        }

        if (widget.initialCategoryId != null) {
          final index = categories.indexWhere(
            (cat) => cat.id == widget.initialCategoryId,
          );
          _selectCategory(index >= 0 ? index : 0);
        } else {
          _selectCategory(0);
        }
      }
    }
  }

  _SubcategoryMatch? _findParentForSubcategory(
    List<Category> categories,
    int subcategoryId,
  ) {
    for (var i = 0; i < categories.length; i++) {
      final category = categories[i];
      if (category.children == null || category.children!.isEmpty) continue;

      for (final child in category.children!) {
        if (child.id == subcategoryId) {
          return _SubcategoryMatch(parentIndex: i, subcategory: child);
        }
      }
    }

    return null;
  }

  Widget _buildProductsPanel(ProductState state) {
    final selectedCategory = _categories[_selectedIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedCategory.hasChildren) ...[
          SubcategoriesSection(
            category: selectedCategory,
            selectedSubcategory: _selectedSubcategory,
            onSubcategoryChanged: _handleSubcategoryChanged,
          ),
          const SizedBox(height: 4),
        ],
        Expanded(child: _buildProductsGrid(state)),
      ],
    );
  }

  Widget _buildExpressInfo({
    required IconData icon,
    required String title,
    required String message,
    required String actionLabel,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _handleDeliveryTypeSelection(DeliveryType.quick),
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid(ProductState state) {
    if (_isQuickDelivery && !_hasUsableLocation) {
      return _buildExpressInfo(
        icon: Icons.location_off_outlined,
        title: 'Select a delivery location',
        message:
            'Choose a saved address with a map location to see 30-minute '
            'delivery products near you.',
        actionLabel: 'Choose address',
      );
    }

    if (_isQuickDelivery && state is ExpressProductsUnavailable) {
      return _buildExpressInfo(
        icon: Icons.bolt_outlined,
        title: '30-minute delivery is not available here',
        message:
            'No nearby store delivers in 30 minutes to this address. Try '
            'another address or use standard delivery.',
        actionLabel: 'Change address',
      );
    }

    if (state is ProductListLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProductError && _categories.isNotEmpty) {
      return ErrorView(message: state.message, onRetry: _retryFetchProducts);
    }

    if (state is! ProductListLoaded ||
        state.paginatedProducts.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/illustrations/grocery_basket.svg', height: 110),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.noProductsFound),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrowWidth = constraints.maxWidth < 300;
        final crossAxisCount = constraints.maxWidth >= 760
            ? 3
            : constraints.maxWidth >= 250
            ? 2
            : 1;
        final mainAxisExtent = _homeDeliveryType == DeliveryType.quick
            ? (crossAxisCount == 1
                  ? 292.0
                  : crossAxisCount == 2
                  ? 268.0
                  : 254.0)
            : (crossAxisCount == 1
                  ? 264.0
                  : crossAxisCount == 2
                  ? 244.0
                  : 232.0);

        return GridView.builder(
          padding: EdgeInsets.fromLTRB(
            isNarrowWidth ? 8 : 16,
            8,
            isNarrowWidth ? 8 : 16,
            16,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: mainAxisExtent,
            crossAxisSpacing: isNarrowWidth ? 8 : 12,
            mainAxisSpacing: isNarrowWidth ? 8 : 12,
          ),
          itemCount: state.paginatedProducts.products.length,
          itemBuilder: (context, index) => CategoryProductCard(
            product: state.paginatedProducts.products[index],
            showDeliveryTime: _homeDeliveryType == DeliveryType.quick,
          ),
        );
      },
    );
  }
}

class _SubcategoryMatch {
  final int parentIndex;
  final Category subcategory;

  const _SubcategoryMatch({
    required this.parentIndex,
    required this.subcategory,
  });
}
