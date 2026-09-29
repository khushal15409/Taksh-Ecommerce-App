import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/category.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/delivery_availability.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/express_products_response.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/paginated_products.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/product.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/recent_search.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/recent_view.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/search_products_response.dart';

/// Repository interface for product and category operations
abstract class ProductRepository {
  /// Get all categories
  ResultFuture<List<Category>> getCategories({
    required String deliveryType,
  });

  /// Get paginated products with optional filters
  ResultFuture<PaginatedProducts> getProducts({
    int? categoryId,
    String? search,
    int page = 1,
    int limit = 10,
  });

  /// Search products by keyword
  ResultFuture<SearchProductsResponse> searchProducts({
    required String keyword,
  });

  /// Get express products based on nearest fulfillment center
  ResultFuture<ExpressProductsResponse> getExpressProducts({
    required int categoryId,
    required double latitude,
    required double longitude,
    int page = 1,
    int limit = 30,
  });

  /// Get product details by ID
  ResultFuture<Product> getProductDetails(int productId);

  /// Get ecommerce product details by ID
  ResultFuture<Product> getEcommerceProductDetails(int productId);

  /// Get recent searches
  ResultFuture<List<RecentSearch>> getRecentSearches();

  /// Get recent views
  ResultFuture<List<RecentView>> getRecentViews();

  /// Check delivery availability for a product at a given pincode
  ResultFuture<DeliveryAvailability> checkDeliveryAvailability({
    required int productId,
    required String pincode,
  });
}
