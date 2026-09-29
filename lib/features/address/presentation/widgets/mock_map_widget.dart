import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';

/// A mock map widget that simulates Google Maps without requiring API keys
/// This is useful for development and testing without real Google Maps setup
class MockMapWidget extends StatefulWidget {
  final Location initialLocation;
  final ValueChanged<Location>? onLocationChanged;
  final bool showCurrentLocationButton;
  final VoidCallback? onCurrentLocationPressed;

  const MockMapWidget({
    super.key,
    required this.initialLocation,
    this.onLocationChanged,
    this.showCurrentLocationButton = true,
    this.onCurrentLocationPressed,
  });

  @override
  State<MockMapWidget> createState() => _MockMapWidgetState();
}

class _MockMapWidgetState extends State<MockMapWidget> {
  Location? _currentLocation;
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
  }

  @override
  void didUpdateWidget(MockMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialLocation != oldWidget.initialLocation) {
      setState(() {
        _currentLocation = widget.initialLocation;
        _dragOffset = Offset.zero;
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _isDragging = true;
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });

    // Simulate location change based on drag
    // Each 100 pixels of drag = ~0.001 degrees
    final latChange = -_dragOffset.dy / 10000;
    final lngChange = _dragOffset.dx / 10000;

    final newLocation = Location(
      latitude: _currentLocation!.latitude + latChange,
      longitude: _currentLocation!.longitude + lngChange,
    );

    setState(() {
      _currentLocation = newLocation;
    });

    widget.onLocationChanged?.call(newLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mock map background
        GestureDetector(
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[100]!,
                  Colors.green[100]!,
                  Colors.blue[50]!,
                ],
              ),
            ),
            child: CustomPaint(
              painter: _MockMapPainter(
                offset: _dragOffset,
                location: _currentLocation!,
              ),
              size: Size.infinite,
            ),
          ),
        ),

        // Mock map overlay with info
        Positioned(
          top: 80,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber[700]!, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber[900], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mock Map Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[900],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Drag the map to change location',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber[900],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lat: ${_currentLocation!.latitude.toStringAsFixed(6)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.amber[800],
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  'Lng: ${_currentLocation!.longitude.toStringAsFixed(6)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.amber[800],
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ),

        // Center pin
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                size: 48,
                color: _isDragging
                    ? Theme.of(context).primaryColor.withOpacity(0.7)
                    : Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 48), // Offset for pin point
            ],
          ),
        ),

        // Pin shadow
        if (_isDragging)
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

        // Dragging indicator
        if (_isDragging)
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Custom painter to draw mock map grid and features
class _MockMapPainter extends CustomPainter {
  final Offset offset;
  final Location location;

  _MockMapPainter({
    required this.offset,
    required this.location,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;

    // Draw grid lines
    const gridSize = 50.0;
    final offsetX = offset.dx % gridSize;
    final offsetY = offset.dy % gridSize;

    // Vertical lines
    for (double x = offsetX; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = offsetY; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw some mock "roads"
    final roadPaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(size.width * 0.3 + offsetX, 0),
      Offset(size.width * 0.3 + offsetX, size.height),
      roadPaint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.4 + offsetY),
      Offset(size.width, size.height * 0.4 + offsetY),
      roadPaint,
    );

    // Draw some mock "buildings"
    final buildingPaint = Paint()
      ..color = Colors.grey[350]!
      ..style = PaintingStyle.fill;

    final buildings = [
      Rect.fromLTWH(size.width * 0.2 + offsetX, size.height * 0.2 + offsetY, 40, 40),
      Rect.fromLTWH(size.width * 0.6 + offsetX, size.height * 0.3 + offsetY, 50, 50),
      Rect.fromLTWH(size.width * 0.4 + offsetX, size.height * 0.6 + offsetY, 35, 35),
      Rect.fromLTWH(size.width * 0.7 + offsetX, size.height * 0.7 + offsetY, 45, 45),
    ];

    for (final building in buildings) {
      canvas.drawRect(building, buildingPaint);
    }
  }

  @override
  bool shouldRepaint(_MockMapPainter oldDelegate) {
    return offset != oldDelegate.offset || location != oldDelegate.location;
  }
}
