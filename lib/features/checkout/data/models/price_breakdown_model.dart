import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/price_breakdown.dart';

part 'price_breakdown_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PriceBreakdownModel extends PriceBreakdown {
  const PriceBreakdownModel({
    required super.itemTotal,
    required super.deliveryCharges,
    required super.cgst,
    required super.sgst,
    required super.discount,
    required super.grandTotal,
  });

  factory PriceBreakdownModel.fromJson(DataMap json) =>
      _$PriceBreakdownModelFromJson(json);

  DataMap toJson() => _$PriceBreakdownModelToJson(this);

  /// Convert to entity
  PriceBreakdown toEntity() {
    return PriceBreakdown(
      itemTotal: itemTotal,
      deliveryCharges: deliveryCharges,
      cgst: cgst,
      sgst: sgst,
      discount: discount,
      grandTotal: grandTotal,
    );
  }
}
