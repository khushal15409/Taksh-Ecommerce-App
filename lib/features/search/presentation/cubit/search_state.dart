import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/recent_search.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/search_product.dart';

/// Base state for product search
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  final List<RecentSearch>? recentSearches;

  const SearchInitial({this.recentSearches});

  @override
  List<Object?> get props => [recentSearches];
}

class SearchRecentLoading extends SearchState {
  const SearchRecentLoading();
}

class SearchLoading extends SearchState {
  final String query;

  const SearchLoading(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchLoaded extends SearchState {
  final String query;
  final List<SearchProduct> results;

  const SearchLoaded({required this.query, required this.results});

  @override
  List<Object?> get props => [query, results];
}

class SearchError extends SearchState {
  final String query;
  final String message;

  const SearchError({required this.query, required this.message});

  @override
  List<Object?> get props => [query, message];
}
