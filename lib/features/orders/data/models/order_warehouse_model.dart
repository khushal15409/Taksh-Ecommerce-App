import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order_warehouse.dart';

part 'order_warehouse_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrderWarehouseModel extends OrderWarehouse {
  const OrderWarehouseModel({
    required super.id,
    super.stateId,
    super.cityId,
    super.areaId,
    super.name,
    super.latitude,
    super.longitude,
    super.supports30MinDelivery,
    super.supportsExpress30,
    super.expressRadiusKm,
    super.status,
    super.createdAt,
    super.updatedAt,
  });

  factory OrderWarehouseModel.fromJson(DataMap json) =>
      _$OrderWarehouseModelFromJson(json);

  DataMap toJson() => _$OrderWarehouseModelToJson(this);
}
