import 'package:equatable/equatable.dart';

/// Attribute value entity
class AttributeValue extends Equatable {
  final int id;
  final int productAttributeId;
  final String value;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AttributeValue({
    required this.id,
    required this.productAttributeId,
    required this.value,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        productAttributeId,
        value,
        createdAt,
        updatedAt,
      ];
}
