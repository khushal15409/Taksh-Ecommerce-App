import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_location.dart';

/// Order address entity
class OrderAddress extends Equatable {
  final int id;
  final int userId;
  final int stateId;
  final int cityId;
  final int areaId;
  final String name;
  final String mobile;
  final String? addressLine1;
  final String? addressLine2;
  final String pincode;
  final String? landmark;
  final String type;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  final OrderLocation? state;
  final OrderLocation? city;
  final OrderLocation? area;

  const OrderAddress({
    required this.id,
    required this.userId,
    required this.stateId,
    required this.cityId,
    required this.areaId,
    required this.name,
    required this.mobile,
    this.addressLine1,
    this.addressLine2,
    required this.pincode,
    this.landmark,
    required this.type,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    this.state,
    this.city,
    this.area,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        stateId,
        cityId,
        areaId,
        name,
        mobile,
        addressLine1,
        addressLine2,
        pincode,
        landmark,
        type,
        isDefault,
        createdAt,
        updatedAt,
        state,
        city,
        area,
      ];

  @override
  String toString() {
    return 'OrderAddress(id: $id, name: $name, type: $type)';
  }
}
