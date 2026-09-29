import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:taksh_e_commerce/features/splash/presentation/widgets/location_permission_handler.dart';
import 'package:taksh_e_commerce/features/splash/presentation/widgets/location_permission_prompt.dart';

/// Demo page showing all location permission UI components
/// This is for reference only - delete this file when implementing your own
class LocationPermissionUIShowcase extends StatelessWidget {
  const LocationPermissionUIShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Permission UI Components'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          const Text(
            'Location Permission UI Components',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the UI pattern that fits your app',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          // Current Status
          _buildStatusCard(context),
          const SizedBox(height: 24),

          // 1. Card Prompt
          _buildSectionHeader(
            '1. Card Prompt',
            'Best for: Home page, after splash',
          ),
          const LocationPermissionPrompt(
            onPermissionGranted: null,
            onSkip: null,
          ),
          const SizedBox(height: 24),

          // 2. Banner
          _buildSectionHeader(
            '2. Top Banner',
            'Best for: Persistent reminder',
          ),
          const LocationPermissionBanner(),
          const SizedBox(height: 24),

          // 3. Bottom Sheet
          _buildSectionHeader(
            '3. Bottom Sheet',
            'Best for: Onboarding, first time',
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await LocationPermissionBottomSheet.show(context);
            },
            icon: const Icon(Icons.location_on),
            label: const Text('Show Bottom Sheet'),
          ),
          const SizedBox(height: 24),

          // 4. Dialog with Rationale
          _buildSectionHeader(
            '4. Rationale Dialog',
            'Best for: Explaining before requesting',
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await LocationPermissionHandler.showPermissionRationale(context);
            },
            icon: const Icon(Icons.info_outline),
            label: const Text('Show Rationale Dialog'),
          ),
          const SizedBox(height: 24),

          // 5. Settings Dialog
          _buildSectionHeader(
            '5. Settings Dialog',
            'Best for: When permanently denied',
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await LocationPermissionHandler.showAppSettingsDialog(context);
            },
            icon: const Icon(Icons.settings),
            label: const Text('Show Settings Dialog'),
          ),
          const SizedBox(height: 24),

          // 6. Complete Request Flow
          _buildSectionHeader(
            '6. Complete Request Flow',
            'Handles all cases automatically',
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final granted =
                  await LocationPermissionHandler.requestPermissionWithUI(
                      context);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      granted ? 'Permission granted!' : 'Permission denied',
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.touch_app),
            label: const Text('Request Permission (Full Flow)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
          const SizedBox(height: 24),

          // 7. Refresh Location
          _buildSectionHeader(
            '7. Get/Refresh Location',
            'Fetch current location',
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final location =
                  await context.read<SplashCubit>().refreshLocation();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      location != null
                          ? 'Lat: ${location.latitude.toStringAsFixed(4)}, '
                              'Lng: ${location.longitude.toStringAsFixed(4)}'
                          : 'Location not available',
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.my_location),
            label: const Text('Get Current Location'),
          ),
          const SizedBox(height: 48),

          // Implementation note
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Implementation Tip',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose ONE pattern for your app:\n\n'
                  '• Card Prompt: Add to home page\n'
                  '• Banner: Add to top of content\n'
                  '• Bottom Sheet: Show on first launch\n'
                  '• Full Flow: Use for feature-gated requests\n\n'
                  'See location_permission_integration_examples.dart for complete code.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final splashCubit = context.read<SplashCubit>();
    final hasPermission = splashCubit.hasLocationPermission;
    final location = splashCubit.currentLocation;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasPermission ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasPermission ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasPermission ? Icons.check_circle : Icons.info_outline,
                color: hasPermission
                    ? Colors.green.shade700
                    : Colors.orange.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                'Current Status',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: hasPermission
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hasPermission
                ? '✓ Location permission granted'
                : '✗ Location permission not granted',
            style: TextStyle(
              color: hasPermission
                  ? Colors.green.shade900
                  : Colors.orange.shade900,
            ),
          ),
          if (location != null) ...[
            const SizedBox(height: 4),
            Text(
              'Location: ${location.latitude.toStringAsFixed(4)}, '
              '${location.longitude.toStringAsFixed(4)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
