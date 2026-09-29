import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

/// Widget to handle location permission requests and status
class LocationPermissionHandler extends StatelessWidget {
  final VoidCallback? onPermissionGranted;
  final VoidCallback? onPermissionDenied;
  final Widget child;

  const LocationPermissionHandler({
    super.key,
    this.onPermissionGranted,
    this.onPermissionDenied,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }

  /// Show location permission rationale dialog
  static Future<bool> showPermissionRationale(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_on, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.locationAccess),
          ],
        ),
        content: const Text(
          'We need your location to:\n\n'
          '• Show nearby stores\n'
          '• Provide accurate delivery estimates\n'
          '• Show local deals and offers\n\n'
          'Your location data is only used to improve your shopping experience.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.notNow),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.allow),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show location denied dialog with option to open settings
  static Future<void> showPermissionDeniedDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.locationPermissionRequired),
        content: const Text(
          'Location access is required to provide you with the best shopping experience.\n\n'
          'Please enable location permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.maybeLater),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openLocationSettings();
            },
            child: Text(AppLocalizations.of(context)!.openSettings),
          ),
        ],
      ),
    );
  }

  /// Show app settings dialog when permission is permanently denied
  static Future<void> showAppSettingsDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.permissionPermanentlyDenied),
        content: const Text(
          'Location permission has been permanently denied.\n\n'
          'To enable location services, please go to App Settings and manually grant location permission.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openAppSettings();
            },
            child: Text(AppLocalizations.of(context)!.appSettings),
          ),
        ],
      ),
    );
  }

  /// Request location permission with proper UI flow
  static Future<bool> requestPermissionWithUI(BuildContext context) async {
    final splashCubit = context.read<SplashCubit>();

    // Check if already granted
    if (splashCubit.hasLocationPermission) {
      return true;
    }

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showLocationServiceDisabledDialog(context);
      return false;
    }

    // Check current permission status
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      // Permission permanently denied - show app settings dialog
      await showAppSettingsDialog(context);
      return false;
    }

    if (permission == LocationPermission.denied) {
      // Show rationale before requesting
      final shouldRequest = await showPermissionRationale(context);
      if (!shouldRequest) {
        return false;
      }

      // Request permission
      final granted = await splashCubit.requestLocationPermission();

      if (!granted) {
        // Permission denied - show info dialog
        await showPermissionDeniedDialog(context);
        return false;
      }

      return true;
    }

    // Permission already granted
    return true;
  }

  /// Show location service disabled dialog
  static Future<void> _showLocationServiceDisabledDialog(
    BuildContext context,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.locationServicesDisabled),
        content: const Text(
          'Location services are currently disabled on your device.\n\n'
          'Please enable location services to use location-based features.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openLocationSettings();
            },
            child: Text(AppLocalizations.of(context)!.enable),
          ),
        ],
      ),
    );
  }

  /// Show a snackbar with location status
  static void showLocationStatus(BuildContext context, bool granted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
              Icon(
                granted ? Icons.check_circle : Icons.error,
                color: Colors.white,
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                granted
                    ? AppLocalizations.of(context)!.locationPermissionGranted
                    : 'Location permission denied', // TODO: Add key if missing
              ),
            ),
          ],
        ),
        backgroundColor: granted ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Bottom sheet widget for location permission request
class LocationPermissionBottomSheet extends StatelessWidget {
  const LocationPermissionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light ? Colors.grey[300] : Colors.grey[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          // Title
          Text(
            AppLocalizations.of(context)!.enableLocation,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            'Allow Taksh E-Commerce to access your location for better shopping experience',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 24),
          // Benefits list
          _buildBenefit(context, Icons.store, AppLocalizations.of(context)!.findNearbyStores),
          const SizedBox(height: 12),
          _buildBenefit(context, Icons.local_shipping, 'Accurate delivery time'),
          const SizedBox(height: 12),
          _buildBenefit(context, Icons.local_offer, 'Local deals & offers'),
          const SizedBox(height: 32),
          // Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final granted = await context
                    .read<SplashCubit>()
                    .requestLocationPermission();
                if (context.mounted) {
                  Navigator.of(context).pop(granted);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(AppLocalizations.of(context)!.allowLocationAccess),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.maybeLater),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBenefit(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LocationPermissionBottomSheet(),
    );
  }
}
