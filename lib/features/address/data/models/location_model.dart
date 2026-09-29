import 'package:hive/hive.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';

part 'location_model.g.dart';

/// Location model for data layer with JSON and Hive serialization
@HiveType(typeId: 2)
class LocationModel extends Location {
  @HiveField(0)
  @override
  final double latitude;

  @HiveField(1)
  @override
  final double longitude;

  @HiveField(2)
  @override
  final String? formattedAddress;

  @HiveField(3)
  @override
  final String? street;

  @HiveField(4)
  @override
  final String? city;

  @HiveField(5)
  @override
  final String? state;

  @HiveField(6)
  @override
  final String? country;

  @HiveField(7)
  @override
  final String? postalCode;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.formattedAddress,
    this.street,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  }) : super(
          latitude: latitude,
          longitude: longitude,
          formattedAddress: formattedAddress,
          street: street,
          city: city,
          state: state,
          country: country,
          postalCode: postalCode,
        );

  /// Create from JSON (API response)
  factory LocationModel.fromJson(DataMap json) {
    return LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      formattedAddress: json['formatted_address'] as String?,
      street: json['street'] as String?,
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
      if (street != null) 'street': street,
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
      street: map['street'] as String?,
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
      'street': street,
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
      street: location.street,
      city: location.city,
      state: location.state,
      country: location.country,
      postalCode: location.postalCode,
    );
  }

  /// Create a copy with updated fields
  @override
  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? formattedAddress,
    String? street,
    String? city,
    String? state,
    String? country,
    String? postalCode,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
    );
  }
}
