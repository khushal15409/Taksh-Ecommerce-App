import 'package:equatable/equatable.dart';

/// Product image entity
class ProductImage extends Equatable {
  final int id;
  final int productId;
  final int? productVariantId;
  final String? imageUrl;
  final bool isPrimary;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductImage({
    required this.id,
    required this.productId,
    this.productVariantId,
    this.imageUrl,
    required this.isPrimary,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        productVariantId,
        imageUrl,
        isPrimary,
        sortOrder,
        createdAt,
        updatedAt,
      ];
}
