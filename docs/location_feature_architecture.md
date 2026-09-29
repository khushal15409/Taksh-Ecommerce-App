# Location-Based Address Feature - Architecture Plan

## Overview
This document outlines the architecture for implementing a location-based address management feature similar to Swiggy/Zomato, following Clean Architecture principles with BLoC pattern for state management.

## Feature Requirements

### Core Functionality
1. **Add Address with Map Pin**: Users can select location on map and add address details
2. **Address List Management**: View, edit, delete saved addresses
3. **Current Location Detection**: Auto-detect user's current location
4. **Address Search**: Search places using Google Places API
5. **Address Types**: Home, Work, Other with custom labels
6. **Offline Support**: Store addresses locally and sync with API
7. **Default Address**: Mark one address as default

### User Flow
```
1. User opens Address Management
2. Taps "Add New Address"
3. Map opens with current location
4. User can:
   - Drag map to select location
   - Search for places
   - Use current location
5. Confirm location → Opens address form
6. Fill details (flat/house, landmark, label)
7. Save → Syncs to API and local DB
```

---

## Architecture Design

### Layer Structure
```
lib/features/address/
├── domain/
│   ├── entities/
│   │   ├── address.dart
│   │   ├── location.dart
│   │   └── address_type.dart
│   ├── repositories/
│   │   └── address_repository.dart
│   └── usecases/
│       ├── add_address.dart
│       ├── get_addresses.dart
│       ├── update_address.dart
│       ├── delete_address.dart
│       ├── set_default_address.dart
│       ├── get_current_location.dart
│       └── search_places.dart
├── data/
│   ├── models/
│   │   ├── address_model.dart
│   │   ├── location_model.dart
│   │   └── place_model.dart
│   ├── datasources/
│   │   ├── address_local_datasource.dart
│   │   └── address_remote_datasource.dart
│   └── repositories/
│       └── address_repository_impl.dart
└── presentation/
    ├── bloc/
    │   ├── address_bloc.dart
    │   ├── address_event.dart
    │   ├── address_state.dart
    │   ├── map_cubit.dart
    │   └── map_state.dart
    ├── pages/
    │   ├── address_list_page.dart
    │   ├── add_address_page.dart
    │   └── map_picker_page.dart
    └── widgets/
        ├── address_card.dart
        ├── address_form.dart
        ├── map_widget.dart
        ├── location_search_bar.dart
        └── address_type_selector.dart
```

---

## Domain Layer

### 1. Entities

#### Address Entity
```dart
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
}
```

#### Location Entity
```dart
class Location extends Equatable {
  final double latitude;
  final double longitude;
  final String? formattedAddress;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
}
```

#### AddressType Enum
```dart
enum AddressType {
  home,
  work,
  other;
}
```

### 2. Repository Interface
```dart
abstract class AddressRepository {
  ResultFuture<List<Address>> getAddresses();
  ResultFuture<Address> getAddressById(String id);
  ResultFuture<Address> addAddress(Address address);
  ResultFuture<Address> updateAddress(Address address);
  ResultVoid deleteAddress(String id);
  ResultFuture<Address> setDefaultAddress(String id);
  ResultFuture<Location> getCurrentLocation();
  ResultFuture<List<PlaceResult>> searchPlaces(String query);
  ResultFuture<Location> getLocationFromLatLng(double lat, double lng);
}
```

### 3. Use Cases

Each use case follows the single responsibility principle:

- **AddAddress**: Validates and adds new address
- **GetAddresses**: Retrieves all user addresses
- **UpdateAddress**: Updates existing address
- **DeleteAddress**: Removes address
- **SetDefaultAddress**: Marks address as default
- **GetCurrentLocation**: Gets device location using Geolocator
- **SearchPlaces**: Searches places using Google Places API
- **GetLocationFromLatLng**: Reverse geocoding

---

## Data Layer

### 1. Models

#### AddressModel (extends Address)
```dart
class AddressModel extends Address {
  // JSON serialization
  factory AddressModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
  
  // Hive/SQLite serialization
  factory AddressModel.fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap();
}
```

### 2. Data Sources

#### Local Data Source (Hive)
```dart
abstract class AddressLocalDataSource {
  Future<List<AddressModel>> getCachedAddresses();
  Future<void> cacheAddresses(List<AddressModel> addresses);
  Future<AddressModel> getCachedAddress(String id);
  Future<void> cacheAddress(AddressModel address);
  Future<void> deleteAddress(String id);
  Future<void> clearCache();
}
```

**Implementation Strategy:**
- Use **Hive** for local storage (already in dependencies)
- Create `AddressAdapter` for Hive type adapter
- Store addresses in a Hive box named `addresses`
- Index by address ID for quick lookups

#### Remote Data Source
```dart
abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> addAddress(AddressModel address);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<void> deleteAddress(String id);
  Future<AddressModel> setDefaultAddress(String id);
}
```

**API Endpoints:**
```
GET    /api/v1/addresses          - Get all addresses
POST   /api/v1/addresses          - Add new address
PUT    /api/v1/addresses/:id      - Update address
DELETE /api/v1/addresses/:id      - Delete address
PATCH  /api/v1/addresses/:id/default - Set as default
```

### 3. Repository Implementation

#### Offline-First Strategy
```dart
class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;
  final AddressLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      // 1. Try to get from API if online
      if (await networkInfo.isConnected) {
        final remoteAddresses = await remoteDataSource.getAddresses();
        // Cache the result
        await localDataSource.cacheAddresses(remoteAddresses);
        return Right(remoteAddresses);
      }
      
      // 2. Fallback to cache if offline
      final cachedAddresses = await localDataSource.getCachedAddresses();
      return Right(cachedAddresses);
    } catch (e) {
      // Handle errors
    }
  }
  
  @override
  Future<Either<Failure, Address>> addAddress(Address address) async {
    try {
      // 1. Save to local first (optimistic update)
      await localDataSource.cacheAddress(address as AddressModel);
      
      // 2. Sync to API if online
      if (await networkInfo.isConnected) {
        final remoteAddress = await remoteDataSource.addAddress(address);
        // Update cache with server response (has ID)
        await localDataSource.cacheAddress(remoteAddress);
        return Right(remoteAddress);
      }
      
      // 3. Return local version if offline (will sync later)
      return Right(address);
    } catch (e) {
      // Handle errors
    }
  }
}
```

---

## Presentation Layer

### 1. BLoC Architecture

#### AddressBloc (Main State Management)
```dart
// Events
abstract class AddressEvent extends Equatable {}
class LoadAddresses extends AddressEvent {}
class AddAddressEvent extends AddressEvent {
  final Address address;
}
class UpdateAddressEvent extends AddressEvent {
  final Address address;
}
class DeleteAddressEvent extends AddressEvent {
  final String id;
}
class SetDefaultAddressEvent extends AddressEvent {
  final String id;
}

// States
abstract class AddressState extends Equatable {}
class AddressInitial extends AddressState {}
class AddressLoading extends AddressState {}
class AddressesLoaded extends AddressState {
  final List<Address> addresses;
  final Address? defaultAddress;
}
class AddressOperationSuccess extends AddressState {
  final String message;
}
class AddressError extends AddressState {
  final String message;
}
```

#### MapCubit (Map Interaction)
```dart
// States
abstract class MapState extends Equatable {}
class MapInitial extends MapState {}
class MapLoading extends MapState {}
class MapLocationSelected extends MapState {
  final Location location;
  final bool isCurrentLocation;
}
class MapSearchResults extends MapState {
  final List<PlaceResult> places;
}
class MapError extends MapState {
  final String message;
}

// Methods
class MapCubit extends Cubit<MapState> {
  void getCurrentLocation();
  void selectLocation(double lat, double lng);
  void searchPlaces(String query);
  void selectPlace(PlaceResult place);
}
```

### 2. UI Pages

#### AddressListPage
- Displays all saved addresses
- Shows default address badge
- Swipe to delete
- Tap to edit
- FAB to add new address

#### AddAddressPage
- Two-step process:
  1. Map picker (MapPickerPage)
  2. Address form
- Pre-fills location details from map
- Validates required fields
- Shows loading during save

#### MapPickerPage
- Full-screen map
- Search bar at top
- Current location button
- Draggable pin in center
- Confirm button at bottom
- Shows formatted address below map

### 3. Key Widgets

#### AddressCard
```dart
class AddressCard extends StatelessWidget {
  final Address address;
  final bool isDefault;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;
}
```

#### MapWidget
```dart
class MapWidget extends StatefulWidget {
  final Location? initialLocation;
  final Function(Location) onLocationSelected;
  final bool showCurrentLocationButton;
  final bool isDraggable;
}
```

#### LocationSearchBar
```dart
class LocationSearchBar extends StatefulWidget {
  final Function(PlaceResult) onPlaceSelected;
  final TextEditingController? controller;
}
```

---

## Database Schema

### Hive Box Structure
```dart
@HiveType(typeId: 0)
class AddressModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String userId;
  
  @HiveField(2)
  int type; // 0: home, 1: work, 2: other
  
  @HiveField(3)
  String? customLabel;
  
  @HiveField(4)
  double latitude;
  
  @HiveField(5)
  double longitude;
  
  @HiveField(6)
  String? formattedAddress;
  
  @HiveField(7)
  String addressLine1;
  
  @HiveField(8)
  String? addressLine2;
  
  @HiveField(9)
  String? landmark;
  
  @HiveField(10)
  String? instructions;
  
  @HiveField(11)
  bool isDefault;
  
  @HiveField(12)
  DateTime createdAt;
  
  @HiveField(13)
  DateTime updatedAt;
}
```

---

## API Integration

### Request/Response Models

#### Add Address Request
```json
{
  "type": "home",
  "custom_label": null,
  "latitude": 28.7041,
  "longitude": 77.1025,
  "formatted_address": "Connaught Place, New Delhi",
  "address_line_1": "Flat 123, Building A",
  "address_line_2": "Sector 15",
  "landmark": "Near Metro Station",
  "instructions": "Ring bell twice",
  "is_default": true
}
```

#### Address Response
```json
{
  "success": true,
  "message": "Address added successfully",
  "data": {
    "id": "addr_123",
    "user_id": "user_456",
    "type": "home",
    "custom_label": null,
    "location": {
      "latitude": 28.7041,
      "longitude": 77.1025,
      "formatted_address": "Connaught Place, New Delhi",
      "city": "New Delhi",
      "state": "Delhi",
      "country": "India",
      "postal_code": "110001"
    },
    "address_line_1": "Flat 123, Building A",
    "address_line_2": "Sector 15",
    "landmark": "Near Metro Station",
    "instructions": "Ring bell twice",
    "is_default": true,
    "created_at": "2024-01-15T10:00:00Z",
    "updated_at": "2024-01-15T10:00:00Z"
  }
}
```

---

## Dependencies Required

### Add to pubspec.yaml
```yaml
dependencies:
  # Maps & Location
  google_maps_flutter: ^2.5.0
  geolocator: ^12.0.0  # Already present
  geocoding: ^3.0.0
  
  # Local Storage (Hive already present)
  hive: ^2.2.3  # Already present
  hive_flutter: ^1.1.0  # Already present
  
  # Optional: For better map experience
  flutter_google_places_sdk: ^0.3.0
  
dev_dependencies:
  # Code generation for Hive
  hive_generator: ^2.0.1
```

### Platform Configuration

#### Android (android/app/src/main/AndroidManifest.xml)
```xml
<manifest>
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  <uses-permission android:name="android.permission.INTERNET" />
  
  <application>
    <meta-data
      android:name="com.google.android.geo.API_KEY"
      android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
  </application>
</manifest>
```

#### iOS (ios/Runner/Info.plist)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby restaurants and delivery addresses</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to show nearby restaurants and delivery addresses</string>
```

---

## State Management Flow

### Adding Address Flow
```
User Action → AddressBloc
    ↓
AddAddressEvent
    ↓
AddAddress UseCase
    ↓
AddressRepository
    ↓
├─→ LocalDataSource (Save immediately)
└─→ RemoteDataSource (Sync if online)
    ↓
Update BLoC State
    ↓
UI Updates
```

### Loading Addresses Flow
```
Page Init → AddressBloc
    ↓
LoadAddresses Event
    ↓
GetAddresses UseCase
    ↓
AddressRepository
    ↓
├─→ Check Network
│   ├─→ Online: RemoteDataSource → Cache → Return
│   └─→ Offline: LocalDataSource → Return
    ↓
AddressesLoaded State
    ↓
UI Displays List
```

---

## Error Handling Strategy

### Error Types
1. **Network Errors**: Show cached data with sync indicator
2. **Permission Errors**: Show permission request dialog
3. **Validation Errors**: Show inline form errors
4. **API Errors**: Show error message with retry option
5. **Location Errors**: Fallback to manual search

### User Feedback
- **Loading**: Shimmer effect on list, progress on map
- **Success**: Snackbar with success message
- **Error**: Error dialog with retry button
- **Offline**: Banner showing "Using cached data"

---

## Testing Strategy

### Unit Tests
- Test all use cases with mock repositories
- Test repository with mock data sources
- Test BLoC events and state transitions

### Widget Tests
- Test address card rendering
- Test form validation
- Test map interactions

### Integration Tests
- Test complete add address flow
- Test offline/online sync
- Test location permissions

---

## Performance Considerations

1. **Map Optimization**
   - Lazy load map markers
   - Debounce search queries (300ms)
   - Cache map tiles

2. **Database Optimization**
   - Index addresses by user ID
   - Limit cached addresses (max 50)
   - Periodic cache cleanup

3. **Network Optimization**
   - Batch API requests when possible
   - Implement request cancellation
   - Use pagination for large address lists

---

## Security Considerations

1. **API Security**
   - Use authentication tokens
   - Validate all inputs server-side
   - Rate limit API requests

2. **Location Privacy**
   - Request minimal permissions
   - Clear explanation of location usage
   - Option to manually enter address

3. **Data Storage**
   - Encrypt sensitive address data
   - Clear cache on logout
   - Secure API keys

---

## Future Enhancements

1. **Address Suggestions**: ML-based address completion
2. **Delivery Zone Validation**: Check if address is in serviceable area
3. **Address Sharing**: Share address via deep link
4. **Multiple Addresses**: Support for multiple delivery addresses per order
5. **Address History**: Track frequently used addresses
6. **Voice Input**: Add address via voice commands

---

## Implementation Timeline

### Phase 1: Core Setup (2-3 days)
- [ ] Add dependencies
- [ ] Create domain entities
- [ ] Setup repository interfaces
- [ ] Create use cases

### Phase 2: Data Layer (2-3 days)
- [ ] Implement models
- [ ] Setup Hive adapters
- [ ] Create local data source
- [ ] Create remote data source
- [ ] Implement repository

### Phase 3: Presentation Layer (3-4 days)
- [ ] Create BLoC/Cubit
- [ ] Build map picker page
- [ ] Build address form
- [ ] Build address list page
- [ ] Create reusable widgets

### Phase 4: Integration & Testing (2-3 days)
- [ ] Setup dependency injection
- [ ] Integrate with existing app
- [ ] Write tests
- [ ] Handle edge cases
- [ ] Polish UI/UX

**Total Estimated Time: 9-13 days**

---

## Conclusion

This architecture provides:
- ✅ Clean separation of concerns
- ✅ Offline-first approach
- ✅ Scalable and maintainable code
- ✅ Comprehensive error handling
- ✅ Excellent user experience
- ✅ Easy to test and extend

The implementation follows your existing patterns (Clean Architecture, BLoC, Dio, Hive) and integrates seamlessly with your current codebase.