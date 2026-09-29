import 'package:equatable/equatable.dart';

/// Order location entity (for state, city, area)
class OrderLocation extends Equatable {
  final int id;
  final String name;
  final int? parentId; // stateId for city, cityId for area
  final String? pincode; // only for area
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderLocation({
    required this.id,
    required this.name,
    this.parentId,
    this.pincode,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        parentId,
        pincode,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'OrderLocation(id: $id, name: $name)';
  }
}
