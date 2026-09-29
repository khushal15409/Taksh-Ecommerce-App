import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/order_request.dart';

part 'order_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OrderRequestModel extends OrderRequest {
  const OrderRequestModel({
    required super.cartItemIds,
    required super.addressId,
    required super.warehouseId,
    required super.deliveryType,
    required super.isExpress,
    required super.paymentMethod,
    required super.expectedTotal,
  });

  factory OrderRequestModel.fromJson(DataMap json) =>
      _$OrderRequestModelFromJson(json);

  DataMap toJson() => _$OrderRequestModelToJson(this);

  /// Create from entity
  factory OrderRequestModel.fromEntity(OrderRequest entity) {
    return OrderRequestModel(
      cartItemIds: entity.cartItemIds,
      addressId: entity.addressId,
      warehouseId: entity.warehouseId,
      deliveryType: entity.deliveryType,
      isExpress: entity.isExpress,
      paymentMethod: entity.paymentMethod,
      expectedTotal: entity.expectedTotal,
    );
  }
}
