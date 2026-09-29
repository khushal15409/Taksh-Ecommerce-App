/// Example Usage of SplashCubit
///
/// The SplashCubit is a singleton that stays active for the entire app lifecycle.
/// It manages location permissions, current location, and data prefetch status.
///
/// You can access it from anywhere in the app using:
/// ```dart
/// context.read<SplashCubit>()
/// ```
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_state.dart';

/// Example 1: Access location permission status
class ExampleLocationCheck extends StatelessWidget {
  const ExampleLocationCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final splashCubit = context.read<SplashCubit>();

    if (splashCubit.hasLocationPermission) {
      return const Text('Location permission granted');
    } else {
      return ElevatedButton(
        onPressed: () async {
          // Request permission at runtime
          final granted = await splashCubit.requestLocationPermission();
          if (granted) {
            // Permission granted, do something
          }
        },
        child: const Text('Grant Location Permission'),
      );
    }
  }
}

/// Example 2: Get current location
class ExampleGetLocation extends StatelessWidget {
  const ExampleGetLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final splashCubit = context.read<SplashCubit>();

    return ElevatedButton(
      onPressed: () async {
        final location = await splashCubit.refreshLocation();
        if (location != null) {
          print('Latitude: ${location.latitude}');
          print('Longitude: ${location.longitude}');
        }
      },
      child: const Text('Get Current Location'),
    );
  }
}

/// Example 3: Check if home data was prefetched
class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final splashCubit = context.read<SplashCubit>();

    if (splashCubit.homeDataPrefetched) {
      return const Text('Data already loaded - instant display!');
    } else {
      return const Text('Loading data...');
    }
  }
}

/// Example 4: Listen to location permission state changes
class ExamplePermissionListener extends StatelessWidget {
  const ExamplePermissionListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is LocationPermissionGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission granted')),
          );
        } else if (state is LocationPermissionDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}

/// Example 5: Manual data refresh (pull-to-refresh)
class ExampleRefresh extends StatelessWidget {
  const ExampleRefresh({super.key});

  @override
  Widget build(BuildContext context) {
    final splashCubit = context.read<SplashCubit>();

    return RefreshIndicator(
      onRefresh: () async {
        // Reset prefetch status and fetch fresh data
        splashCubit.resetPrefetchStatus();
        await splashCubit.prefetchHomeData();
      },
      child: ListView(
        children: const [
          // Your content here
        ],
      ),
    );
  }
}

/// Example 6: Access current location directly
class ExampleLocationDisplay extends StatelessWidget {
  const ExampleLocationDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final splashCubit = context.read<SplashCubit>();
    final location = splashCubit.currentLocation;

    if (location != null) {
      return Text('Current: ${location.latitude}, ${location.longitude}');
    } else {
      return const Text('Location not available');
    }
  }
}
