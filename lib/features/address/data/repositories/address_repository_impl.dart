import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/network/network_info.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/data/datasources/address_local_datasource.dart';
import 'package:taksh_e_commerce/features/address/data/datasources/address_remote_datasource.dart';
import 'package:taksh_e_commerce/features/address/data/models/address_model.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';
import 'package:taksh_e_commerce/features/address/domain/repositories/address_repository.dart';

/// Implementation of AddressRepository with remote and local data sources
class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource _remoteDataSource;
  final AddressLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  const AddressRepositoryImpl({
    required AddressRemoteDataSource remoteDataSource,
    required AddressLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  ResultFuture<List<Address>> getAddresses() async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'repository',
      'action': 'getAddresses',
    });
    final startTime = DateTime.now();

    try {
      // Check network connectivity
      final isConnected = await _networkInfo.isConnected;

      if (isConnected) {
        log.debugWithContext('Fetching addresses from remote', {});
        
        // Fetch from remote
        final remoteAddresses = await _remoteDataSource.getAddresses();
        
        // Save to local storage
        await _localDataSource.saveAddresses(remoteAddresses);
        
        log.infoWithContext(
          'Addresses fetched and cached',
          {
            'count': remoteAddresses.length,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        
        return Right(remoteAddresses);
      } else {
        log.debugWithContext('No network, fetching from local cache', {});
        
        // Fetch from local storage
        final localAddresses = await _localDataSource.getAddresses();
        
        log.infoWithContext(
          'Addresses fetched from cache',
          {
            'count': localAddresses.length,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        
        return Right(localAddresses);
      }
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network error fetching addresses',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      
      // Try to return cached data
      try {
        final localAddresses = await _localDataSource.getAddresses();
        return Right(localAddresses);
      } catch (_) {
        return Left(NetworkFailure(e.message));
      }
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server error fetching addresses',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      
      // Try to return cached data as fallback
      try {
        log.debugWithContext('Attempting to return cached addresses after server error', {});
        final localAddresses = await _localDataSource.getAddresses();
        log.infoWithContext(
          'Returning cached addresses after server error',
          {'count': localAddresses.length},
        );
        return Right(localAddresses);
      } catch (cacheError) {
        log.errorWithContext(
          'Failed to get cached addresses after server error',
          {'cache_error': cacheError.toString()},
        );
        return Left(ServerFailure(e.message));
      }
    } on CacheException catch (e, stackTrace) {
      log.errorWithContext(
        'Cache error fetching addresses',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error fetching addresses',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      
      // Try to return cached data as fallback for any unexpected error
      try {
        log.debugWithContext('Attempting to return cached addresses after unexpected error', {});
        final localAddresses = await _localDataSource.getAddresses();
        log.infoWithContext(
          'Returning cached addresses after unexpected error',
          {'count': localAddresses.length},
        );
        return Right(localAddresses);
      } catch (cacheError) {
        log.errorWithContext(
          'Failed to get cached addresses after unexpected error',
          {'cache_error': cacheError.toString()},
        );
        return Left(GeneralFailure(e.toString()));
      }
    }
  }

  @override
  ResultFuture<Address> getAddressById(String id) async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'repository',
      'action': 'getAddressById',
    });

    try {
      final addresses = await _localDataSource.getAddresses();
      final address = addresses.firstWhere(
        (a) => a.id == id,
        orElse: () => throw const CacheException('Address not found'),
      );
      
      log.debugWithContext('Address found', {'address_id': id});
      return Right(address);
    } on CacheException catch (e, stackTrace) {
      log.errorWithContext(
        'Address not found',
        {'address_id': id, 'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error getting address by ID',
        {'address_id': id, 'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  ResultFuture<Address> addAddress(Address address) async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'repository',
      'action': 'addAddress',
    });
    final startTime = DateTime.now();

    try {
      // Check network connectivity
      final isConnected = await _networkInfo.isConnected;

      if (!isConnected) {
        log.warnWithContext('No internet connection', {});
        return const Left(NetworkFailure('No internet connection'));
      }

      // Convert to model
      final addressModel = AddressModel.fromEntity(address.copyWith(
        id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      log.debugWithContext('Adding address to remote', {});
      
      // Add to remote (API returns 201 with no body)
      await _remoteDataSource.addAddress(addressModel);
      
      // Save to local storage
      await _localDataSource.addAddress(addressModel);
      
      log.infoWithContext(
        'Address added successfully',
        {
          'address_id': addressModel.id,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );
      
      return Right(addressModel);
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network error adding address',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server error adding address',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on CacheException catch (e, stackTrace) {
      log.errorWithContext(
        'Cache error adding address',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error adding address',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  ResultFuture<Address> updateAddress(Address address) async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'repository',
      'action': 'updateAddress',
    });
    final startTime = DateTime.now();

    try {
      // Check network connectivity
      final isConnected = await _networkInfo.isConnected;

      if (!isConnected) {
        log.warnWithContext('No internet connection', {});
        return const Left(NetworkFailure('No internet connection'));
      }

      // Convert to model
      final addressModel = AddressModel.fromEntity(address.copyWith(
        updatedAt: DateTime.now(),
      ));

      log.debugWithContext('Updating address on remote', {});
      
      // Update on remote
      await _remoteDataSource.updateAddress(addressModel);
      
      // Update in local storage
      await _localDataSource.updateAddress(addressModel);
      
      log.infoWithContext(
        'Address updated successfully',
        {
          'address_id': addressModel.id,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );
      
      return Right(addressModel);
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network error updating address',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server error updating address',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on CacheException catch (e, stackTrace) {
      log.errorWithContext(
        'Cache error updating address',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error updating address',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  ResultVoid deleteAddress(String id) async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'repository',
      'action': 'deleteAddress',
    });
    final startTime = DateTime.now();

    try {
      // Check network connectivity
      final isConnected = await _networkInfo.isConnected;

      if (!isConnected) {
        log.warnWithContext('No internet connection', {});
        return const Left(NetworkFailure('No internet connection'));
      }

      log.debugWithContext('Deleting address from remote', {'address_id': id});
      
      // Delete from remote
      await _remoteDataSource.deleteAddress(id);
      
      // Delete from local storage
      await _localDataSource.deleteAddress(id);
      
      log.infoWithContext(
        'Address deleted successfully',
        {
          'address_id': id,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );
      
      return const Right(null);
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network error deleting address',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server error deleting address',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on CacheException catch (e, stackTrace) {
      log.errorWithContext(
        'Cache error deleting address',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error deleting address',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  ResultFuture<Address> setDefaultAddress(String id) async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'repository',
      'action': 'setDefaultAddress',
    });
    final startTime = DateTime.now();

    try {
      // Check network connectivity
      final isConnected = await _networkInfo.isConnected;

      if (!isConnected) {
        log.warnWithContext('No internet connection', {});
        return const Left(NetworkFailure('No internet connection'));
      }

      log.debugWithContext('Setting default address on remote', {'address_id': id});
      
      // Set default on remote
      await _remoteDataSource.setDefaultAddress(id);
      
      // Update local storage
      final addresses = await _localDataSource.getAddresses();
      
      // Unset all defaults
      for (var address in addresses) {
        if (address.isDefault) {
          await _localDataSource.updateAddress(
            address.copyWith(isDefault: false, updatedAt: DateTime.now()),
          );
        }
      }
      
      // Set new default
      final targetAddress = addresses.firstWhere(
        (a) => a.id == id,
        orElse: () => throw const CacheException('Address not found'),
      );
      
      final updatedAddress = targetAddress.copyWith(
        isDefault: true,
        updatedAt: DateTime.now(),
      );
      
      await _localDataSource.updateAddress(updatedAddress);
      
      log.infoWithContext(
        'Default address set successfully',
        {
          'address_id': id,
          'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
        },
      );
      
      return Right(updatedAddress);
    } on NetworkException catch (e, stackTrace) {
      log.errorWithContext(
        'Network error setting default address',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e, stackTrace) {
      log.errorWithContext(
        'Server error setting default address',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(ServerFailure(e.message));
    } on CacheException catch (e, stackTrace) {
      log.errorWithContext(
        'Cache error setting default address',
        {'error_message': e.message},
        e,
        stackTrace,
      );
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Unexpected error setting default address',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  ResultFuture<Location> getCurrentLocation() async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'repository',
      'action': 'getCurrentLocation',
    });

    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log.warnWithContext('Location services are disabled', {});
        return const Left(
          GeneralFailure('Location services are disabled. Please enable location services.'),
        );
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log.warnWithContext('Location permission denied', {});
          return const Left(
            GeneralFailure('Location permission denied. Please grant location permission.'),
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log.warnWithContext('Location permission denied forever', {});
        return const Left(
          GeneralFailure(
            'Location permissions are permanently denied. Please enable them in app settings.',
          ),
        );
      }

      // Get current position
      log.debugWithContext('Getting current position', {});
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      log.infoWithContext(
        'Current position obtained',
        {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
        },
      );

      // Get address from coordinates
      return await getLocationFromLatLng(position.latitude, position.longitude);
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error getting current location',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      return Left(GeneralFailure('Failed to get current location: ${e.toString()}'));
    }
  }

  @override
  ResultFuture<Location> getLocationFromLatLng(double lat, double lng) async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'repository',
      'action': 'getLocationFromLatLng',
    });

    try {
      log.debugWithContext(
        'Getting address from coordinates',
        {'latitude': lat, 'longitude': lng},
      );

      // Reverse geocoding to get address from coordinates
      final placemarks = await geocoding.placemarkFromCoordinates(lat, lng);

      if (placemarks.isEmpty) {
        log.warnWithContext('No address found for coordinates', {});
        return Right(
          Location(
            latitude: lat,
            longitude: lng,
            formattedAddress: 'Location at $lat, $lng',
          ),
        );
      }

      final placemark = placemarks.first;
      
      // Build formatted address
      final addressParts = <String>[];
      if (placemark.street != null && placemark.street!.isNotEmpty) {
        addressParts.add(placemark.street!);
      }
      if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
        addressParts.add(placemark.subLocality!);
      }
      if (placemark.locality != null && placemark.locality!.isNotEmpty) {
        addressParts.add(placemark.locality!);
      }
      if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
        addressParts.add(placemark.administrativeArea!);
      }
      if (placemark.postalCode != null && placemark.postalCode!.isNotEmpty) {
        addressParts.add(placemark.postalCode!);
      }

      final formattedAddress = addressParts.isNotEmpty
          ? addressParts.join(', ')
          : 'Location at $lat, $lng';

      final location = Location(
        latitude: lat,
        longitude: lng,
        formattedAddress: formattedAddress,
        street: placemark.street,
        city: placemark.locality,
        state: placemark.administrativeArea,
        country: placemark.country,
        postalCode: placemark.postalCode,
      );

      log.infoWithContext(
        'Address obtained from coordinates',
        {
          'formatted_address': formattedAddress,
          'city': placemark.locality,
          'state': placemark.administrativeArea,
        },
      );

      return Right(location);
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error getting address from coordinates',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      
      // Return location with coordinates only if geocoding fails
      return Right(
        Location(
          latitude: lat,
          longitude: lng,
          formattedAddress: 'Location at $lat, $lng',
        ),
      );
    }
  }

  @override
  ResultFuture<List<Location>> searchPlaces(String query) async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'repository',
      'action': 'searchPlaces',
    });

    try {
      if (query.trim().isEmpty) {
        return const Right([]);
      }

      log.debugWithContext('Searching for places', {'query': query});

      // Search for locations using geocoding
      final locations = await geocoding.locationFromAddress(query);

      if (locations.isEmpty) {
        log.debugWithContext('No places found', {'query': query});
        return const Right([]);
      }

      // Convert to Location entities
      final results = <Location>[];
      for (final location in locations.take(5)) {
        // Limit to 5 results
        try {
          // Get detailed address for each location
          final placemarks = await geocoding.placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          if (placemarks.isNotEmpty) {
            final placemark = placemarks.first;
            
            // Build formatted address
            final addressParts = <String>[];
            if (placemark.street != null && placemark.street!.isNotEmpty) {
              addressParts.add(placemark.street!);
            }
            if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
              addressParts.add(placemark.subLocality!);
            }
            if (placemark.locality != null && placemark.locality!.isNotEmpty) {
              addressParts.add(placemark.locality!);
            }
            if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
              addressParts.add(placemark.administrativeArea!);
            }

            final formattedAddress = addressParts.isNotEmpty
                ? addressParts.join(', ')
                : query;

            results.add(
              Location(
                latitude: location.latitude,
                longitude: location.longitude,
                formattedAddress: formattedAddress,
                street: placemark.street,
                city: placemark.locality,
                state: placemark.administrativeArea,
                country: placemark.country,
                postalCode: placemark.postalCode,
              ),
            );
          }
        } catch (e) {
          // Skip this location if geocoding fails
          log.debugWithContext(
            'Failed to get details for location',
            {'latitude': location.latitude, 'longitude': location.longitude},
          );
        }
      }

      log.infoWithContext(
        'Places search completed',
        {'query': query, 'results_count': results.length},
      );

      return Right(results);
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error searching places',
        {'query': query, 'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      return Left(GeneralFailure('Failed to search places: ${e.toString()}'));
    }
  }
}
