import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';

/// A widget to display Google Maps with a draggable pin
class MapWidget extends StatefulWidget {
  final Location initialLocation;
  final ValueChanged<Location>? onLocationChanged;
  final bool showCurrentLocationButton;
  final VoidCallback? onCurrentLocationPressed;

  const MapWidget({
    super.key,
    required this.initialLocation,
    this.onLocationChanged,
    this.showCurrentLocationButton = true,
    this.onCurrentLocationPressed,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  bool _isMapMoving = false;
  bool _hasUserMovedMap = false;
  bool _isProgrammaticCameraMove = false;

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(
      widget.initialLocation.latitude,
      widget.initialLocation.longitude,
    );
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialLocation != oldWidget.initialLocation) {
      _currentPosition = LatLng(
        widget.initialLocation.latitude,
        widget.initialLocation.longitude,
      );
      _animateToPosition(_currentPosition!);
    }
  }

  Future<void> _animateToPosition(LatLng position) async {
    final controller = _mapController;
    if (controller == null) return;

    _isProgrammaticCameraMove = true;
    try {
      await controller.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
    } finally {
      _isProgrammaticCameraMove = false;
    }
  }

  void _onCameraMove(CameraPosition position) {
    if (_isProgrammaticCameraMove) {
      _currentPosition = position.target;
      return;
    }

    setState(() {
      _hasUserMovedMap = true;
      _isMapMoving = true;
      _currentPosition = position.target;
    });
  }

  void _onCameraIdle() {
    if (_isProgrammaticCameraMove || !_hasUserMovedMap) {
      return;
    }

    setState(() {
      _hasUserMovedMap = false;
      _isMapMoving = false;
    });

    if (_currentPosition != null) {
      final location = Location(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
      );
      widget.onLocationChanged?.call(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Google Map
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentPosition!,
            zoom: 15,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
          },
          onCameraMove: _onCameraMove,
          onCameraIdle: _onCameraIdle,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: false,
        ),

        // Center pin
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                size: 48,
                color: _isMapMoving
                    ? Theme.of(context).primaryColor.withOpacity(0.7)
                    : Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 48), // Offset for pin point
            ],
          ),
        ),

        // Pin shadow
        if (_isMapMoving)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 48),
                Container(
                  width: 20,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),

        // Current location button
        if (widget.showCurrentLocationButton)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: widget.onCurrentLocationPressed,
              child: Icon(
                Icons.my_location,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),

        // Loading indicator when map is moving
        if (_isMapMoving)
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Updating location...',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
