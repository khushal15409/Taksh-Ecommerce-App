import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/attribute_value.dart';

/// Variant attribute entity
class VariantAttribute extends Equatable {
  final int id;
  final int productVariantId;
  final int productAttributeId;
  final int productAttributeValueId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic attribute; // Can be null
  final AttributeValue? attributeValue;

  const VariantAttribute({
    required this.id,
    required this.productVariantId,
    required this.productAttributeId,
    required this.productAttributeValueId,
    this.createdAt,
    this.updatedAt,
    this.attribute,
    this.attributeValue,
  });

  @override
  List<Object?> get props => [
        id,
        productVariantId,
        productAttributeId,
        productAttributeValueId,
        createdAt,
        updatedAt,
        attribute,
        attributeValue,
      ];
}
