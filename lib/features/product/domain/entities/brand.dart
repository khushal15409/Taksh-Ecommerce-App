import 'package:equatable/equatable.dart';

/// Brand entity representing a product brand in the domain layer
class Brand extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Brand({
    required this.id,
    required this.name,
    required this.slug,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  /// Create an empty brand
  factory Brand.empty() {
    return const Brand(
      id: 0,
      name: '',
      slug: '',
      status: '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        status,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Brand(id: $id, name: $name, slug: $slug)';
  }
}
