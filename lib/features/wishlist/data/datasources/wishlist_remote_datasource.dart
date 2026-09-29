import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/features/wishlist/data/models/wishlist_item_model.dart';

/// Remote data source for wishlist operations
abstract class WishlistRemoteDataSource {
  /// Get all items in the user's wishlist
  Future<List<WishlistItemModel>> getWishlist();

  /// Add a product to the wishlist
  Future<WishlistItemModel> addToWishlist({required int productId});

  /// Remove a product from the wishlist
  Future<void> removeFromWishlist({required int productId});
}

/// Implementation of [WishlistRemoteDataSource]
class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final ApiClient apiClient;

  WishlistRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<WishlistItemModel>> getWishlist() async {
    final response = await apiClient.get('/wishlist');

    final responseData = response.data;
    if (responseData == null) return [];

    // The response itself might be the list, or nested under 'data'
    dynamic data;
    if (responseData is Map<String, dynamic>) {
      data = responseData['data'];
    } else {
      data = responseData;
    }

    if (data == null) return [];

    List<dynamic> items;
    if (data is List) {
      items = data;
    } else if (data is Map<String, dynamic>) {
      // Handle paginated Laravel response: { "current_page": 1, "data": [...] }
      // Or nested structures: { "wishlist": [...] } or { "items": [...] }
      items = (data['data'] as List?) ??
          (data['wishlist'] as List?) ??
          (data['items'] as List?) ??
          [];
    } else {
      return [];
    }

    print('📋 Wishlist: ${items.length} items');
    if (items.isNotEmpty && items.first is Map) {
      final first = items.first as Map;
      final product = first['product'];
      print('📋 Wishlist product keys: ${product is Map ? product.keys.toList() : "no product"}');
      if (product is Map) {
        print('📋 Wishlist product image_url: ${product['image_url']}');
        print('📋 Wishlist product images: ${product['images']}');
      }
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map((json) => WishlistItemModel.fromJson(json))
        .toList();
  }

  @override
  Future<WishlistItemModel> addToWishlist({required int productId}) async {
    final formData = <String, dynamic>{
      'product_id': productId.toString(),
    };

    final response = await apiClient.post('/wishlist/add', data: formData);

    final data = response.data['data'];

    if (data is Map<String, dynamic>) {
      return WishlistItemModel.fromJson(data);
    }

    // If the API doesn't return full item details, return a minimal model.
    // The cubit will refresh the full list afterwards.
    return WishlistItemModel(
      id: 0,
      productId: productId,
      productName: '',
    );
  }

  @override
  Future<void> removeFromWishlist({required int productId}) async {
    await apiClient.post('/wishlist/remove/$productId');
  }
}
