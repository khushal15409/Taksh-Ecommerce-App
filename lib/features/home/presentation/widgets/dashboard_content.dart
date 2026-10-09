import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/home/data/models/dashboard_section_model.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/recent_views_cubit.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/recent_views_state.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/banner_carousel.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/category_catalog_section.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/product_section.dart';
import 'package:taksh_e_commerce/features/home/presentation/pages/view_all_products_page.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/recent_views_section.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';

/// Dashboard content widget displaying banners and product sections
class DashboardContent extends StatefulWidget {
  final dynamic dashboard;

  /// Optional widget (category shortcuts) shown right below the banners.
  final Widget? categoryStrip;

  const DashboardContent({
    super.key,
    required this.dashboard,
    this.categoryStrip,
  });

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  static final _log =
      loggerWithContext({'feature': 'home', 'widget': 'DashboardContent'});

  @override
  void initState() {
    super.initState();
    // Load recent views when dashboard is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecentViewsCubit>().loadRecentViews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sections = widget.dashboard.sections as List<dynamic>;
    final bannerWidgets = <Widget>[];
    final productWidgets = <Widget>[];
    List<Category>? categoryData;

    for (final item in sections) {
      final section = item as DashboardSectionModel;

      if (section.key == 'Logo') continue;

      if (section.key == 'Banners') {
        bannerWidgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 10),
            child: BannerCarousel(
              banners: section.banners,
              onBannerTap: (banner) {
                _log.infoWithContext(
                  'Banner tapped',
                  {'banner_id': banner.id, 'title': banner.title},
                );
                // TODO: Handle banner tap navigation
              },
            ),
          ),
        );
        continue;
      }

      if (section.key == 'Categories') {
        categoryData = section.categories;
        continue;
      }

      if (section.hasData) {
        productWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ProductSection(
              section: section,
              showDeliveryTime: false,
              onProductTap: (product) {
                _log.infoWithContext(
                  'Product tapped',
                  {'product_id': product.id, 'name': product.name},
                );
                context.push(
                  AppRoutes.productDetails(product.id),
                  extra: {
                    'inStock': product.inStock,
                    'outOfStockMessage': product.outOfStockMessage,
                  },
                );
              },
              onViewAllTap: () {
                _log.infoWithContext(
                  'View all tapped',
                  {'section': section.key},
                );
                context.push(
                  AppRoutes.viewAllProducts,
                  extra: ViewAllProductsArgs(
                    title: section.key,
                    products: section.products,
                  ),
                );
              },
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...bannerWidgets,
        if (widget.categoryStrip != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: widget.categoryStrip,
          ),
        // Recent Views Section (moved near top, below banners)
        BlocBuilder<RecentViewsCubit, RecentViewsState>(
          builder: (context, state) {
            if (state is RecentViewsLoaded && state.recentViews.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RecentViewsSection(
                  recentViews: state.recentViews,
                  onProductTap: (productId) {
                    _log.infoWithContext(
                      'Recent view tapped',
                      {'product_id': productId},
                    );
                    context.push(AppRoutes.productDetails(productId));
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        ...productWidgets,
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CategoryCatalogSection(
            categories: categoryData,
            deliveryType: 'standard',
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
