# Location Feature - Implementation Guide

## Quick Start Checklist

Before starting implementation, ensure you have:
- [ ] Google Maps API key (for Android & iOS)
- [ ] Backend API endpoints ready
- [ ] Understanding of Clean Architecture
- [ ] Familiarity with BLoC pattern

---

## Step-by-Step Implementation

### Step 1: Add Dependencies

Update [`pubspec.yaml`](../pubspec.yaml):

```yaml
dependencies:
  # Existing dependencies...
  
  # Maps & Location
  google_maps_flutter: ^2.5.0
  geocoding: ^3.0.0
  # geolocator: ^12.0.0  # Already present
  
  # Optional: Better place search
  flutter_google_places_sdk: ^0.3.0

dev_dependencies:
  # Existing dev dependencies...
  
  # For Hive code generation
  hive_generator: ^2.0.1
```

Run:
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### Step 2: Platform Configuration

#### Android Setup

**File**: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add permissions -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.INTERNET" />

    <application>
        <!-- Add Google Maps API Key -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="${GOOGLE_MAPS_API_KEY}"/>
        
        <!-- Existing application config... -->
    </application>
</manifest>
```

**File**: `android/local.properties`
```properties
GOOGLE_MAPS_API_KEY=your_actual_api_key_here
```

#### iOS Setup

**File**: `ios/Runner/Info.plist`

```xml
<dict>
    <!-- Add location permissions -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>We need your location to show nearby restaurants and save delivery addresses</string>
    
    <key>NSLocationAlwaysUsageDescription</key>
    <string>We need your location to provide better delivery experience</string>
    
    <!-- Existing config... -->
</dict>
```

**File**: `ios/Runner/AppDelegate.swift`

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_IOS_API_KEY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

---

### Step 3: Domain Layer Implementation

#### 3.1 Create Entities

**File**: `lib/features/address/domain/entities/address_type.dart`

```dart
/// Enum for address types
enum AddressType {
  home,
  work,
  other;

  String get displayName {
    switch (this) {
      case AddressType.home:
        return 'Home';
      case AddressType.work:
        return 'Work';
      case AddressType.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case AddressType.home:
        return '🏠';
      case AddressType.work:
        return '💼';
      case AddressType.other:
        return '📍';
    }
  }
}
```

**File**: `lib/features/address/domain/entities/location.dart`

```dart
import 'package:equatable/equatable.dart';

/// Location entity representing geographical coordinates
class Location extends Equatable {
  final double latitude;
  final double longitude;
  final String? formattedAddress;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;

  const Location({
    required this.latitude,
    required this.longitude,
    this.formattedAddress,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        formattedAddress,
        city,
        state,
        country,
        postalCode,
      ];

  /// Create a copy with updated fields
  Location copyWith({
    double? latitude,
    double? longitude,
    String? formattedAddress,
    String? city,
    String? state,
    String? country,
    String? postalCode,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
    );
  }
}
```

**File**: `lib/features/address/domain/entities/address.dart`

```dart
import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address_type.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';

/// Address entity representing a delivery address
class Address extends Equatable {
  final String id;
  final String userId;
  final AddressType type;
  final String? customLabel;
  final Location location;
  final String addressLine1;
  final String? addressLine2;
  final String? landmark;
  final String? instructions;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Address({
    required this.id,
    required this.userId,
    required this.type,
    this.customLabel,
    required this.location,
    required this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.instructions,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        customLabel,
        location,
        addressLine1,
        addressLine2,
        landmark,
        instructions,
        isDefault,
        createdAt,
        updatedAt,
      ];

  /// Get display label for the address
  String get displayLabel {
    if (customLabel != null && customLabel!.isNotEmpty) {
      return customLabel!;
    }
    return type.displayName;
  }

  /// Get full address as single string
  String get fullAddress {
    final parts = <String>[
      addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) addressLine2!,
      if (landmark != null && landmark!.isNotEmpty) landmark!,
      if (location.city != null) location.city!,
    ];
    return parts.join(', ');
  }

  /// Create a copy with updated fields
  Address copyWith({
    String? id,
    String? userId,
    AddressType? type,
    String? customLabel,
    Location? location,
    String? addressLine1,
    String? addressLine2,
    String? landmark,
    String? instructions,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Address(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      customLabel: customLabel ?? this.customLabel,
      location: location ?? this.location,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      landmark: landmark ?? this.landmark,
      instructions: instructions ?? this.instructions,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

#### 3.2 Create Repository Interface

**File**: `lib/features/address/domain/repositories/address_repository.dart`

```dart
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

  /// Set an address as default
  ResultFuture<Address> setDefaultAddress(String id);

  /// Get current device location
  ResultFuture<Location> getCurrentLocation();

  /// Get location details from coordinates (reverse geocoding)
  ResultFuture<Location> getLocationFromLatLng(double lat, double lng);

  /// Search for places
  ResultFuture<List<Location>> searchPlaces(String query);
}
```

#### 3.3 Create Use Cases

**File**: `lib/features/address/domain/usecases/get_addresses.dart`

```dart
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/domain/repositories/address_repository.dart';

/// Use case to get all addresses
class GetAddresses extends UsecaseWithoutParams<List<Address>> {
  final AddressRepository _repository;

  const GetAddresses(this._repository);

  @override
  ResultFuture<List<Address>> call() => _repository.getAddresses();
}
```

**File**: `lib/features/address/domain/usecases/add_address.dart`

```dart
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/domain/repositories/address_repository.dart';

/// Use case to add a new address
class AddAddress extends UsecaseWithParams<Address, Address> {
  final AddressRepository _repository;

  const AddAddress(this._repository);

  @override
  ResultFuture<Address> call(Address params) => _repository.addAddress(params);
}
```

**File**: `lib/features/address/domain/usecases/get_current_location.dart`

```dart
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';
import 'package:taksh_e_commerce/features/address/domain/repositories/address_repository.dart';

/// Use case to get current device location
class GetCurrentLocation extends UsecaseWithoutParams<Location> {
  final AddressRepository _repository;

  const GetCurrentLocation(this._repository);

  @override
  ResultFuture<Location> call() => _repository.getCurrentLocation();
}
```

**Similar pattern for other use cases**: UpdateAddress, DeleteAddress, SetDefaultAddress, SearchPlaces, GetLocationFromLatLng

---

### Step 4: Data Layer Implementation

#### 4.1 Create Models

**File**: `lib/features/address/data/models/location_model.dart`

```dart
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';

/// Location model for data layer
class LocationModel extends Location {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    super.formattedAddress,
    super.city,
    super.state,
    super.country,
    super.postalCode,
  });

  /// Create from JSON (API response)
  factory LocationModel.fromJson(DataMap json) {
    return LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      formattedAddress: json['formatted_address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postal_code'] as String?,
    );
  }

  /// Convert to JSON (API request)
  DataMap toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      if (formattedAddress != null) 'formatted_address': formattedAddress,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      if (postalCode != null) 'postal_code': postalCode,
    };
  }

  /// Create from Map (Hive storage)
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      formattedAddress: map['formattedAddress'] as String?,
      city: map['city'] as String?,
      state: map['state'] as String?,
      country: map['country'] as String?,
      postalCode: map['postalCode'] as String?,
    );
  }

  /// Convert to Map (Hive storage)
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'formattedAddress': formattedAddress,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
    };
  }

  /// Create from domain entity
  factory LocationModel.fromEntity(Location location) {
    return LocationModel(
      latitude: location.latitude,
      longitude: location.longitude,
      formattedAddress: location.formattedAddress,
      city: location.city,
      state: location.state,
      country: location.country,
      postalCode: location.postalCode,
    );
  }
}
```

**File**: `lib/features/address/data/models/address_model.dart`

```dart
import 'package:hive/hive.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/data/models/location_model.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address_type.dart';

part 'address_model.g.dart'; // Generated file

@HiveType(typeId: 1) // Unique type ID for Hive
class AddressModel extends Address {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String userId;

  @HiveField(2)
  final int typeIndex; // Store enum as int

  @HiveField(3)
  @override
  final String? customLabel;

  @HiveField(4)
  @override
  final LocationModel location;

  @HiveField(5)
  @override
  final String addressLine1;

  @HiveField(6)
  @override
  final String? addressLine2;

  @HiveField(7)
  @override
  final String? landmark;

  @HiveField(8)
  @override
  final String? instructions;

  @HiveField(9)
  @override
  final bool isDefault;

  @HiveField(10)
  @override
  final DateTime createdAt;

  @HiveField(11)
  @override
  final DateTime updatedAt;

  AddressModel({
    required this.id,
    required this.userId,
    required AddressType type,
    this.customLabel,
    required this.location,
    required this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.instructions,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  })  : typeIndex = type.index,
        super(
          id: id,
          userId: userId,
          type: type,
          customLabel: customLabel,
          location: location,
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          landmark: landmark,
          instructions: instructions,
          isDefault: isDefault,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Get AddressType from index
  @override
  AddressType get type => AddressType.values[typeIndex];

  /// Create from JSON (API response)
  factory AddressModel.fromJson(DataMap json) {
    return AddressModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: AddressType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AddressType.other,
      ),
      customLabel: json['custom_label'] as String?,
      location: LocationModel.fromJson(json['location'] as DataMap),
      addressLine1: json['address_line_1'] as String,
      addressLine2: json['address_line_2'] as String?,
      landmark: json['landmark'] as String?,
      instructions: json['instructions'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert to JSON (API request)
  DataMap toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      if (customLabel != null) 'custom_label': customLabel,
      'location': (location as LocationModel).toJson(),
      'address_line_1': addressLine1,
      if (addressLine2 != null) 'address_line_2': addressLine2,
      if (landmark != null) 'landmark': landmark,
      if (instructions != null) 'instructions': instructions,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create from domain entity
  factory AddressModel.fromEntity(Address address) {
    return AddressModel(
      id: address.id,
      userId: address.userId,
      type: address.type,
      customLabel: address.customLabel,
      location: LocationModel.fromEntity(address.location),
      addressLine1: address.addressLine1,
      addressLine2: address.addressLine2,
      landmark: address.landmark,
      instructions: address.instructions,
      isDefault: address.isDefault,
      createdAt: address.createdAt,
      updatedAt: address.updatedAt,
    );
  }

  /// Create a copy with updated fields
  AddressModel copyWith({
    String? id,
    String? userId,
    AddressType? type,
    String? customLabel,
    LocationModel? location,
    String? addressLine1,
    String? addressLine2,
    String? landmark,
    String? instructions,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      customLabel: customLabel ?? this.customLabel,
      location: location ?? this.location,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      landmark: landmark ?? this.landmark,
      instructions: instructions ?? this.instructions,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

#### 4.2 Create Data Sources

**File**: `lib/features/address/data/datasources/address_local_datasource.dart`

```dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/address/data/models/address_model.dart';

/// Local data source for address operations using Hive
abstract class AddressLocalDataSource {
  Future<List<AddressModel>> getCachedAddresses();
  Future<void> cacheAddresses(List<AddressModel> addresses);
  Future<AddressModel> getCachedAddress(String id);
  Future<void> cacheAddress(AddressModel address);
  Future<void> deleteAddress(String id);
  Future<void> clearCache();
}

/// Implementation of AddressLocalDataSource
class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  static const String _boxName = 'addresses';
  final Box<AddressModel> _box;

  AddressLocalDataSourceImpl({required Box<AddressModel> box}) : _box = box;

  @override
  Future<List<AddressModel>> getCachedAddresses() async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'datasource',
      'action': 'getCachedAddresses'
    });

    try {
      final addresses = _box.values.toList();
      log.infoWithContext('Retrieved cached addresses', {
        'count': addresses.length,
      });
      return addresses;
    } catch (e, stackTrace) {
      log.errorWithContext('Error getting cached addresses', {}, e, stackTrace);
      throw CacheException('Failed to get cached addresses: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheAddresses(List<AddressModel> addresses) async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'datasource',
      'action': 'cacheAddresses'
    });

    try {
      await _box.clear();
      for (final address in addresses) {
        await _box.put(address.id, address);
      }
      log.infoWithContext('Cached addresses', {'count': addresses.length});
    } catch (e, stackTrace) {
      log.errorWithContext('Error caching addresses', {}, e, stackTrace);
      throw CacheException('Failed to cache addresses: ${e.toString()}');
    }
  }

  @override
  Future<AddressModel> getCachedAddress(String id) async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'datasource',
      'action': 'getCachedAddress'
    });

    try {
      final address = _box.get(id);
      if (address == null) {
        throw CacheException('Address not found in cache');
      }
      log.infoWithContext('Retrieved cached address', {'id': id});
      return address;
    } catch (e, stackTrace) {
      log.errorWithContext('Error getting cached address', {'id': id}, e, stackTrace);
      throw CacheException('Failed to get cached address: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheAddress(AddressModel address) async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'datasource',
      'action': 'cacheAddress'
    });

    try {
      await _box.put(address.id, address);
      log.infoWithContext('Cached address', {'id': address.id});
    } catch (e, stackTrace) {
      log.errorWithContext('Error caching address', {'id': address.id}, e, stackTrace);
      throw CacheException('Failed to cache address: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAddress(String id) async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'datasource',
      'action': 'deleteAddress'
    });

    try {
      await _box.delete(id);
      log.infoWithContext('Deleted cached address', {'id': id});
    } catch (e, stackTrace) {
      log.errorWithContext('Error deleting address', {'id': id}, e, stackTrace);
      throw CacheException('Failed to delete address: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'datasource',
      'action': 'clearCache'
    });

    try {
      await _box.clear();
      log.infoWithContext('Cleared address cache', {});
    } catch (e, stackTrace) {
      log.errorWithContext('Error clearing cache', {}, e, stackTrace);
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
```

**File**: `lib/features/address/data/datasources/address_remote_datasource.dart`

```dart
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/core/network/base_response_model.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/data/models/address_model.dart';

/// Remote data source for address operations
abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> addAddress(AddressModel address);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<void> deleteAddress(String id);
  Future<AddressModel> setDefaultAddress(String id);
}

/// Implementation of AddressRemoteDataSource
class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiClient _apiClient;

  const AddressRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<AddressModel>> getAddresses() async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'datasource',
      'action': 'getAddresses'
    });

    try {
      log.infoWithContext('Fetching addresses from API', {});
      
      final response = await _apiClient.get(ApiConstants.addresses);
      final responseData = response.data as DataMap;
      
      final baseResponse = BaseResponse.fromJson(
        responseData,
        (json) => (json as List).map((e) => AddressModel.fromJson(e as DataMap)).toList(),
      );

      if (!baseResponse.success) {
        throw ServerException(baseResponse.message);
      }

      final addresses = baseResponse.data as List<AddressModel>;
      log.infoWithContext('Fetched addresses successfully', {
        'count': addresses.length,
      });
      
      return addresses;
    } catch (e, stackTrace) {
      log.errorWithContext('Error fetching addresses', {}, e, stackTrace);
      if (e is AppException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    final log = loggerWithContext({
      'feature': 'address',
      'layer': 'datasource',
      'action': 'addAddress'
    });

    try {
      log.infoWithContext('Adding address via API', {});
      
      final response = await _apiClient.post(
        ApiConstants.addresses,
        data: address.toJson(),
      );
      
      final responseData = response.data as DataMap;
      final baseResponse = BaseResponse.fromJson(
        responseData,
        (json) => AddressModel.fromJson(json as DataMap),
      );

      if (!baseResponse.success) {
        throw ServerException(baseResponse.message);
      }

      final newAddress = baseResponse.data as AddressModel;
      log.infoWithContext('Address added successfully', {'id': newAddress.id});
      
      return newAddress;
    } catch (e, stackTrace) {
      log.errorWithContext('Error adding address', {}, e, stackTrace);
      if (e is AppException) rethrow;
      throw ServerException(e.toString());
    }
  }

  // Similar implementations for updateAddress, deleteAddress, setDefaultAddress...
}
```

---

## Next Steps

This implementation guide covers the foundation. The remaining steps include:

1. **Repository Implementation** - Combine local and remote data sources
2. **BLoC/Cubit Creation** - State management for UI
3. **UI Pages** - Build the user interface
4. **Dependency Injection** - Wire everything together
5. **Testing** - Unit, widget, and integration tests

Would you like me to continue with any specific section?