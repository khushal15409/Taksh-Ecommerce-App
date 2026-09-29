import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taksh_e_commerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_bloc.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_event.dart';
import 'package:taksh_e_commerce/features/address/presentation/bloc/address_state.dart';
import 'package:taksh_e_commerce/features/address/presentation/widgets/address_selection_bottom_sheet.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/dashboard_bloc.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/dashboard_event.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/dashboard_state.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/express_dashboard_bloc.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/express_dashboard_event.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/express_dashboard_state.dart';
import 'package:taksh_e_commerce/features/home/presentation/bloc/recent_views_cubit.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/dashboard_content.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/dashboard_shimmer.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/express_dashboard_content.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/home_header.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/delivery_type_selector.dart';
import 'package:taksh_e_commerce/features/home_service/presentation/widgets/home_service_content.dart';

class HomePage extends StatelessWidget {
  final DeliveryType? initialDeliveryType;

  const HomePage({super.key, this.initialDeliveryType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RecentViewsCubit>(),
      child: _HomePageContent(
        initialDeliveryType: initialDeliveryType ?? DeliveryType.standard,
      ),
    );
  }
}

class _HomePageContent extends StatefulWidget {
  final DeliveryType initialDeliveryType;

  const _HomePageContent({required this.initialDeliveryType});

  @override
  State<_HomePageContent> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePageContent> {
  final _log = loggerWithContext({'feature': 'home', 'page': 'HomePage'});
  static const double _scrollShadeHeightFactor = 0.62;
  static const double _scrollShadeBottomCurve = 44;
  // Extra upward shift applied to the gradient on top of normal scroll speed.
  // Total gradient speed = 1x (scroll) + 0.6x (extra) = 1.6x — feels like
  // the green is rushing up faster than the content sitting on top of it.
  static const double _scrollShadeParallaxFactor = 0.6;
  static const double _defaultLatitude = 23.0695;
  static const double _defaultLongitude = 72.6738;
  static const String _defaultPincode = '382330';
  final ScrollController _scrollController = ScrollController();

  // Tab selection state - default to standard delivery where products are displayed
  DeliveryType _selectedDeliveryType = DeliveryType.standard;
  bool _expressLoaded = false;

  @override
  void initState() {
    super.initState();
    _log.infoWithContext('Home page displayed', {'action': 'init'});
    _ensureAddressesLoaded();
    _selectedDeliveryType = widget.initialDeliveryType;
    _loadDashboard();
    _loadExpressDashboard();
  }

  void _ensureAddressesLoaded() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      return;
    }

    final addressState = context.read<AddressBloc>().state;
    if (addressState is AddressInitial || addressState is AddressError) {
      context.read<AddressBloc>().add(const LoadAddressesEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showAddressSelectionBottomSheet() async {
    // Guest users must log in before selecting an address.
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      context.push('${AppRoutes.login}?redirectAfter=${Uri.encodeComponent(AppRoutes.home)}');
      return;
    }

    _log.infoWithContext('Opening address selection', {
      'action': 'user_action',
    });

    // Get current selected address from bloc
    Address? currentAddress;
    final addressState = context.read<AddressBloc>().state;
    if (addressState is AddressesLoaded) {
      currentAddress = addressState.selectedAddress;
    }

    final selectedAddress = await AddressSelectionBottomSheet.show(
      context,
      currentAddress: currentAddress,
    );

    if (selectedAddress != null && mounted) {
      // Dispatch event to update selected address in bloc
      context.read<AddressBloc>().add(
        SelectAddressForDeliveryEvent(selectedAddress),
      );
      _log.infoWithContext('Address selected', {
        'address_id': selectedAddress.id,
        'address_label': selectedAddress.displayLabel,
      });
    }
  }

  void _loadDashboard() {
    _log.infoWithContext('Loading dashboard', {
      'latitude': _defaultLatitude,
      'longitude': _defaultLongitude,
    });
    context.read<DashboardBloc>().add(
      const DashboardLoadRequested(
        latitude: _defaultLatitude,
        longitude: _defaultLongitude,
      ),
    );
  }

  void _refreshDashboard() {
    _log.infoWithContext('Refreshing dashboard', {
      'latitude': _defaultLatitude,
      'longitude': _defaultLongitude,
    });
    context.read<DashboardBloc>().add(
      const DashboardRefreshRequested(
        latitude: _defaultLatitude,
        longitude: _defaultLongitude,
      ),
    );
  }

  void _loadExpressDashboard() {
    _log.infoWithContext('Loading express dashboard', {
      'latitude': _defaultLatitude,
      'longitude': _defaultLongitude,
      'pincode': _defaultPincode,
    });
    context.read<ExpressDashboardBloc>().add(
      const ExpressDashboardLoadRequested(
        latitude: _defaultLatitude,
        longitude: _defaultLongitude,
        pincode: _defaultPincode,
      ),
    );
    _expressLoaded = true;
  }

  void _refreshExpressDashboard() {
    _log.infoWithContext('Refreshing express dashboard', {
      'latitude': _defaultLatitude,
      'longitude': _defaultLongitude,
      'pincode': _defaultPincode,
    });
    context.read<ExpressDashboardBloc>().add(
      const ExpressDashboardRefreshRequested(
        latitude: _defaultLatitude,
        longitude: _defaultLongitude,
        pincode: _defaultPincode,
      ),
    );
  }

  Future<void> _onDeliveryTypeChanged(DeliveryType type) async {
    if (type == DeliveryType.quick) {
      // Guest users must log in before using quick delivery.
      final authState = context.read<AuthBloc>().state;
      if (authState is! Authenticated) {
        context.push('${AppRoutes.login}?redirectAfter=${Uri.encodeComponent(AppRoutes.home)}');
        return;
      }

      // Get current selected address from bloc
      Address? currentAddress;
      final addressState = context.read<AddressBloc>().state;
      if (addressState is AddressesLoaded) {
        currentAddress = addressState.selectedAddress;
      }

      // Always show the address selection popup for quick delivery,
      // even if an address is already saved.
      final selectedAddress = await AddressSelectionBottomSheet.show(
        context,
        currentAddress: currentAddress,
      );

      if (selectedAddress == null) {
        return;
      }

      if (!mounted) return;
      // Dispatch event to update selected address in bloc
      context.read<AddressBloc>().add(
        SelectAddressForDeliveryEvent(selectedAddress),
      );
    }

    setState(() {
      _selectedDeliveryType = type;
    });

    if (type == DeliveryType.quick && !_expressLoaded) {
      _loadExpressDashboard();
    }
  }

  Future<void> _handleRefresh() async {
    switch (_selectedDeliveryType) {
      case DeliveryType.standard:
        _refreshDashboard();
        break;
      case DeliveryType.quick:
        _refreshExpressDashboard();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) => current is Authenticated,
          listener: (context, state) {
            _ensureAddressesLoaded();
          },
        ),
        BlocListener<AddressBloc, AddressState>(
          listener: (context, state) {
            // The selected delivery address is maintained in AddressBloc.
          },
        ),
      ],
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, dashboardState) {
          // Get selected address from AddressBloc
          Address? selectedAddress;
          final addressState = context.watch<AddressBloc>().state;
          if (addressState is AddressesLoaded) {
            selectedAddress = addressState.selectedAddress;
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: RefreshIndicator(
              onRefresh: _handleRefresh,
              edgeOffset: 120, // Push refresh indicator below header slightly
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // The Header is now part of the scroll view
                  HomeHeader(
                    selectedDeliveryType: _selectedDeliveryType,
                    onDeliveryTypeChanged: _onDeliveryTypeChanged,
                    selectedAddress: selectedAddress,
                    onAddressTap: _showAddressSelectionBottomSheet,
                  ),
                  // The Content wrapper with rounded corners background
                  SliverToBoxAdapter(child: _buildScrollableBody()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScrollableBody() {
    final screenHeight = MediaQuery.of(context).size.height;
    final shadeHeight = screenHeight * _scrollShadeHeightFactor;
    final minBodyHeight = screenHeight * 0.7;

    return Stack(
      children: [
        // ── Gradient background (parallax layer) ──────────────────────────
        // Moves upward faster than normal scroll speed.
        // Since this widget is already inside the CustomScrollView it moves
        // at 1x by default. AnimatedBuilder adds an EXTRA upward offset
        // (_scrollShadeParallaxFactor × scrollOffset) so the total speed is
        // (1 + _scrollShadeParallaxFactor)x — the green rushes up faster.
        AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            // Guard: .offset asserts exactly 1 attached position – during
            // BlocBuilder/tab rebuilds there can briefly be 2 or 0.
            final scrollOffset =
                _scrollController.hasClients &&
                    _scrollController.positions.length == 1
                ? _scrollController.positions.first.pixels
                : 0.0;
            final extraShift = (scrollOffset * _scrollShadeParallaxFactor)
                .clamp(0.0, shadeHeight);
            return Transform.translate(
              offset: Offset(0, -extraShift),
              child: child,
            );
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(_scrollShadeBottomCurve),
                  bottomRight: Radius.circular(_scrollShadeBottomCurve),
                ),
                child: _buildWhiteGreenBodyGradient(shadeHeight),
              ),
              Container(
                constraints: BoxConstraints(minHeight: minBodyHeight),
                color: Colors.white,
              ),
            ],
          ),
        ),

        // ── Content (normal scroll speed) ─────────────────────────────────
        _buildContent(),
      ],
    );
  }

  Widget _buildWhiteGreenBodyGradient(double height) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.asset(
        'assets/images/green.jpeg',
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedDeliveryType) {
      case DeliveryType.standard:
        return Column(
          children: [
            // Standard delivery badge with green gradient
            Container(
              margin: const EdgeInsets.fromLTRB(16, 4, 16, 2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: IndiaGradients.greenGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryGreen.withOpacity(0.42),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_shipping,
                      color: AppColors.secondaryGreen,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'Standard Delivery - Shop Your Favorites!',
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return const DashboardShimmer();
                }

                if (state is DashboardError) {
                  return _buildErrorState(state.message);
                }

                if (state is DashboardLoaded || state is DashboardRefreshing) {
                  final dashboard = state is DashboardLoaded
                      ? state.dashboard
                      : (state as DashboardRefreshing).dashboard;

                  return DashboardContent(dashboard: dashboard);
                }

                return const DashboardShimmer();
              },
            ),
          ],
        );
      case DeliveryType.quick:
        return Column(
          children: [
            // Quick delivery badge with orange gradient
            Container(
              margin: const EdgeInsets.fromLTRB(16, 4, 16, 2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: IndiaGradients.saffronGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bolt,
                      color: AppColors.primaryOrange,
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Flexible(
                    child: Text(
                      'Quick Delivery - Express 30',
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<ExpressDashboardBloc, ExpressDashboardState>(
              builder: (context, state) {
                if (state is ExpressDashboardLoading) {
                  return const DashboardShimmer();
                }

                if (state is ExpressDashboardError) {
                  return _buildErrorState(state.message);
                }

                if (state is ExpressDashboardLoaded ||
                    state is ExpressDashboardRefreshing) {
                  final dashboard = state is ExpressDashboardLoaded
                      ? state.dashboard
                      : (state as ExpressDashboardRefreshing).dashboard;

                  return ExpressDashboardContent(
                    dashboard: dashboard,
                    latitude: _defaultLatitude,
                    longitude: _defaultLongitude,
                    onProductTap: (product) {
                      context.push(
                        AppRoutes.productDetails(product.id),
                        extra: {
                          'inStock': product.inStock,
                          'outOfStockMessage': product.outOfStockMessage,
                        },
                      );
                    },
                  );
                }

                return const DashboardShimmer();
              },
            ),
          ],
        );
      case DeliveryType.services:
        return const HomeServiceContent();
    }
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                gradient: IndiaGradients.saffronGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _loadDashboard,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Try Again',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
