import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';

/// Base class for all map states
abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class MapInitial extends MapState {
  const MapInitial();
}

/// Loading state (getting location, searching, etc.)
class MapLoading extends MapState {
  final String? message;

  const MapLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// State when a location is selected
class MapLocationSelected extends MapState {
  final Location location;
  final bool isCurrentLocation;

  const MapLocationSelected({
    required this.location,
    this.isCurrentLocation = false,
  });

  @override
  List<Object?> get props => [location, isCurrentLocation];
}

/// State when search results are available
class MapSearchResults extends MapState {
  final List<Location> places;
  final String query;

  const MapSearchResults({
    required this.places,
    required this.query,
  });

  @override
  List<Object?> get props => [places, query];
}

/// Error state
class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when location permission is denied
class MapPermissionDenied extends MapState {
  const MapPermissionDenied();
}
