import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address_type.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/location.dart';

/// Address entity representing a delivery address
class Address extends Equatable {
  final String id;
  final String userId;
  final AddressType type;
  final String? customLabel;
  final String recipientName; // Name of person receiving at this address
  final String recipientPhone; // Phone number of recipient
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
    required this.recipientName,
    required this.recipientPhone,
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
        recipientName,
        recipientPhone,
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

  /// Get short address for display in lists
  String get shortAddress {
    final parts = <String>[
      addressLine1,
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
    String? recipientName,
    String? recipientPhone,
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
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
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

  /// Create an empty address for form initialization
  factory Address.empty() {
    return Address(
      id: '',
      userId: '',
      type: AddressType.home,
      recipientName: '',
      recipientPhone: '',
      location: const Location(latitude: 0, longitude: 0),
      addressLine1: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
