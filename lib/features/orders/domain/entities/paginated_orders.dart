import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/pagination_link.dart';

/// Paginated orders entity
class PaginatedOrders extends Equatable {
  final int currentPage;
  final List<Order> orders;
  final String firstPageUrl;
  final int? from;
  final int lastPage;
  final String lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  const PaginatedOrders({
    required this.currentPage,
    required this.orders,
    required this.firstPageUrl,
    this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  bool get hasNextPage => nextPageUrl != null;
  bool get hasPrevPage => prevPageUrl != null;

  @override
  List<Object?> get props => [
        currentPage,
        orders,
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

  @override
  String toString() {
    return 'PaginatedOrders(currentPage: $currentPage, total: $total, orders: ${orders.length})';
  }
}
