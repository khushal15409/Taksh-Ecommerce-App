import 'package:hive/hive.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/address/data/models/location_model.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address.dart';
import 'package:taksh_e_commerce/features/address/domain/entities/address_type.dart';

import '../../domain/entities/location.dart';

part 'address_model.g.dart';

/// Address model for data layer with JSON and Hive serialization
@HiveType(typeId: 1)
class AddressModel extends Address {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String userId;

  @HiveField(2)
  @override
  final AddressType type;

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

  @HiveField(12)
  @override
  final String recipientName;

  @HiveField(13)
  @override
  final String recipientPhone;

  const AddressModel({
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
  }) : super(
          id: id,
          userId: userId,
          type: type,
          customLabel: customLabel,
          recipientName: recipientName,
          recipientPhone: recipientPhone,
          location: location,
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          landmark: landmark,
          instructions: instructions,
          isDefault: isDefault,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Create from JSON (API response)
  factory AddressModel.fromJson(DataMap json) {
    // Construct location from scattered fields
    final location = LocationModel(
      latitude: 0.0, // API doesn't provide coordinates
      longitude: 0.0, // API doesn't provide coordinates
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['pincode'] as String?,
      street: json['area'] as String?,
    );

    return AddressModel(
      id: json['id'].toString(), // Convert int to String
      userId: '', // API doesn't provide user_id
      type: AddressType.fromString(json['address_type'] as String),
      customLabel: json['name'] as String?,
      recipientName: json['name'] as String? ?? '',
      recipientPhone: json['mobile'] as String? ?? '',
      location: location,
      addressLine1: json['address_line_1'] as String,
      addressLine2: json['address_line_2'] as String?,
      landmark: json['landmark'] as String?,
      instructions: null, // API doesn't provide instructions
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
      'location': location.toJson(),
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
      recipientName: address.recipientName,
      recipientPhone: address.recipientPhone,
      location: address.location is LocationModel
          ? address.location as LocationModel
          : LocationModel.fromEntity(address.location),
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
  @override
  AddressModel copyWith({
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
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      customLabel: customLabel ?? this.customLabel,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      location: location is LocationModel
          ? location
          : location != null
              ? LocationModel.fromEntity(location)
              : this.location,
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
