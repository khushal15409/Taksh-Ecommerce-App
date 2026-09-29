import 'package:equatable/equatable.dart';

/// Lightweight product entity for search results
class SearchProduct extends Equatable {
  final int id;
  final String name;
  final String? brand;
  final int price;
  final int? mrp;
  final String? imageUrl;
  final bool inStock;

  const SearchProduct({
    required this.id,
    required this.name,
    this.brand,
    required this.price,
    this.mrp,
    this.imageUrl,
    required this.inStock,
  });

  bool get hasDiscount => mrp != null && mrp! > price;

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        price,
        mrp,
        imageUrl,
        inStock,
      ];
}
