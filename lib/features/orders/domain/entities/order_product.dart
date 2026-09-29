import 'package:equatable/equatable.dart';

/// Order product entity
class OrderProduct extends Equatable {
  final int id;
  final int categoryId;
  final int? brandId;
  final int? fulfillmentCenterId;
  final int? lmCenterId;
  final int? vendorId;
  final String name;
  final String slug;
  final String? description;
  final String? shortDescription;
  final String status;
  final bool? isTrending;
  final bool? isLatest;
  final bool? isExpress30;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderProduct({
    required this.id,
    required this.categoryId,
    this.brandId,
    this.fulfillmentCenterId,
    this.lmCenterId,
    this.vendorId,
    required this.name,
    required this.slug,
    this.description,
    this.shortDescription,
    required this.status,
    this.isTrending,
    this.isLatest,
    this.isExpress30,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        categoryId,
        brandId,
        fulfillmentCenterId,
        lmCenterId,
        vendorId,
        name,
        slug,
        description,
        shortDescription,
        status,
        isTrending,
        isLatest,
        isExpress30,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'OrderProduct(id: $id, name: $name)';
  }
}
