import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/constants/app_constants.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/get_recent_searches.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/search_products.dart';
import 'package:taksh_e_commerce/features/search/presentation/cubit/search_state.dart';

/// Cubit for managing product search state
class SearchCubit extends Cubit<SearchState> {
  final SearchProducts searchProducts;
  final GetRecentSearches getRecentSearches;
  final _log = loggerWithContext({'feature': 'search', 'layer': 'cubit'});

  SearchCubit({
    required this.searchProducts,
    required this.getRecentSearches,
  }) : super(const SearchInitial());

  Future<void> loadRecentSearches() async {
    _log.infoWithContext('Loading recent searches', {});
    emit(const SearchRecentLoading());

    final result = await getRecentSearches();

    result.fold(
      (failure) {
        _log.errorWithContext('Failed to load recent searches', {
          'error': failure.message,
        });
        emit(const SearchInitial(recentSearches: []));
      },
      (searches) {
        _log.infoWithContext('Recent searches loaded', {
          'count': searches.length,
        });
        emit(SearchInitial(recentSearches: searches));
      },
    );
  }

  Future<void> search(String query) async {
    final keyword = query.trim();
    if (keyword.length < AppConstants.minSearchLength) {
      // Reload recent searches when query is cleared
      if (keyword.isEmpty) {
        await loadRecentSearches();
      } else {
        emit(const SearchInitial());
      }
      return;
    }

    _log.infoWithContext('Searching products', {'keyword': keyword});
    emit(SearchLoading(keyword));

    final result = await searchProducts(keyword);

    result.fold(
      (failure) {
        _log.errorWithContext('Search failed', {
          'keyword': keyword,
          'error': failure.message,
        });
        emit(SearchError(query: keyword, message: failure.message));
      },
      (response) {
        emit(SearchLoaded(query: keyword, results: response.products));
      },
    );
  }

  void clear() {
    loadRecentSearches();
  }
}
