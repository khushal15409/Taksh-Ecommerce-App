import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/core/network/base_response_model.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/data/models/category_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/delivery_availability_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/express_products_response_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/paginated_products_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/product_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/recent_search_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/recent_view_model.dart';
import 'package:taksh_e_commerce/features/product/data/models/search_products_response_model.dart';

/// Remote data source for product and category operations
abstract class ProductRemoteDataSource {
  /// Get all categories
  Future<List<CategoryModel>> getCategories({required String deliveryType});

  /// Get paginated products with optional filters
  Future<PaginatedProductsModel> getProducts({
    int? categoryId,
    String? search,
    int page = 1,
    int limit = 10,
  });

  /// Search products by keyword
  Future<SearchProductsResponseModel> searchProducts({required String keyword});

  /// Get express products based on nearest fulfillment center
  Future<ExpressProductsResponseModel> getExpressProducts({
    required int categoryId,
    required double latitude,
    required double longitude,
    int page = 1,
    int limit = 30,
  });

  /// Get product details by ID
  Future<ProductModel> getProductDetails(int productId);

  /// Get ecommerce product details by ID
  Future<ProductModel> getEcommerceProductDetails(int productId);

  /// Get recent searches
  Future<List<RecentSearchModel>> getRecentSearches();

  /// Get recent views
  Future<List<RecentViewModel>> getRecentViews();

  /// Check delivery availability for a product at a given pincode
  Future<DeliveryAvailabilityModel> checkDeliveryAvailability({
    required int productId,
    required String pincode,
  });
}

/// Implementation of [ProductRemoteDataSource]
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CategoryModel>> getCategories({
    required String deliveryType,
  }) async {
    final response = await apiClient.get(
      ApiConstants.categories,
      queryParameters: {'delivery_type': deliveryType},
    );

    final responseData = response.data as DataMap;
    final baseResponse = BaseResponse.fromJson(
      responseData,
      (json) => (json as List<dynamic>)
          .map((item) => CategoryModel.fromJson(item as DataMap))
          .toList(growable: false),
    );

    if (!baseResponse.success) {
      throw ServerException(baseResponse.message);
    }

    return baseResponse.data ?? const [];
  }

  @override
  Future<PaginatedProductsModel> getProducts({
    int? categoryId,
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{'page': page, 'limit': limit};

    if (categoryId != null) {
      queryParams['category_id'] = categoryId.toString();
    }

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await apiClient.get(
      ApiConstants.ecommerceProducts,
      queryParameters: queryParams,
    );

    final responseData = response.data as DataMap;
    final baseResponse = BaseResponse.fromJson(
      responseData,
      (json) => PaginatedProductsModel.fromJson(json as DataMap),
    );

    if (!baseResponse.success) {
      throw ServerException(baseResponse.message);
    }

    if (baseResponse.data == null) {
      throw const ServerException('Product data not received');
    }

    return baseResponse.data!;
  }

  @override
  Future<SearchProductsResponseModel> searchProducts({
    required String keyword,
  }) async {
    final response = await apiClient.get(
      ApiConstants.productSearch,
      queryParameters: {'keyword': keyword},
    );

    final data = response.data as DataMap;
    return SearchProductsResponseModel.fromJson(data);
  }

  @override
  Future<ExpressProductsResponseModel> getExpressProducts({
    required int categoryId,
    required double latitude,
    required double longitude,
    int page = 1,
    int limit = 30,
  }) async {
    final formData = FormData.fromMap({
      'category_id': categoryId.toString(),
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'page_number': page.toString(),
    });

    final response = await apiClient.post(
      ApiConstants.expressProducts,
      data: formData,
    );

    final data = response.data['data'] as DataMap;
    return ExpressProductsResponseModel.fromJson(data);
  }

  @override
  Future<ProductModel> getProductDetails(int productId) async {
    final response = await apiClient.get('/products/$productId');

    final data = response.data['data'] as DataMap;
    return ProductModel.fromJson(data);
  }

  @override
  Future<ProductModel> getEcommerceProductDetails(int productId) async {
    final response = await apiClient.get(
      ApiConstants.ecommerceProductDetails(productId),
    );

    final responseData = response.data as DataMap;
    final baseResponse = BaseResponse.fromJson(
      responseData,
      (json) => ProductModel.fromJson(json as DataMap),
    );

    if (!baseResponse.success) {
      throw ServerException(baseResponse.message);
    }

    if (baseResponse.data == null) {
      throw const ServerException('Product data not received');
    }

    return baseResponse.data!;
  }

  @override
  Future<List<RecentSearchModel>> getRecentSearches() async {
    final response = await apiClient.get(ApiConstants.recentSearches);

    final responseData = response.data as DataMap;
    final baseResponse = BaseResponse.fromJson(
      responseData,
      (json) => (json as List).map((item) => item as String).toList(),
    );

    if (!baseResponse.success) {
      throw ServerException(baseResponse.message);
    }

    if (baseResponse.data == null) {
      return [];
    }

    return baseResponse.data!
        .map((searchTerm) => RecentSearchModel.fromJson(searchTerm))
        .toList();
  }

  @override
  Future<List<RecentViewModel>> getRecentViews() async {
    final response = await apiClient.get(ApiConstants.recentViews);

    final responseData = response.data as DataMap;
    final baseResponse = BaseResponse.fromJson(
      responseData,
      (json) => (json as List).map((item) => item as DataMap).toList(),
    );

    if (!baseResponse.success) {
      throw ServerException(baseResponse.message);
    }

    if (baseResponse.data == null) {
      return [];
    }

    return baseResponse.data!
        .map((item) => RecentViewModel.fromJson(item))
        .toList();
  }

  @override
  Future<DeliveryAvailabilityModel> checkDeliveryAvailability({
    required int productId,
    required String pincode,
  }) async {
    final response = await apiClient.post(
      ApiConstants.ecommerceCheckDelivery(productId),
      data: FormData.fromMap({'pincode': pincode}),
    );

    final responseData = response.data as DataMap;
    final baseResponse = BaseResponse.fromJson(
      responseData,
      (json) => DeliveryAvailabilityModel.fromJson(json as DataMap),
    );

    if (!baseResponse.success) {
      throw ServerException(baseResponse.message);
    }

    if (baseResponse.data == null) {
      throw const ServerException('Delivery check data not received');
    }

    return baseResponse.data!;
  }
}
