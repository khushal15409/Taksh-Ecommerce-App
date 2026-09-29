import 'package:equatable/equatable.dart';

/// Location entity representing geographical coordinates and address details
class Location extends Equatable {
  final double latitude;
  final double longitude;
  final String? formattedAddress;
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;

  const Location({
    required this.latitude,
    required this.longitude,
    this.formattedAddress,
    this.street,
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
        street,
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
    String? street,
    String? city,
    String? state,
    String? country,
    String? postalCode,
  }) {
    return Location(
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

  /// Get short address (city, state)
  String get shortAddress {
    final parts = <String>[];
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    return parts.isEmpty ? 'Unknown location' : parts.join(', ');
  }

  @override
  String toString() => formattedAddress ?? shortAddress;
}
