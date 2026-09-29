import 'dart:async';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taksh_e_commerce/core/utils/logger/app_logger.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/splash/presentation/cubit/splash_state.dart';

/// Cubit for managing splash screen initialization and app-wide setup
/// This cubit stays active for the entire lifecycle of the app
class SplashCubit extends Cubit<SplashState> {
  final AppLogger _logger;

  SplashCubit()
      : _logger = loggerWithContext({
          'feature': 'splash',
          'layer': 'cubit',
        }),
        super(const SplashInitial());

  bool _hasLocationPermission = false;
  bool _homeDataPrefetched = false;
  Position? _currentLocation;
  material.Locale _locale = const material.Locale('en');
  material.ThemeMode _themeMode = material.ThemeMode.light;

  // Getters for app-wide access
  bool get hasLocationPermission => _hasLocationPermission;
  bool get homeDataPrefetched => _homeDataPrefetched;
  Position? get currentLocation => _currentLocation;
  material.Locale get locale => _locale;
  material.ThemeMode get themeMode => _themeMode;

  /// Update app locale
  void updateLocale(material.Locale newLocale) {
    _locale = newLocale;
    emit(SplashCompleted(
      hasLocationPermission: _hasLocationPermission,
      homeDataPrefetched: _homeDataPrefetched,
      locale: _locale,
      themeMode: _themeMode,
    ));
    _logger
        .infoWithContext('Locale updated', {'locale': newLocale.languageCode});
  }

  /// Update app theme
  void updateTheme(material.ThemeMode newThemeMode) {
    _themeMode = newThemeMode;
    emit(SplashCompleted(
      hasLocationPermission: _hasLocationPermission,
      homeDataPrefetched: _homeDataPrefetched,
      locale: _locale,
      themeMode: _themeMode,
    ));
    _logger
        .infoWithContext('Theme updated', {'theme': newThemeMode.toString()});
  }

  /// Initialize all splash tasks
  /// This coordinates: minimum duration, permissions, and prefetch
  Future<void> initialize() async {
    emit(const SplashLoading(message: 'Initializing...'));

    try {
      // Run initialization tasks in parallel
      final results = await Future.wait([
        _checkAndRequestLocationPermission(),
        _ensureMinimumDuration(),
      ]);

      final permissionGranted = results[0] as bool;

      // If location permission granted, get current location
      // Wait for location fetch to complete before emitting SplashCompleted
      if (permissionGranted) {
        await _getCurrentLocation();
      }

      emit(SplashCompleted(
        hasLocationPermission: _hasLocationPermission,
        homeDataPrefetched: _homeDataPrefetched,
        locale: _locale,
        themeMode: _themeMode,
      ));

      _logger.infoWithContext(
        'Splash initialization completed',
        {
          'has_location_permission': _hasLocationPermission,
          'home_data_prefetched': _homeDataPrefetched,
        },
      );
    } catch (e, stackTrace) {
      _logger.errorWithContext(
        'Splash initialization failed',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      emit(SplashError(e.toString()));
    }
  }

  /// Prefetch home data (called after authentication is confirmed)
  /// This can be called from outside the cubit when auth state changes
  Future<void> prefetchHomeData() async {
    try {
      emit(const SplashLoading(message: 'Loading data...'));

      // TODO: Call home APIs here
      // Example:
      // await Future.wait([
      //   _homeRepository.fetchBanners(),
      //   _homeRepository.fetchCategories(),
      //   _homeRepository.fetchFeaturedProducts(),
      // ]);

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      _homeDataPrefetched = true;

      _logger.infoWithContext(
        'Home data prefetched successfully',
        {'action': 'prefetch_home_data'},
      );

      emit(SplashCompleted(
        hasLocationPermission: _hasLocationPermission,
        homeDataPrefetched: _homeDataPrefetched,
        locale: _locale,
        themeMode: _themeMode,
      ));
    } catch (e, stackTrace) {
      _logger.errorWithContext(
        'Failed to prefetch home data',
        {
          'action': 'prefetch_home_data',
          'error_type': e.runtimeType.toString(),
        },
        e,
        stackTrace,
      );
      // Don't emit error for prefetch failure, just log it
      // The app can still function without prefetched data
      emit(SplashCompleted(
        hasLocationPermission: _hasLocationPermission,
        homeDataPrefetched: false,
        locale: _locale,
        themeMode: _themeMode,
      ));
    }
  }

  /// Check and request location permission
  Future<bool> _checkAndRequestLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _logger.warnWithContext(
          'Location services are disabled',
          {'action': 'check_location_permission'},
        );
        _hasLocationPermission = false;
        return false;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      // Handle already granted permissions
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        _hasLocationPermission = true;
        _logger.infoWithContext(
          'Location permission already granted',
          {
            'action': 'check_location_permission',
            'permission_status': permission.toString(),
          },
        );
        return true;
      }

      // Handle permanently denied case - don't request again
      if (permission == LocationPermission.deniedForever) {
        _logger.warnWithContext(
          'Location permission permanently denied',
          {
            'action': 'check_location_permission',
            'permission_status': 'denied_forever',
          },
        );
        _hasLocationPermission = false;
        return false;
      }

      // Permission is denied but not permanently - request it
      if (permission == LocationPermission.denied) {
        _logger.debugWithContext(
          'Requesting location permission',
          {'action': 'check_location_permission'},
        );
        permission = await Geolocator.requestPermission();

        // Check the result of the permission request
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          _hasLocationPermission = true;
          _logger.infoWithContext(
            'Location permission granted after request',
            {
              'action': 'check_location_permission',
              'permission_status': permission.toString(),
            },
          );
          return true;
        } else if (permission == LocationPermission.deniedForever) {
          _logger.warnWithContext(
            'Location permission permanently denied after request',
            {
              'action': 'check_location_permission',
              'permission_status': 'denied_forever',
            },
          );
          _hasLocationPermission = false;
          return false;
        } else {
          _logger.warnWithContext(
            'Location permission denied after request',
            {
              'action': 'check_location_permission',
              'permission_status': 'denied',
            },
          );
          _hasLocationPermission = false;
          return false;
        }
      }

      // Fallback - should not reach here
      _logger.warnWithContext(
        'Unexpected permission state',
        {
          'action': 'check_location_permission',
          'permission_status': permission.toString(),
        },
      );
      _hasLocationPermission = false;
      return false;
    } catch (e, stackTrace) {
      _logger.errorWithContext(
        'Error checking location permission',
        {
          'action': 'check_location_permission',
          'error_type': e.runtimeType.toString(),
        },
        e,
        stackTrace,
      );
      _hasLocationPermission = false;
      return false;
    }
  }

  /// Get current location
  Future<void> _getCurrentLocation() async {
    try {
      _logger.debugWithContext(
        'Fetching current location',
        {'action': 'get_current_location'},
      );

      _currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      _logger.infoWithContext(
        'Current location retrieved successfully',
        {
          'action': 'get_current_location',
          'latitude': _currentLocation?.latitude,
          'longitude': _currentLocation?.longitude,
          'accuracy': _currentLocation?.accuracy,
        },
      );
    } on TimeoutException catch (e, stackTrace) {
      _logger.warnWithContext(
        'Location fetch timed out',
        {
          'action': 'get_current_location',
          'error_type': 'TimeoutException',
          'e': e,
          'stackTrace': stackTrace,
        },
      );
      _currentLocation = null;
    } on LocationServiceDisabledException catch (e, stackTrace) {
      _logger.warnWithContext(
        'Location services disabled during fetch',
        {
          'action': 'get_current_location',
          'error_type': 'LocationServiceDisabledException',
          'e': e,
          'stackTrace': stackTrace,
        },
      );
      _currentLocation = null;
      _hasLocationPermission = false;
    } on PermissionDeniedException catch (e, stackTrace) {
      _logger.warnWithContext(
        'Location permission denied during fetch',
        {
          'action': 'get_current_location',
          'error_type': 'PermissionDeniedException',
          'e': e,
          'stackTrace': stackTrace,
        },
      );
      _currentLocation = null;
      _hasLocationPermission = false;
    } catch (e, stackTrace) {
      _logger.errorWithContext(
        'Failed to get current location',
        {
          'action': 'get_current_location',
          'error_type': e.runtimeType.toString(),
          'e': e,
          'stackTrace': stackTrace,
        },
      );
      // Don't fail the entire initialization if location fetch fails
      _currentLocation = null;
    }
  }

  /// Ensure minimum splash duration for smooth UX
  Future<void> _ensureMinimumDuration() async {
    await Future.delayed(const Duration(milliseconds: 1500));
  }

  /// Request location permission at runtime (can be called from anywhere in the app)
  Future<bool> requestLocationPermission() async {
    final granted = await _checkAndRequestLocationPermission();

    // Check for permanently denied state
    if (!granted) {
      try {
        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.deniedForever) {
          emit(const LocationPermissionPermanentlyDenied());
          return false;
        }
      } catch (e, stackTrace) {
        _logger.errorWithContext(
          'Error checking permission status',
          {
            'action': 'request_location_permission',
            'error_type': e.runtimeType.toString(),
          },
          e,
          stackTrace,
        );
      }
      emit(const LocationPermissionDenied());
      return false;
    }

    // Permission granted - fetch location
    await _getCurrentLocation();
    emit(const LocationPermissionGranted());
    return true;
  }

  /// Refresh current location (can be called from anywhere in the app)
  Future<Position?> refreshLocation() async {
    // Re-check permission status before refreshing
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _logger.warnWithContext(
        'Cannot refresh location: location services disabled',
        {'action': 'refresh_location'},
      );
      _hasLocationPermission = false;
      return null;
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _logger.warnWithContext(
        'Cannot refresh location: permission not granted',
        {
          'action': 'refresh_location',
          'permission_status': permission.toString(),
        },
      );
      _hasLocationPermission = false;
      return null;
    }

    try {
      _logger.debugWithContext(
        'Refreshing location',
        {'action': 'refresh_location'},
      );

      _currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      _logger.infoWithContext(
        'Location refreshed successfully',
        {
          'action': 'refresh_location',
          'latitude': _currentLocation?.latitude,
          'longitude': _currentLocation?.longitude,
          'accuracy': _currentLocation?.accuracy,
        },
      );
      return _currentLocation;
    } on TimeoutException catch (e, stackTrace) {
      _logger.warnWithContext(
        'Location refresh timed out',
        {
          'action': 'refresh_location',
          'error_type': 'TimeoutException',
          'e': e,
          'stackTrace': stackTrace,
        },
      );
      return null;
    } on LocationServiceDisabledException catch (e, stackTrace) {
      _logger.warnWithContext(
        'Location services disabled during refresh',
        {
          'action': 'refresh_location',
          'error_type': 'LocationServiceDisabledException',
          'e': e,
          'stackTrace': stackTrace,
        },
      );
      _hasLocationPermission = false;
      return null;
    } on PermissionDeniedException catch (e, stackTrace) {
      _logger.warnWithContext(
        'Location permission denied during refresh',
        {
          'action': 'refresh_location',
          'error_type': 'PermissionDeniedException',
          'e': e,
          'stackTrace': stackTrace,
        },
      );
      _hasLocationPermission = false;
      return null;
    } catch (e, stackTrace) {
      _logger.errorWithContext(
        'Failed to refresh location',
        {
          'action': 'refresh_location',
          'error_type': e.runtimeType.toString(),
        },
        e,
        stackTrace,
      );
      return null;
    }
  }

  /// Reset prefetch status (useful for pull-to-refresh scenarios)
  void resetPrefetchStatus() {
    _homeDataPrefetched = false;
  }
}
