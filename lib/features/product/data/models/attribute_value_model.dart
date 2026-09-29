import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/attribute_value.dart';

part 'attribute_value_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AttributeValueModel extends AttributeValue {
  const AttributeValueModel({
    required super.id,
    required super.productAttributeId,
    required super.value,
    super.createdAt,
    super.updatedAt,
  });

  factory AttributeValueModel.fromJson(DataMap json) =>
      _$AttributeValueModelFromJson(json);

  DataMap toJson() => _$AttributeValueModelToJson(this);
}
