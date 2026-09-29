import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';

/// Repository interface for address operations
abstract class AddressRepository {
  /// Get all addresses for the current user
  ResultFuture<List<Address>> getAddresses();

  /// Get a specific address by ID
  ResultFuture<Address> getAddressById(String id);

  /// Add a new address
  ResultFuture<Address> addAddress(Address address);

  /// Update an existing address
  ResultFuture<Address> updateAddress(Address address);

  /// Delete an address
  ResultVoid deleteAddress(String id);

  /// Set an address as default (unsets other defaults)
  ResultFuture<Address> setDefaultAddress(String id);

  /// Get current device location with address details
  ResultFuture<Location> getCurrentLocation();

  /// Get location details from coordinates (reverse geocoding)
  ResultFuture<Location> getLocationFromLatLng(double lat, double lng);

  /// Search for places using query string
  ResultFuture<List<Location>> searchPlaces(String query);
}
