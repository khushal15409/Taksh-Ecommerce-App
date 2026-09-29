import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address_type.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';
import 'package:taksh_e_commerce/features/address/domain/repositories/address_repository.dart';

/// Mock implementation of AddressRepository for testing
class MockAddressRepository implements AddressRepository {
  final List<Address> _addresses = [
    Address(
      id: '1',
      userId: 'user_123',
      type: AddressType.home,
      recipientName: 'John Doe',
      recipientPhone: '9876543210',
      location: const Location(
        latitude: 28.7041,
        longitude: 77.1025,
        formattedAddress: 'Connaught Place, New Delhi, Delhi 110001',
        city: 'New Delhi',
        state: 'Delhi',
        country: 'India',
        postalCode: '110001',
      ),
      addressLine1: 'Flat 123, Building A',
      addressLine2: 'Sector 15',
      landmark: 'Near Metro Station',
      instructions: 'Ring bell twice',
      isDefault: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Address(
      id: '2',
      userId: 'user_123',
      type: AddressType.work,
      customLabel: 'Office',
      recipientName: 'Jane Smith',
      recipientPhone: '9876543210',
      location: const Location(
        latitude: 28.5355,
        longitude: 77.3910,
        formattedAddress: 'Noida Sector 62, Uttar Pradesh 201309',
        city: 'Noida',
        state: 'Uttar Pradesh',
        country: 'India',
        postalCode: '201309',
      ),
      addressLine1: 'Tower B, 5th Floor',
      addressLine2: 'Tech Park',
      landmark: 'Opposite Mall',
      isDefault: false,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  @override
  ResultFuture<List<Address>> getAddresses() async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    return Right(_addresses);
  }

  @override
  ResultFuture<Address> getAddressById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final address = _addresses.firstWhere((a) => a.id == id);
      return Right(address);
    } catch (e) {
      return const Left(GeneralFailure('Address not found'));
    }
  }

  @override
  ResultFuture<Address> addAddress(Address address) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newAddress = address.copyWith(
      id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _addresses.add(newAddress);
    return Right(newAddress);
  }

  @override
  ResultFuture<Address> updateAddress(Address address) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index == -1) {
      return const Left(GeneralFailure('Address not found'));
    }
    final updatedAddress = address.copyWith(updatedAt: DateTime.now());
    _addresses[index] = updatedAddress;
    return Right(updatedAddress);
  }

  @override
  ResultVoid deleteAddress(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final initialLength = _addresses.length;
    _addresses.removeWhere((a) => a.id == id);
    if (_addresses.length == initialLength) {
      return const Left(GeneralFailure('Address not found'));
    }
    return const Right(null);
  }

  @override
  ResultFuture<Address> setDefaultAddress(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _addresses.indexWhere((a) => a.id == id);
    if (index == -1) {
      return const Left(GeneralFailure('Address not found'));
    }

    // Unset all defaults
    for (var i = 0; i < _addresses.length; i++) {
      if (_addresses[i].isDefault) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }

    // Set new default
    _addresses[index] = _addresses[index].copyWith(
      isDefault: true,
      updatedAt: DateTime.now(),
    );

    return Right(_addresses[index]);
  }

  @override
  ResultFuture<Location> getCurrentLocation() async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock current location (Delhi)
    return const Right(Location(
      latitude: 28.6139,
      longitude: 77.2090,
      formattedAddress: 'New Delhi, Delhi, India',
      city: 'New Delhi',
      state: 'Delhi',
      country: 'India',
    ));
  }

  @override
  ResultFuture<Location> getLocationFromLatLng(double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock reverse geocoding
    return Right(Location(
      latitude: lat,
      longitude: lng,
      formattedAddress: 'Mock Address at $lat, $lng',
      city: 'Mock City',
      state: 'Mock State',
      country: 'India',
    ));
  }

  @override
  ResultFuture<List<Location>> searchPlaces(String query) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Mock search results
    return const Right([
      Location(
        latitude: 28.7041,
        longitude: 77.1025,
        formattedAddress: 'Connaught Place, New Delhi',
        city: 'New Delhi',
        state: 'Delhi',
        country: 'India',
      ),
      Location(
        latitude: 28.5355,
        longitude: 77.3910,
        formattedAddress: 'Noida Sector 62, Uttar Pradesh',
        city: 'Noida',
        state: 'Uttar Pradesh',
        country: 'India',
      ),
      Location(
        latitude: 28.4595,
        longitude: 77.0266,
        formattedAddress: 'Gurgaon Cyber City, Haryana',
        city: 'Gurgaon',
        state: 'Haryana',
        country: 'India',
      ),
    ]);
  }
}
