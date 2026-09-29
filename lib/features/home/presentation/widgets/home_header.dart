import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/address_header_widget.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/delivery_type_selector.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_cubit.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/product_state.dart';

/// Home page header using SliverPersistentHeader for full layout control.
/// Collapsed: delivery tabs + categories + gradient strip (pinned).
/// Expanded: logo row + search bar + delivery tabs + categories + gradient strip.
class HomeHeader extends StatefulWidget {
  final DeliveryType selectedDeliveryType;
  final ValueChanged<DeliveryType> onDeliveryTypeChanged;
  final Address? selectedAddress;
  final VoidCallback onAddressTap;

  const HomeHeader({
    super.key,
    required this.selectedDeliveryType,
    required this.onDeliveryTypeChanged,
    this.selectedAddress,
    required this.onAddressTap,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader>
    with SingleTickerProviderStateMixin {
  static const String _homeLogoAssetPath = 'assets/images/image.png';
  static final _log = loggerWithContext({
    'feature': 'home',
    'widget': 'HomeHeader',
  });

  List<Category> _categories = const [];
  bool _isLoading = false;
  late final AnimationController _petalController;
  late final List<_PetalConfig> _petals;

  bool _shouldShowProductCategories(DeliveryType type) {
    return type != DeliveryType.services;
  }

  void _fetchCategoriesForSelectedDeliveryType() {
    context.read<ProductCubit>().fetchCategories(
      deliveryType: _mapApiDeliveryType(widget.selectedDeliveryType),
    );
  }

  @override
  void initState() {
    super.initState();
    if (_shouldShowProductCategories(widget.selectedDeliveryType)) {
      _fetchCategoriesForSelectedDeliveryType();
    }
    _petalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    final random = Random(7);
    _petals = List.generate(26, (index) {
      final size = 6.0 + random.nextDouble() * 6.0;
      return _PetalConfig(
        x: random.nextDouble(),
        size: size,
        speed: 0.6 + random.nextDouble() * 0.8,
        drift: 6 + random.nextDouble() * 10,
        opacity: 0.35 + random.nextDouble() * 0.45,
        color: _petalColors[index % _petalColors.length],
        phase: random.nextDouble() * pi * 2,
      );
    });
  }

  @override
  void didUpdateWidget(covariant HomeHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedDeliveryType != widget.selectedDeliveryType) {
      if (_shouldShowProductCategories(widget.selectedDeliveryType)) {
        _fetchCategoriesForSelectedDeliveryType();
      } else if (_categories.isNotEmpty || _isLoading) {
        setState(() {
          _categories = const [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _petalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final showCategoriesStrip = _shouldShowProductCategories(
      widget.selectedDeliveryType,
    );

    // --- Widget sizes (what you see) ---
    const double logoRowHeight = 48.0;
    const double searchBarHeight = 44.0;
    const double deliverySelectorHeight = 56.0;
    final double categoriesStripHeight = showCategoriesStrip ? 68.0 : 0.0;
    const double gradientStripHeight = 4.0;

    // --- Spacing / padding (gaps around widgets) ---
    const double logoSearchGap = 10.0;
    const double searchDeliveryGap = 6.0;
    const double deliveryPaddingV = 6.0;

    // --- Computed totals (auto-update when you tweak above) ---
    const double deliveryTotalHeight =
        deliverySelectorHeight + (deliveryPaddingV * 2);
    const double collapsibleHeight =
        logoRowHeight + searchBarHeight + logoSearchGap + searchDeliveryGap;
    final double pinnedContentHeight =
        deliveryTotalHeight + categoriesStripHeight + gradientStripHeight;

    final double maxExtent =
        topPadding + collapsibleHeight + pinnedContentHeight;
    final double minExtent = topPadding + pinnedContentHeight;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _HomeHeaderDelegate(
        maxExtent: maxExtent,
        minExtent: minExtent,
        topPadding: topPadding,
        pinnedContentHeight: pinnedContentHeight,
        collapsibleHeight: collapsibleHeight,
        buildContent: (shrinkOffset) {
          // How much of the collapsible area is hidden (0.0 = expanded, 1.0 = collapsed)
          final collapseProgress = (shrinkOffset / collapsibleHeight).clamp(
            0.0,
            1.0,
          );
          final collapsibleOpacity = (1.0 - collapseProgress * 1.5).clamp(
            0.0,
            1.0,
          );

          return Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/orange.jpeg'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.16),
                  blurRadius: 7,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Main content column
                Positioned.fill(
                  child: Column(
                    children: [
                      // Status bar space
                      SizedBox(height: topPadding),

                      // === Collapsible area (fades & shrinks on scroll) ===
                      ClipRect(
                        child: Opacity(
                          opacity: collapsibleOpacity,
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor: (1 - collapseProgress).clamp(
                              0.0,
                              1.0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Logo + Address + Notification row
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: SizedBox(
                                      height: logoRowHeight,
                                      child: Row(
                                        children: [
                                          _buildLogo(),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: AddressHeaderWidget(
                                              selectedAddress:
                                                  widget.selectedAddress,
                                              onTap: widget.onAddressTap,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildNotificationButton(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: logoSearchGap),
                                  // Search bar
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: SizedBox(
                                      height: searchBarHeight,
                                      child: _buildSearchBar(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // === Pinned area (always visible) ===
                      // Delivery Type Selector
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: deliveryPaddingV,
                        ),
                        child: SizedBox(
                          height: deliverySelectorHeight,
                          child: DeliveryTypeSelector(
                            selectedDeliveryType: widget.selectedDeliveryType,
                            onDeliveryTypeChanged: widget.onDeliveryTypeChanged,
                          ),
                        ),
                      ),

                      // Categories horizontal strip
                      if (showCategoriesStrip)
                        SizedBox(
                          height: categoriesStripHeight,
                          child: _buildCategoriesStrip(),
                        ),

                      // Push gradient strip to the very bottom
                      const Spacer(),

                      // Orange → White → Green gradient strip
                      Container(
                        height: gradientStripHeight,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              AppColors.primaryOrangeLight,
                              Colors.white,
                              AppColors.secondaryGreen,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    const double logoHeight = 44.0;
    const double logoWidth = 84.0;

    return SizedBox(
      height: logoHeight,
      width: logoWidth,
      child: Image.asset(
        _homeLogoAssetPath,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Text(
            'Taksh',
            style: TextStyle(
              color: AppColors.secondaryGreen,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: () {
        _log.infoWithContext('Notification button tapped', {
          'action': 'user_action',
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black,
              size: 22,
            ),
            Positioned(
              top: 7,
              right: 8,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _log.infoWithContext('Search bar tapped', {
              'action': 'user_action',
            });
            context.push(AppRoutes.search);
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.primaryOrange,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.searchHint,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.mic_none_rounded,
                    color: AppColors.primaryOrange,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildFallingPetals() {
    return IgnorePointer(
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return AnimatedBuilder(
              animation: _petalController,
              builder: (context, child) {
                final t = _petalController.value;
                return Stack(
                  children: _petals.map((petal) {
                    final y =
                        ((t * height * petal.speed) + (petal.phase * 10)) %
                            (height + petal.size) -
                        petal.size;
                    final x =
                        (petal.x * width) +
                        sin((t * pi * 2) + petal.phase) * petal.drift;

                    return Positioned(
                      left: x,
                      top: y,
                      child: Transform.rotate(
                        angle: (t * pi * 2) + petal.phase,
                        child: _buildFlower(petal),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildFlower(_PetalConfig petal) {
    final size = petal.size + 2;
    final petalSize = size * 0.5;
    final centerSize = size * 0.35;
    final petalColor = petal.color.withOpacity(petal.opacity);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 0, child: _flowerDot(petalSize, petalColor)),
          Positioned(bottom: 0, child: _flowerDot(petalSize, petalColor)),
          Positioned(left: 0, child: _flowerDot(petalSize, petalColor)),
          Positioned(right: 0, child: _flowerDot(petalSize, petalColor)),
          _flowerDot(centerSize, const Color(0xFFFFF3B0)),
        ],
      ),
    );
  }

  Widget _flowerDot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildCategoriesStrip() {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is CategoryLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is CategoryLoaded) {
          setState(() {
            _isLoading = false;
            _categories = state.categories
                .where((category) => category.parentId == null)
                .toList();
          });
        } else if (state is ProductError) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      builder: (context, state) {
        if (_isLoading && _categories.isEmpty) {
          return const SizedBox.shrink();
        }

        if (_categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          itemCount: _categories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            final category = _categories[index];
            return InkWell(
              onTap: () {
                final delivery =
                    widget.selectedDeliveryType == DeliveryType.quick
                    ? 'quick'
                    : widget.selectedDeliveryType == DeliveryType.services
                    ? 'services'
                    : 'standard';
                context.go(
                  AppRoutes.categoriesToCategory(
                    category.id,
                    deliveryType: delivery,
                  ),
                );
                _log.infoWithContext('Category tapped', {
                  'category_id': category.id,
                  'name': category.name,
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCategoryIcon(category),
                    const SizedBox(height: 4),
                    Text(
                      category.name,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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

  Widget _buildCategoryIcon(Category category) {
    const double iconSize = 38.0;
    final iconUrl = category.iconUrl ?? category.imageUrl;

    if (iconUrl == null || iconUrl.isEmpty) {
      return Icon(
        _iconForCategoryName(category.name),
        size: 27,
        color: Colors.white,
      );
    }

    return ClipOval(
      child: SizedBox(
        width: iconSize,
        height: iconSize,
        child: CachedNetworkImage(
          imageUrl: iconUrl,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Icon(
            _iconForCategoryName(category.name),
            size: 23,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  IconData _iconForCategoryName(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('pizza')) return Icons.local_pizza;
    if (lower.contains('fast')) return Icons.fastfood;
    if (lower.contains('burger')) return Icons.lunch_dining;
    if (lower.contains('restaurant') || lower.contains('dining')) {
      return Icons.restaurant;
    }
    if (lower.contains('dessert') || lower.contains('cake')) {
      return Icons.cake;
    }
    if (lower.contains('beverage') || lower.contains('drink')) {
      return Icons.local_cafe;
    }
    if (lower.contains('coffee') || lower.contains('tea')) {
      return Icons.coffee;
    }
    if (lower.contains('breakfast')) return Icons.breakfast_dining;
    if (lower.contains('snack')) return Icons.cookie;
    if (lower.contains('bakery') || lower.contains('bread')) {
      return Icons.bakery_dining;
    }
    if (lower.contains('seafood') || lower.contains('fish')) {
      return Icons.set_meal;
    }
    if (lower.contains('fruit')) return Icons.local_florist;
    if (lower.contains('vegetable') || lower.contains('vegg')) {
      return Icons.spa;
    }
    if (lower.contains('meat') || lower.contains('chicken')) {
      return Icons.set_meal;
    }
    if (lower.contains('grocery')) return Icons.storefront;

    return Icons.category_outlined;
  }
}

/// Custom delegate that gives full control over the header layout at every
/// scroll position — no more fighting with SliverAppBar's internal Column.
class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double _maxExtent;
  final double _minExtent;
  final double topPadding;
  final double pinnedContentHeight;
  final double collapsibleHeight;
  final Widget Function(double shrinkOffset) buildContent;

  _HomeHeaderDelegate({
    required double maxExtent,
    required double minExtent,
    required this.topPadding,
    required this.pinnedContentHeight,
    required this.collapsibleHeight,
    required this.buildContent,
  }) : _maxExtent = maxExtent,
       _minExtent = minExtent;

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return buildContent(shrinkOffset);
  }

  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate oldDelegate) {
    return true;
  }
}

class _PetalConfig {
  final double x;
  final double size;
  final double speed;
  final double drift;
  final double opacity;
  final Color color;
  final double phase;

  const _PetalConfig({
    required this.x,
    required this.size,
    required this.speed,
    required this.drift,
    required this.opacity,
    required this.color,
    required this.phase,
  });
}

const List<Color> _petalColors = [
  Color(0xFFFFB7D5),
  Color(0xFFFFC4A3),
  Color(0xFFFFE29A),
  Color(0xFFC9F2D2),
  Color(0xFFBFE7FF),
];
