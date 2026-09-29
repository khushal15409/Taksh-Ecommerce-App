import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Base splash state
abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// Initial splash state - nothing has started yet
class SplashInitial extends SplashState {
  const SplashInitial();
}

/// Splash is loading/initializing
class SplashLoading extends SplashState {
  final String? message;

  const SplashLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// All initialization tasks completed successfully
class SplashCompleted extends SplashState {
  final bool hasLocationPermission;
  final bool homeDataPrefetched;
  final Locale locale;
  final ThemeMode themeMode;

  const SplashCompleted({
    required this.hasLocationPermission,
    required this.homeDataPrefetched,
    this.locale = const Locale('en'),
    this.themeMode = ThemeMode.system,
  });

  @override
  List<Object?> get props => [hasLocationPermission, homeDataPrefetched, locale, themeMode];
}

/// Splash failed with error
class SplashError extends SplashState {
  final String message;

  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Location permission states (for app-wide usage)
class LocationPermissionGranted extends SplashState {
  const LocationPermissionGranted();
}

class LocationPermissionDenied extends SplashState {
  const LocationPermissionDenied();
}

class LocationPermissionPermanentlyDenied extends SplashState {
  const LocationPermissionPermanentlyDenied();
}
