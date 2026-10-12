import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/widgets/taksh_ui.dart';
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
import 'package:taksh_e_commerce/features/home/presentation/widgets/home_category_strip.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/home_header.dart';
import 'package:taksh_e_commerce/features/home/presentation/widgets/quick_delivery_promo_banner.dart';
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
  static const double _defaultLatitude = 23.0695;
  static const double _defaultLongitude = 72.6738;
  final ScrollController _scrollController = ScrollController();

  // Tab selection state - default to standard delivery where products are displayed
  DeliveryType _selectedDeliveryType = DeliveryType.standard;
  // Identity of the address the Express dashboard was last requested for, so
  // a change of the selected address (or its coordinates/pincode) is detected.
  String? _expressRequestKey;

  @override
  void initState() {
    super.initState();
    _log.infoWithContext('Home page displayed', {'action': 'init'});
    _ensureAddressesLoaded();
    _selectedDeliveryType = widget.initialDeliveryType;
    _loadDashboard();
    if (_selectedDeliveryType == DeliveryType.quick) {
      // Addresses may already be loaded; otherwise the AddressBloc listener
      // triggers the load once they arrive.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _syncExpressDashboard();
      });
    }
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

  Address? _currentSelectedAddress() {
    final addressState = context.read<AddressBloc>().state;
    return addressState is AddressesLoaded ? addressState.selectedAddress : null;
  }

  /// Express-30 needs a real position and a pincode of the selected address.
  /// There is deliberately no fallback to a fixed city.
  bool _hasUsableLocation(Address? address) {
    if (address == null) return false;
    final location = address.location;
    return location.hasValidCoordinates &&
        (location.postalCode?.trim().isNotEmpty ?? false);
  }

  String _expressKeyFor(Address address) {
    final location = address.location;
    return '${address.id}|${location.latitude}|${location.longitude}|'
        '${location.postalCode?.trim()}';
  }

  /// Loads the Express dashboard for the selected address when it differs
  /// from the one last requested. Does nothing without a usable location.
  void _syncExpressDashboard({bool force = false, Address? selected}) {
    // [selected] is passed right after the user picks an address, before the
    // AddressBloc has processed the selection event.
    final address = selected ?? _currentSelectedAddress();
    if (!_hasUsableLocation(address)) {
      _expressRequestKey = null;
      return;
    }
    final key = _expressKeyFor(address!);
    if (!force && key == _expressRequestKey) return;
    _expressRequestKey = key;

    final location = address.location;
    _log.infoWithContext('Loading express dashboard', {
      'address_id': address.id,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'pincode': location.postalCode,
    });
    context.read<ExpressDashboardBloc>().add(
      ExpressDashboardLoadRequested(
        latitude: location.latitude,
        longitude: location.longitude,
        pincode: location.postalCode!.trim(),
      ),
    );
  }

  void _refreshExpressDashboard() {
    final address = _currentSelectedAddress();
    if (!_hasUsableLocation(address)) return;
    final location = address!.location;
    _expressRequestKey = _expressKeyFor(address);
    _log.infoWithContext('Refreshing express dashboard', {
      'address_id': address.id,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'pincode': location.postalCode,
    });
    context.read<ExpressDashboardBloc>().add(
      ExpressDashboardRefreshRequested(
        latitude: location.latitude,
        longitude: location.longitude,
        pincode: location.postalCode!.trim(),
      ),
    );
  }

  Future<void> _onDeliveryTypeChanged(DeliveryType type) async {
    Address? chosenAddress;
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
      chosenAddress = selectedAddress;
      // Dispatch event to update selected address in bloc
      context.read<AddressBloc>().add(
        SelectAddressForDeliveryEvent(selectedAddress),
      );
    }

    setState(() {
      _selectedDeliveryType = type;
    });

    if (type == DeliveryType.quick) {
      _syncExpressDashboard(selected: chosenAddress);
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
          // The selected delivery address is maintained in AddressBloc. When
          // it (or its coordinates/pincode) changes, reload Express data.
          listenWhen: (previous, current) =>
              current is AddressesLoaded &&
              (previous is! AddressesLoaded ||
                  previous.selectedAddress?.id != current.selectedAddress?.id ||
                  previous.selectedAddress?.location !=
                      current.selectedAddress?.location),
          listener: (context, state) {
            if (_selectedDeliveryType == DeliveryType.quick) {
              _syncExpressDashboard();
            }
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

          return TakshSoftBackground(
            art: _selectedDeliveryType == DeliveryType.services
                ? TakshArt.services
                : TakshArt.home,
            // Services: the house sits beside the "Home Services" heading,
            // just below the header block.
            artTop: _selectedDeliveryType == DeliveryType.services ? 150 : 0,
            artHeight:
                _selectedDeliveryType == DeliveryType.services ? 230 : 340,
            child: Scaffold(
            backgroundColor: Colors.transparent,
            body: RefreshIndicator(
              onRefresh: _handleRefresh,
              edgeOffset: 80,
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildScrollableBody() {
    final minBodyHeight = MediaQuery.of(context).size.height * 0.7;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minBodyHeight),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (_selectedDeliveryType) {
      case DeliveryType.standard:
        return Column(
          children: [
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

                  return DashboardContent(
                    dashboard: dashboard,
                    categoryStrip: const HomeCategoryStrip(
                      deliveryType: DeliveryType.standard,
                    ),
                    promoBanner: QuickDeliveryPromoBanner(
                      onTap: () => _onDeliveryTypeChanged(DeliveryType.quick),
                    ),
                  );
                }

                return const DashboardShimmer();
              },
            ),
          ],
        );
      case DeliveryType.quick:
        return Column(
          children: [
            if (!_hasUsableLocation(_currentSelectedAddress()))
              _buildLocationRequiredState()
            else
            BlocBuilder<ExpressDashboardBloc, ExpressDashboardState>(
              builder: (context, state) {
                if (state is ExpressDashboardLoading) {
                  return const DashboardShimmer();
                }

                if (state is ExpressDashboardError) {
                  return _buildErrorState(
                    state.message,
                    onRetry: () => _syncExpressDashboard(force: true),
                  );
                }

                if (state is ExpressDashboardLoaded ||
                    state is ExpressDashboardRefreshing) {
                  final dashboard = state is ExpressDashboardLoaded
                      ? state.dashboard
                      : (state as ExpressDashboardRefreshing).dashboard;

                  // The backend answers 200 with no sections when no vendor
                  // delivers to this address.
                  if (dashboard.sections.isEmpty) {
                    return _buildExpressUnavailableState();
                  }

                  final location = _currentSelectedAddress()!.location;
                  return ExpressDashboardContent(
                    dashboard: dashboard,
                    categoryStrip: const HomeCategoryStrip(
                      deliveryType: DeliveryType.quick,
                    ),
                    latitude: location.latitude,
                    longitude: location.longitude,
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

  Widget _buildLocationRequiredState() {
    return _buildInfoState(
      icon: Icons.location_off_outlined,
      title: 'Select a delivery location',
      message:
          'Choose a saved address with a map location to see 30-minute '
          'delivery products near you.',
      actionLabel: 'Choose address',
      onAction: _showAddressSelectionBottomSheet,
    );
  }

  Widget _buildExpressUnavailableState() {
    return _buildInfoState(
      icon: Icons.bolt_outlined,
      title: '30-minute delivery is not available here',
      message:
          'No nearby store delivers in 30 minutes to this address. Try '
          'another address or use standard delivery.',
      actionLabel: 'Change address',
      onAction: _showAddressSelectionBottomSheet,
    );
  }

  Widget _buildInfoState({
    required IconData icon,
    required String title,
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, {VoidCallback? onRetry}) {
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
                onPressed: onRetry ?? _loadDashboard,
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
