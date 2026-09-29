import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_products.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/similar_products_state.dart';

/// Cubit for managing similar products state
///
/// Fetches products from the same category as the current product
/// and filters out the current product from the results.
class SimilarProductsCubit extends Cubit<SimilarProductsState> {
  final GetProducts getProducts;

  SimilarProductsCubit({
    required this.getProducts,
  }) : super(const SimilarProductsInitial());

  /// Fetch similar products based on category ID
  ///
  /// [categoryId] - The category ID to fetch products from
  /// [currentProductId] - The current product ID to exclude from results
  /// [limit] - Maximum number of products to fetch (default: 10)
  Future<void> fetchSimilarProducts({
    required int categoryId,
    required int currentProductId,
    int limit = 10,
  }) async {
    emit(const SimilarProductsLoading());

    final result = await getProducts(
      GetProductsParams(
        categoryId: categoryId,
        page: 1,
        limit: limit,
      ),
    );

    result.fold(
      (failure) => emit(SimilarProductsError(failure.message)),
      (paginatedProducts) => emit(
        SimilarProductsLoaded(
          products: paginatedProducts.products,
          currentProductId: currentProductId,
        ),
      ),
    );
  }

  /// Reset the state to initial
  void reset() {
    emit(const SimilarProductsInitial());
  }
}
