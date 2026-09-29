import 'package:equatable/equatable.dart';

/// Order warehouse entity
class OrderWarehouse extends Equatable {
  final int id;
  final int? stateId;
  final int? cityId;
  final int? areaId;
  final String? name;
  final String? latitude;
  final String? longitude;
  final bool? supports30MinDelivery;
  final bool? supportsExpress30;
  final int? expressRadiusKm;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderWarehouse({
    required this.id,
    this.stateId,
    this.cityId,
    this.areaId,
    this.name,
    this.latitude,
    this.longitude,
    this.supports30MinDelivery,
    this.supportsExpress30,
    this.expressRadiusKm,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        stateId,
        cityId,
        areaId,
        name,
        latitude,
        longitude,
        supports30MinDelivery,
        supportsExpress30,
        expressRadiusKm,
        status,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'OrderWarehouse(id: $id, name: $name)';
  }
}
