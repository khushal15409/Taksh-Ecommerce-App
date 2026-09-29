import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/delivery_option.dart';

part 'delivery_option_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DeliveryOptionModel extends DeliveryOption {
  const DeliveryOptionModel({
    required super.type,
    required super.displayName,
    required super.charges,
    required super.slaMinutes,
    required super.isAvailable,
  });

  factory DeliveryOptionModel.fromJson(DataMap json) =>
      _$DeliveryOptionModelFromJson(json);

  DataMap toJson() => _$DeliveryOptionModelToJson(this);

  /// Convert to entity
  DeliveryOption toEntity() {
    return DeliveryOption(
      type: type,
      displayName: displayName,
      charges: charges,
      slaMinutes: slaMinutes,
      isAvailable: isAvailable,
    );
  }

  /// Create from entity
  factory DeliveryOptionModel.fromEntity(DeliveryOption entity) {
    return DeliveryOptionModel(
      type: entity.type,
      displayName: entity.displayName,
      charges: entity.charges,
      slaMinutes: entity.slaMinutes,
      isAvailable: entity.isAvailable,
    );
  }
}
