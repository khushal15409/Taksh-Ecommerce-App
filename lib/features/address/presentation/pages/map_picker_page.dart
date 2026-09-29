import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taksh_e_commerce/core/di/injector.dart';
import 'package:taksh_e_commerce/core/widgets/app_error_toast.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';
import 'package:taksh_e_commerce/features/address/presentation/cubit/map_cubit.dart';
import 'package:taksh_e_commerce/features/address/presentation/cubit/map_state.dart';
import 'package:taksh_e_commerce/features/address/presentation/widgets/location_search_bar.dart';
import 'package:taksh_e_commerce/features/address/presentation/widgets/map_widget.dart';

/// Page for picking location on map
class MapPickerPage extends StatelessWidget {
  final Location? initialLocation;

  const MapPickerPage({super.key, this.initialLocation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MapCubit>(),
      child: _MapPickerView(initialLocation: initialLocation),
    );
  }
}

class _MapPickerView extends StatefulWidget {
  final Location? initialLocation;

  const _MapPickerView({this.initialLocation});

  @override
  State<_MapPickerView> createState() => _MapPickerViewState();
}

class _MapPickerViewState extends State<_MapPickerView> {
  Location? _selectedLocation;
  String? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    if (widget.initialLocation == null) {
      // Get current location on init
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MapCubit>().getCurrentLocation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapCubit, MapState>(
        listener: (context, state) {
          if (state is MapLocationSelected) {
            setState(() {
              _selectedLocation = state.location;
              _selectedAddress = state.location.formattedAddress;
            });
          } else if (state is MapError) {
            AppErrorToast.show(context);
          } else if (state is MapPermissionDenied) {
            _showPermissionDialog(context);
          }
        },
        builder: (context, state) {
          // Use selected location or initial location or default
          final currentLocation =
              _selectedLocation ??
              widget.initialLocation ??
              const Location(latitude: 20.5937, longitude: 78.9629);

          return Stack(
            children: [
              MapWidget(
                initialLocation: currentLocation,
                onLocationChanged: (location) {
                  context.read<MapCubit>().selectLocation(
                    location.latitude,
                    location.longitude,
                  );
                },
                onCurrentLocationPressed: () {
                  context.read<MapCubit>().getCurrentLocation();
                },
              ),

              // Top bar with search
              SafeArea(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Back button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Search bar
                          Expanded(
                            child: LocationSearchBar(
                              onSearch: (query) {
                                context.read<MapCubit>().searchPlaces(query);
                              },
                              onLocationSelected: (location) {
                                context.read<MapCubit>().selectPlace(location);
                              },
                              searchResults: state is MapSearchResults
                                  ? state.places
                                  : [],
                              isLoading: state is MapLoading,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom sheet with address details
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drag handle
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Address info
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Theme.of(context).primaryColor,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected Location',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(color: Colors.grey[600]),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _selectedAddress ?? 'Loading address...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Confirm button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _selectedLocation != null
                                  ? () {
                                      Navigator.of(context).pop({
                                        'location': _selectedLocation,
                                        'address': _selectedAddress,
                                      });
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Confirm Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Loading overlay
              if (state is MapLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'This app needs location permission to show your current location on the map. Please enable location permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Geolocator.openAppSettings();
              Geolocator.openLocationSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
