import 'package:hive/hive.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/address/data/models/address_model.dart';

/// Local data source for address operations using Hive
abstract class AddressLocalDataSource {
  /// Get all addresses from local storage
  Future<List<AddressModel>> getAddresses();

  /// Save addresses to local storage
  Future<void> saveAddresses(List<AddressModel> addresses);

  /// Add a single address to local storage
  Future<void> addAddress(AddressModel address);

  /// Update an address in local storage
  Future<void> updateAddress(AddressModel address);

  /// Delete an address from local storage
  Future<void> deleteAddress(String id);

  /// Clear all addresses from local storage
  Future<void> clearAddresses();
}

/// Implementation of [AddressLocalDataSource]
class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  static const String _boxName = 'addresses';
  final HiveInterface hive;

  AddressLocalDataSourceImpl({required this.hive});

  /// Get or open the addresses box
  Future<Box<AddressModel>> _getBox() async {
    if (!hive.isBoxOpen(_boxName)) {
      return await hive.openBox<AddressModel>(_boxName);
    }
    return hive.box<AddressModel>(_boxName);
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    final log = loggerWithContext({
      'feature': 'address',
      'source': 'local',
      'action': 'getAddresses',
    });

    try {
      final box = await _getBox();
      final addresses = box.values.toList();
      
      log.debugWithContext(
        'Retrieved addresses from local storage',
        {'count': addresses.length},
      );
      
      return addresses;
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error getting addresses from local storage',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      throw CacheException('Failed to get addresses: $e');
    }
  }

  @override
  Future<void> saveAddresses(List<AddressModel> addresses) async {
    final log = loggerWithContext({
      'feature': 'address',
      'source': 'local',
      'action': 'saveAddresses',
    });

    try {
      final box = await _getBox();
      
      // Clear existing addresses
      await box.clear();
      
      // Save new addresses with their IDs as keys
      for (final address in addresses) {
        await box.put(address.id, address);
      }
      
      log.debugWithContext(
        'Saved addresses to local storage',
        {'count': addresses.length},
      );
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error saving addresses to local storage',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      throw CacheException('Failed to save addresses: $e');
    }
  }

  @override
  Future<void> addAddress(AddressModel address) async {
    final log = loggerWithContext({
      'feature': 'address',
      'source': 'local',
      'action': 'addAddress',
    });

    try {
      final box = await _getBox();
      await box.put(address.id, address);
      
      log.debugWithContext(
        'Added address to local storage',
        {'address_id': address.id},
      );
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error adding address to local storage',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      throw CacheException('Failed to add address: $e');
    }
  }

  @override
  Future<void> updateAddress(AddressModel address) async {
    final log = loggerWithContext({
      'feature': 'address',
      'source': 'local',
      'action': 'updateAddress',
    });

    try {
      final box = await _getBox();
      
      if (!box.containsKey(address.id)) {
        throw CacheException('Address not found: ${address.id}');
      }
      
      await box.put(address.id, address);
      
      log.debugWithContext(
        'Updated address in local storage',
        {'address_id': address.id},
      );
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error updating address in local storage',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      if (e is CacheException) rethrow;
      throw CacheException('Failed to update address: $e');
    }
  }

  @override
  Future<void> deleteAddress(String id) async {
    final log = loggerWithContext({
      'feature': 'address',
      'source': 'local',
      'action': 'deleteAddress',
    });

    try {
      final box = await _getBox();
      
      if (!box.containsKey(id)) {
        throw CacheException('Address not found: $id');
      }
      
      await box.delete(id);
      
      log.debugWithContext(
        'Deleted address from local storage',
        {'address_id': id},
      );
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error deleting address from local storage',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      if (e is CacheException) rethrow;
      throw CacheException('Failed to delete address: $e');
    }
  }

  @override
  Future<void> clearAddresses() async {
    final log = loggerWithContext({
      'feature': 'address',
      'source': 'local',
      'action': 'clearAddresses',
    });

    try {
      final box = await _getBox();
      await box.clear();
      
      log.debugWithContext('Cleared all addresses from local storage', {});
    } catch (e, stackTrace) {
      log.errorWithContext(
        'Error clearing addresses from local storage',
        {'error_type': e.runtimeType.toString()},
        e,
        stackTrace,
      );
      throw CacheException('Failed to clear addresses: $e');
    }
  }
}
