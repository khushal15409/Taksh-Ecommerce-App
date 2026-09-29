import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/paginated_products.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product.dart';

/// Base state for product and category operations
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProductInitial extends ProductState {
  const ProductInitial();
}

/// Loading state for categories
class CategoryLoading extends ProductState {
  const CategoryLoading();
}

/// Success state for categories
class CategoryLoaded extends ProductState {
  final List<Category> categories;

  const CategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// Loading state for product list
class ProductListLoading extends ProductState {
  const ProductListLoading();
}

/// Success state for product list
class ProductListLoaded extends ProductState {
  final PaginatedProducts paginatedProducts;

  const ProductListLoaded(this.paginatedProducts);

  @override
  List<Object?> get props => [paginatedProducts];
}

/// Loading state for product details
class ProductDetailsLoading extends ProductState {
  const ProductDetailsLoading();
}

/// Success state for product details
class ProductDetailsLoaded extends ProductState {
  final Product product;

  const ProductDetailsLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

/// Error state
class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
