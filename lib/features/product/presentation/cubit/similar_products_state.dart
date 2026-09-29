import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product.dart';

/// Base state for similar products
abstract class SimilarProductsState extends Equatable {
  const SimilarProductsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SimilarProductsInitial extends SimilarProductsState {
  const SimilarProductsInitial();
}

/// Loading state
class SimilarProductsLoading extends SimilarProductsState {
  const SimilarProductsLoading();
}

/// Success state with similar products
class SimilarProductsLoaded extends SimilarProductsState {
  final List<Product> products;
  final int currentProductId;

  const SimilarProductsLoaded({
    required this.products,
    required this.currentProductId,
  });

  @override
  List<Object?> get props => [products, currentProductId];

  /// Get filtered products excluding the current product
  List<Product> get filteredProducts =>
      products.where((p) => p.id != currentProductId).toList();

  /// Check if there are any similar products
  bool get hasSimilarProducts => filteredProducts.isNotEmpty;
}

/// Error state
class SimilarProductsError extends SimilarProductsState {
  final String message;

  const SimilarProductsError(this.message);

  @override
  List<Object?> get props => [message];
}
