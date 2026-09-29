import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/variant_attribute.dart';
import 'package:taksh_e_commerce/features/product/data/models/attribute_value_model.dart';

part 'variant_attribute_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class VariantAttributeModel extends VariantAttribute {
  @JsonKey(name: 'attribute_value')
  final AttributeValueModel? attributeValueModel;

  const VariantAttributeModel({
    required super.id,
    required super.productVariantId,
    required super.productAttributeId,
    required super.productAttributeValueId,
    super.createdAt,
    super.updatedAt,
    super.attribute,
    this.attributeValueModel,
  }) : super(attributeValue: attributeValueModel);

  factory VariantAttributeModel.fromJson(DataMap json) =>
      _$VariantAttributeModelFromJson(json);

  DataMap toJson() => _$VariantAttributeModelToJson(this);
}
