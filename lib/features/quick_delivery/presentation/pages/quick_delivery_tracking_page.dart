import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taksh_e_commerce/core/routing/app_routes.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';
import 'package:taksh_e_commerce/features/quick_delivery/domain/entities/quick_delivery_tracking.dart';
import 'package:taksh_e_commerce/features/quick_delivery/presentation/cubit/quick_delivery_tracking_cubit.dart';
import 'package:taksh_e_commerce/features/quick_delivery/presentation/cubit/quick_delivery_tracking_state.dart';

class QuickDeliveryTrackingPage extends StatefulWidget {
  final int orderId;
  final String? orderNumber;
  final double? customerLatitude;
  final double? customerLongitude;

  const QuickDeliveryTrackingPage({
    super.key,
    required this.orderId,
    this.orderNumber,
    this.customerLatitude,
    this.customerLongitude,
  });

  @override
  State<QuickDeliveryTrackingPage> createState() =>
      _QuickDeliveryTrackingPageState();
}

class _QuickDeliveryTrackingPageState extends State<QuickDeliveryTrackingPage> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hasValidCustomerCoordinates =
          _isValidLatitude(widget.customerLatitude) &&
          _isValidLongitude(widget.customerLongitude);

      final customerLocation = hasValidCustomerCoordinates
          ? GeoPoint(
              latitude: widget.customerLatitude!,
              longitude: widget.customerLongitude!,
            )
          : null;

      context.read<QuickDeliveryTrackingCubit>().startTracking(
        orderId: widget.orderId,
        customerLocation: customerLocation,
      );
    });
  }

  bool _isValidLatitude(double? value) {
    if (value == null) return false;
    if (!value.isFinite) return false;
    if (value == 0) return false;
    return value >= -90 && value <= 90;
  }

  bool _isValidLongitude(double? value) {
    if (value == null) return false;
    if (!value.isFinite) return false;
    if (value == 0) return false;
    return value >= -180 && value <= 180;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && mounted) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(AppRoutes.home),
          ),
          title: const Text('Quick Delivery Tracking'),
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? AppColors.primaryOrange
              : Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Theme.of(context).appBarTheme.foregroundColor,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).brightness == Brightness.light
                ? IndiaGradients.subtleTricolor
                : null,
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).scaffoldBackgroundColor
                : null,
          ),
          child:
              BlocConsumer<
                QuickDeliveryTrackingCubit,
                QuickDeliveryTrackingState
              >(
                listener: (context, state) {
                  if (state.hasCustomerLocation) {
                    _focusCustomer(state.customerLocation!);
                  }
                },
                builder: (context, state) {
                  final isLoading =
                      state.status == QuickDeliveryTrackingStatus.loading;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _OrderCard(
                          orderId: widget.orderId,
                          orderNumber: widget.orderNumber,
                          orderStatus: state.orderStatus,
                          updatedAt: state.lastUpdatedAt,
                        ),
                        const SizedBox(height: 16),
                        _buildMapSection(state, isLoading),
                        const SizedBox(height: 16),
                        _StatusCard(
                          message: _statusMessage(state),
                          isError:
                              state.status == QuickDeliveryTrackingStatus.error,
                        ),
                      ],
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }

  Widget _buildMapSection(QuickDeliveryTrackingState state, bool isLoading) {
    final customer = state.customerLocation;
    final hasCustomerLocation = customer != null;

    final initialTarget = customer != null
        ? LatLng(customer.latitude, customer.longitude)
        : const LatLng(20.5937, 78.9629);

    final markers = <Marker>{
      if (customer != null)
        Marker(
          markerId: const MarkerId('customer'),
          position: LatLng(customer.latitude, customer.longitude),
          infoWindow: const InfoWindow(title: 'Your location'),
        ),
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 320,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialTarget,
                zoom: hasCustomerLocation ? 16 : 4,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                if (customer != null) {
                  _focusCustomer(customer);
                }
              },
              markers: markers,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
            ),
            if (!hasCustomerLocation)
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        if (isLoading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          const Icon(Icons.location_searching, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isLoading
                                ? 'Loading map and your location...'
                                : 'Enable location permissions to pin your location.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _statusMessage(QuickDeliveryTrackingState state) {
    if (state.status == QuickDeliveryTrackingStatus.error) {
      return state.errorMessage ??
          'Unable to fetch delivery updates right now.';
    }

    if (state.hasRiderLocation) {
      return 'Rider is nearby. Live location is visible on the map.';
    }

    if (state.message.trim().isNotEmpty) {
      return state.message;
    }

    return 'Waiting for rider to enter your 1km delivery perimeter.';
  }

  Future<void> _fitBounds({required GeoPoint customer}) async {
    final controller = _mapController;
    if (controller == null) return;

    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(customer.latitude, customer.longitude),
        16,
      ),
    );
  }

  Future<void> _focusCustomer(GeoPoint customer) async {
    await _fitBounds(customer: customer);
  }
}

class _OrderCard extends StatelessWidget {
  final int orderId;
  final String? orderNumber;
  final String orderStatus;
  final DateTime? updatedAt;

  const _OrderCard({
    required this.orderId,
    required this.orderNumber,
    required this.orderStatus,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderNumber?.isNotEmpty == true
                  ? 'Order #$orderNumber'
                  : 'Order ID: $orderId',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.local_shipping_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    orderStatus.isEmpty ? 'Pending' : orderStatus.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            if (updatedAt != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Updated: ${_formatTime(updatedAt!)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _StatusCard extends StatelessWidget {
  final String message;
  final bool isError;

  const _StatusCard({required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.info_outline,
              color: isError ? Colors.red : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
