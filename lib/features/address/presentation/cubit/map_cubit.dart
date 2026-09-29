import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/get_current_location.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/get_location_from_latlng.dart';
import 'package:taksh_e_commerce/features/address/domain/usecases/search_places.dart';
import 'package:taksh_e_commerce/features/address/presentation/cubit/map_state.dart';

/// Cubit for managing map interactions
class MapCubit extends Cubit<MapState> {
  final GetCurrentLocation _getCurrentLocation;
  final GetLocationFromLatLng _getLocationFromLatLng;
  final SearchPlaces _searchPlaces;

  MapCubit({
    required GetCurrentLocation getCurrentLocation,
    required GetLocationFromLatLng getLocationFromLatLng,
    required SearchPlaces searchPlaces,
  })  : _getCurrentLocation = getCurrentLocation,
        _getLocationFromLatLng = getLocationFromLatLng,
        _searchPlaces = searchPlaces,
        super(const MapInitial());

  final _log = loggerWithContext({
    'feature': 'address',
    'layer': 'presentation',
    'class': 'MapCubit'
  });

  /// Get current device location
  Future<void> getCurrentLocation() async {
    final startTime = DateTime.now();
    _log.infoWithContext('Getting current location', {'action': 'get_location'});

    emit(const MapLoading(message: 'Getting your location...'));

    final result = await _getCurrentLocation();

    result.fold(
      (failure) {
        _log.errorWithContext(
          'Failed to get current location',
          {
            'error': failure.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        
        if (failure.message.toLowerCase().contains('permission')) {
          emit(const MapPermissionDenied());
        } else {
          emit(MapError(failure.message));
        }
      },
      (location) {
        _log.infoWithContext(
          'Current location retrieved',
          {
            'lat': location.latitude,
            'lng': location.longitude,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        emit(MapLocationSelected(
          location: location,
          isCurrentLocation: true,
        ));
      },
    );
  }

  /// Select a location by coordinates
  Future<void> selectLocation(double latitude, double longitude) async {
    final startTime = DateTime.now();
    _log.infoWithContext(
      'Selecting location',
      {'action': 'select_location', 'lat': latitude, 'lng': longitude},
    );

    emit(const MapLoading(message: 'Getting address details...'));

    final result = await _getLocationFromLatLng(
      LatLngParams(latitude: latitude, longitude: longitude),
    );

    result.fold(
      (failure) {
        _log.errorWithContext(
          'Failed to get location details',
          {
            'error': failure.message,
            'lat': latitude,
            'lng': longitude,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        emit(MapError(failure.message));
      },
      (location) {
        _log.infoWithContext(
          'Location selected',
          {
            'lat': location.latitude,
            'lng': location.longitude,
            'address': location.formattedAddress,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        emit(MapLocationSelected(location: location));
      },
    );
  }

  /// Search for places
  Future<void> searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      emit(const MapInitial());
      return;
    }

    final startTime = DateTime.now();
    _log.infoWithContext(
      'Searching places',
      {'action': 'search', 'query': query},
    );

    emit(const MapLoading(message: 'Searching...'));

    final result = await _searchPlaces(query);

    result.fold(
      (failure) {
        _log.errorWithContext(
          'Failed to search places',
          {
            'error': failure.message,
            'query': query,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        emit(MapError(failure.message));
      },
      (places) {
        _log.infoWithContext(
          'Places found',
          {
            'count': places.length,
            'query': query,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        emit(MapSearchResults(places: places, query: query));
      },
    );
  }

  /// Select a place from search results
  void selectPlace(Location place) {
    _log.infoWithContext(
      'Place selected from search',
      {
        'lat': place.latitude,
        'lng': place.longitude,
        'address': place.formattedAddress,
      },
    );
    emit(MapLocationSelected(location: place));
  }

  /// Reset to initial state
  void reset() {
    _log.debugWithContext('Resetting map state', {'action': 'reset'});
    emit(const MapInitial());
  }
}
