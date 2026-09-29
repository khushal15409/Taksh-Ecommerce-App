import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/fulfillment_center.dart';

part 'fulfillment_center_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FulfillmentCenterModel extends FulfillmentCenter {
  const FulfillmentCenterModel({
    required super.id,
    required super.name,
  });

  factory FulfillmentCenterModel.fromJson(DataMap json) =>
      _$FulfillmentCenterModelFromJson(json);

  DataMap toJson() => _$FulfillmentCenterModelToJson(this);
}
