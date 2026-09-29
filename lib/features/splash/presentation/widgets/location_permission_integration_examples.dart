/// Location Permission Integration Examples
///
/// This file demonstrates various ways to integrate location permission handling
/// throughout your app at different touchpoints.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_state.dart';
import 'package:taksh_e_commerce/features/splash/presentation/widgets/location_permission_handler.dart';
import 'package:taksh_e_commerce/features/splash/presentation/widgets/location_permission_prompt.dart';
import 'package:taksh_e_commerce/l10n/app_localizations.dart';

// ============================================================================
// EXAMPLE 1: Show permission prompt on Home Page
// ============================================================================

class HomePageWithLocationPrompt extends StatelessWidget {
  const HomePageWithLocationPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final splashCubit = context.read<SplashCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          // Show prompt only if permission not granted
          if (!splashCubit.hasLocationPermission)
            LocationPermissionPrompt(
              onPermissionGranted: () {
                // Permission granted - you can refresh data, update UI, etc.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Location enabled! Showing nearby stores...'),
                  ),
                );
              },
              onSkip: () {
                // User skipped - maybe show later or don't show again
              },
            ),

          // Rest of your home page content
          Expanded(
            child: ListView(
              children: const [
                // Your content here
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EXAMPLE 2: Show banner at top if location is disabled
// ============================================================================

class HomePageWithBanner extends StatelessWidget {
  const HomePageWithBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          // Compact banner
          BlocBuilder<SplashCubit, SplashState>(
            builder: (context, state) {
              final hasPermission =
                  context.read<SplashCubit>().hasLocationPermission;

              if (hasPermission) return const SizedBox.shrink();

              return const LocationPermissionBanner();
            },
          ),

          // Your content
          Expanded(
            child: ListView(
              children: const [
                // Your content here
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EXAMPLE 3: Show bottom sheet when user clicks on location-based feature
// ============================================================================

class StoreLocatorPage extends StatelessWidget {
  const StoreLocatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Stores')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Check if permission is granted
            final hasPermission =
                context.read<SplashCubit>().hasLocationPermission;

            if (!hasPermission) {
              // Show bottom sheet to request permission
              final granted = await LocationPermissionBottomSheet.show(context);

              if (granted == true && context.mounted) {
                // Permission granted - proceed with location feature
                _loadNearbyStores(context);
              }
            } else {
              // Already has permission - proceed
              _loadNearbyStores(context);
            }
          },
          child: const Text('Find Nearby Stores'),
        ),
      ),
    );
  }

  void _loadNearbyStores(BuildContext context) {
    // Your logic to load nearby stores
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Loading nearby stores...')),
    );
  }
}

// ============================================================================
// EXAMPLE 4: Show floating action button
// ============================================================================

class HomePageWithFAB extends StatelessWidget {
  const HomePageWithFAB({super.key});

  @override
  Widget build(BuildContext context) {
    final hasPermission = context.read<SplashCubit>().hasLocationPermission;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        children: const [
          // Your content
        ],
      ),
      // Show FAB only if permission not granted
      floatingActionButton:
          hasPermission ? null : const LocationPermissionFAB(),
    );
  }
}

// ============================================================================
// EXAMPLE 5: In-app onboarding screens
// ============================================================================

class OnboardingLocationScreen extends StatelessWidget {
  const OnboardingLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              Icon(
                Icons.location_city,
                size: 120,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 40),

              // Title
              const Text(
                'Find Everything Nearby',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                'Enable location to discover stores, restaurants, and amazing deals near you',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Enable button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final granted =
                        await LocationPermissionHandler.requestPermissionWithUI(
                            context);

                    if (granted && context.mounted) {
                      // Move to next onboarding screen or home
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Enable Location'),
                ),
              ),
              const SizedBox(height: 12),

              // Skip button
              TextButton(
                onPressed: () {
                  // Skip to next screen
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// EXAMPLE 6: Check permission before accessing location-based feature
// ============================================================================

class DeliveryAddressPage extends StatelessWidget {
  const DeliveryAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.deliveryAddress)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.my_location),
              title: Text(AppLocalizations.of(context)!.useCurrentLocation),
              subtitle: Text(AppLocalizations.of(context)!.autoDetectLocation),
              onTap: () async {
                await _useCurrentLocation(context);
              },
            ),
            const Divider(),
            // Other address options...
          ],
        ),
      ),
    );
  }

  Future<void> _useCurrentLocation(BuildContext context) async {
    final splashCubit = context.read<SplashCubit>();

    if (!splashCubit.hasLocationPermission) {
      // Request permission first
      final granted =
          await LocationPermissionHandler.requestPermissionWithUI(context);

      if (!granted) {
        return; // User denied permission
      }
    }

    // Get current location
    final location = await splashCubit.refreshLocation();

    if (location != null && context.mounted) {
      // Use the location to fetch address
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Location: ${location.latitude}, ${location.longitude}',
          ),
        ),
      );

      // TODO: Reverse geocode to get address
    }
  }
}

// ============================================================================
// EXAMPLE 7: Listen to permission state changes globally
// ============================================================================

class AppWithLocationListener extends StatelessWidget {
  const AppWithLocationListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is LocationPermissionGranted) {
          // Permission was just granted - you can trigger updates
          _onLocationPermissionGranted(context);
        } else if (state is LocationPermissionDenied) {
          // Permission was denied
          _onLocationPermissionDenied(context);
        }
      },
      child: Scaffold(
        body: Center(child: Text(AppLocalizations.of(context)!.yourAppContent)),
      ),
    );
  }

  void _onLocationPermissionGranted(BuildContext context) {
    // Refresh home data with location-based content
    // Update nearby stores, restaurants, etc.
    print('Location permission granted - updating content');
  }

  void _onLocationPermissionDenied(BuildContext context) {
    // Maybe show a message or hide location-based features
    print('Location permission denied');
  }
}

// ============================================================================
// EXAMPLE 8: Settings page with location permission toggle
// ============================================================================

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: BlocBuilder<SplashCubit, SplashState>(
        builder: (context, state) {
          final splashCubit = context.read<SplashCubit>();
          final hasPermission = splashCubit.hasLocationPermission;

          return ListView(
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.locationServices),
                subtitle: Text(
                  hasPermission
                      ? 'Enabled - You\'ll see personalized content' // TODO: Add key
                      : 'Disabled - Enable to see nearby stores', // TODO: Add key
                ),
                value: hasPermission,
                onChanged: (value) async {
                  if (value) {
                    // Request permission
                    await LocationPermissionHandler.requestPermissionWithUI(
                      context,
                    );
                  } else {
                    // Show dialog explaining user needs to disable in system settings
                    await _showDisableLocationDialog(context);
                  }
                },
                secondary: Icon(
                  hasPermission ? Icons.location_on : Icons.location_off,
                ),
              ),
              if (hasPermission)
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(AppLocalizations.of(context)!.currentLocation),
                  subtitle: Text(
                    splashCubit.currentLocation != null
                        ? 'Lat: ${splashCubit.currentLocation!.latitude.toStringAsFixed(4)}, '
                            'Lng: ${splashCubit.currentLocation!.longitude.toStringAsFixed(4)}'
                        : 'Not available', // TODO: Add key
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      await splashCubit.refreshLocation();
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showDisableLocationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.disableLocation),
        content: const Text(
          'To disable location access, please go to your device settings and revoke the permission.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BEST PRACTICES
// ============================================================================

/*
1. **Request at the Right Time**
   - Don't request on app launch (already done in splash)
   - Request when user needs the feature
   - Provide clear context/benefit

2. **Handle Denial Gracefully**
   - App should work without location
   - Provide alternative input methods
   - Don't repeatedly ask

3. **Show Permission Status**
   - Indicate in UI when location is disabled
   - Provide easy way to re-enable
   - Show what features are limited

4. **Respect User Choice**
   - If denied, don't keep pestering
   - Provide value even without location
   - Allow manual location input

5. **Use Appropriate UI**
   - Dialog: When feature is blocked
   - Bottom sheet: Onboarding/first time
   - Banner: Persistent but non-intrusive
   - Settings: User-initiated changes
*/
