import 'package:equatable/equatable.dart';

/// Category entity representing a product category in the domain layer
class Category extends Equatable {
  final int id;
  final int? parentId;
  final int? fulfillmentCenterId;
  final String name;
  final String slug;
  final String? imageUrl;
  final String? iconUrl;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Category>? children;

  const Category({
    required this.id,
    this.parentId,
    this.fulfillmentCenterId,
    required this.name,
    required this.slug,
    this.imageUrl,
    this.iconUrl,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.children,
  });

  /// Create an empty category
  factory Category.empty() {
    return const Category(
      id: 0,
      name: '',
      slug: '',
      status: '',
    );
  }

  /// Check if category is empty
  bool get isEmpty => id == 0;

  /// Check if category is not empty
  bool get isNotEmpty => id != 0;

  /// Check if category has children
  bool get hasChildren => children != null && children!.isNotEmpty;

  /// Create category from JSON (used for express dashboard categories)
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      parentId: json['parent_id'] as int?,
      fulfillmentCenterId: json['fulfillment_center_id'] as int?,
      name: json['name'] as String,
      slug: (json['slug'] as String?) ?? '',
      imageUrl: json['image_url'] as String?,
      iconUrl: json['icon_url'] as String?,
      status: (json['status'] as String?) ?? 'active',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      children: json['children'] != null
          ? (json['children'] as List)
              .map((child) => Category.fromJson(child as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        parentId,
        fulfillmentCenterId,
        name,
        slug,
        imageUrl,
        iconUrl,
        status,
        createdAt,
        updatedAt,
        children,
      ];

  @override
  String toString() {
    return 'Category(id: $id, name: $name, slug: $slug, status: $status, hasChildren: $hasChildren)';
  }
}
