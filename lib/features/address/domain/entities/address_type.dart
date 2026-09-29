import 'package:hive/hive.dart';

part 'address_type.g.dart';

/// Enum for address types
@HiveType(typeId: 10) // Use a unique typeId that doesn't conflict with other adapters
enum AddressType {
  @HiveField(0)
  home,
  @HiveField(1)
  work,
  @HiveField(2)
  other;

  /// Get display name for the address type
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

  /// Get icon emoji for the address type
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

  /// Parse from string
  static AddressType fromString(String value) {
    return AddressType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => AddressType.other,
    );
  }
}
