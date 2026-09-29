import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/pagination_link.dart';

/// Paginated products entity
class PaginatedProducts extends Equatable {
  final int currentPage;
  final List<Product> products;
  final String firstPageUrl;
  final int? from;
  final int lastPage;
  final String lastPageUrl;
  final List<PaginationLink>? links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  const PaginatedProducts({
    required this.currentPage,
    required this.products,
    required this.firstPageUrl,
    this.from,
    required this.lastPage,
    required this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  /// Check if there are more pages
  bool get hasNextPage => nextPageUrl != null;

  /// Check if there is a previous page
  bool get hasPrevPage => prevPageUrl != null;

  @override
  List<Object?> get props => [
        currentPage,
        products,
        firstPageUrl,
        from,
        lastPage,
        lastPageUrl,
        links,
        nextPageUrl,
        path,
        perPage,
        prevPageUrl,
        to,
        total,
      ];
}
