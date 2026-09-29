import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/fulfillment_center.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product.dart';

/// Express products response entity with fulfillment center and pagination
class ExpressProductsResponse extends Equatable {
  final FulfillmentCenter fulfillmentCenter;
  final List<Product> products;
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int? from;
  final int? to;

  const ExpressProductsResponse({
    required this.fulfillmentCenter,
    required this.products,
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    this.from,
    this.to,
  });

  @override
  List<Object?> get props => [
        fulfillmentCenter,
        products,
        currentPage,
        perPage,
        total,
        lastPage,
        from,
        to,
      ];

  /// Check if there are more pages
  bool get hasMorePages => currentPage < lastPage;

  /// Check if products list is empty
  bool get isEmpty => products.isEmpty;

  /// Check if products list is not empty
  bool get isNotEmpty => products.isNotEmpty;
}
