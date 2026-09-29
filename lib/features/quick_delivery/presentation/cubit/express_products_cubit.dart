import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/express_products_response.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_express_products.dart';
import 'package:taksh_e_commerce/features/quick_delivery/presentation/cubit/express_products_state.dart';

class ExpressProductsCubit extends Cubit<ExpressProductsState> {
  final GetExpressProducts _getExpressProducts;

  ExpressProductsCubit({
    required GetExpressProducts getExpressProducts,
  })  : _getExpressProducts = getExpressProducts,
        super(const ExpressProductsState.initial());

  final _log = loggerWithContext({
    'feature': 'quick_delivery',
    'layer': 'presentation',
    'class': 'ExpressProductsCubit',
  });

  Future<void> fetchProducts({
    required int categoryId,
    required double latitude,
    required double longitude,
    int page = 1,
  }) async {
    if (isClosed) return;

    _log.infoWithContext(
      'Fetching express products',
      {
        'category_id': categoryId,
        'latitude': latitude,
        'longitude': longitude,
        'page': page,
      },
    );

    if (page == 1) {
      emit(state.copyWith(
        status: ExpressProductsStatus.loading,
        clearErrorMessage: true,
      ));
    } else {
      emit(state.copyWith(
        status: ExpressProductsStatus.loadingMore,
        clearErrorMessage: true,
      ));
    }

    final result = await _getExpressProducts(
      GetExpressProductsParams(
        categoryId: categoryId,
        latitude: latitude,
        longitude: longitude,
        page: page,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        _log.errorWithContext(
          'Failed to fetch express products',
          {'category_id': categoryId, 'error': failure.message},
        );
        emit(state.copyWith(
          status: ExpressProductsStatus.error,
          errorMessage: failure.message,
        ));
      },
      (response) {
        _log.infoWithContext(
          'Express products fetched successfully',
          {
            'category_id': categoryId,
            'products_count': response.products.length,
            'total': response.total,
            'page': response.currentPage,
          },
        );

        // For pagination, append products to existing list
        if (page > 1 && state.response != null) {
          final existingProducts = state.response!.products;
          final mergedResponse = ExpressProductsResponse(
            fulfillmentCenter: response.fulfillmentCenter,
            products: [...existingProducts, ...response.products],
            currentPage: response.currentPage,
            perPage: response.perPage,
            total: response.total,
            lastPage: response.lastPage,
            from: response.from,
            to: response.to,
          );
          emit(state.copyWith(
            status: ExpressProductsStatus.loaded,
            response: mergedResponse,
            currentPage: page,
          ));
        } else {
          emit(state.copyWith(
            status: ExpressProductsStatus.loaded,
            response: response,
            currentPage: page,
          ));
        }
      },
    );
  }

  Future<void> loadNextPage({
    required int categoryId,
    required double latitude,
    required double longitude,
  }) async {
    if (!state.hasMorePages) return;
    if (state.status == ExpressProductsStatus.loadingMore) return;

    await fetchProducts(
      categoryId: categoryId,
      latitude: latitude,
      longitude: longitude,
      page: state.currentPage + 1,
    );
  }
}
