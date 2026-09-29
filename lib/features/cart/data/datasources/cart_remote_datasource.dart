import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/data/models/cart_model.dart';
import 'package:taksh_e_commerce/features/cart/data/models/cart_response_model.dart';

/// Remote data source for cart operations
abstract class CartRemoteDataSource {
  /// Get current user's cart
  Future<CartResponseModel> getCart({
    String? guestToken,
    required String deliveryType,
  });

  /// Add item to cart
  Future<CartResponseModel> addToCart({
    required int productVariantId,
    required int qty,
    required String deliveryType,
    String? guestToken,
  });

  /// Update cart item quantity
  Future<CartResponseModel> updateCartItem({
    required int cartItemId,
    required int qty,
    required String deliveryType,
    String? guestToken,
  });

  /// Remove item from cart
  Future<CartResponseModel> removeFromCart({
    required int itemId,
    required String deliveryType,
    String? guestToken,
  });

  /// Clear all items from cart
  Future<void> clearCart({String? guestToken, required String deliveryType});
}

/// Implementation of [CartRemoteDataSource]
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDataSourceImpl({required this.apiClient});

  String _mutationDeliveryType(String deliveryType) {
    return deliveryType == '30_min' ? 'express_30' : deliveryType;
  }

  @override
  Future<CartResponseModel> getCart({
    String? guestToken,
    required String deliveryType,
  }) async {
    final queryParams = <String, dynamic>{};
    queryParams['delivery_type'] = deliveryType;
    if (guestToken != null) {
      queryParams['guest_token'] = guestToken;
    }

    final response = await apiClient.get(
      '/cart/cart',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final data = response.data['data'] as DataMap;
    if (data.isEmpty) {
      return CartResponseModel(
        cart: const CartModel(itemModels: [], total: 0),
        guestToken: guestToken,
      );
    }
    return CartResponseModel.fromJson(data);
  }

  @override
  Future<CartResponseModel> addToCart({
    required int productVariantId,
    required int qty,
    required String deliveryType,
    String? guestToken,
  }) async {
    final formData = <String, dynamic>{
      'product_variant_id': productVariantId.toString(),
      'qty': qty.toString(),
      'delivery_type': _mutationDeliveryType(deliveryType),
    };

    if (guestToken != null) {
      formData['guest_token'] = guestToken;
    }

    final response = await apiClient.post('/cart/add', data: formData);

    final data = response.data['data'] as DataMap;
    return CartResponseModel.fromJson(data);
  }

  @override
  Future<CartResponseModel> updateCartItem({
    required int cartItemId,
    required int qty,
    required String deliveryType,
    String? guestToken,
  }) async {
    final formData = <String, dynamic>{
      'cart_item_id': cartItemId.toString(),
      'qty': qty.toString(),
      'delivery_type': _mutationDeliveryType(deliveryType),
    };

    if (guestToken != null) {
      formData['guest_token'] = guestToken;
    }

    final response = await apiClient.post('/cart/update', data: formData);

    final data = response.data['data'] as DataMap;
    return CartResponseModel.fromJson(data);
  }

  @override
  Future<CartResponseModel> removeFromCart({
    required int itemId,
    required String deliveryType,
    String? guestToken,
  }) async {
    final queryParams = <String, dynamic>{'delivery_type': deliveryType};
    if (guestToken != null) {
      queryParams['guest_token'] = guestToken;
    }

    final response = await apiClient.post(
      '/cart/item/$itemId',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final data = response.data['data'] as DataMap;
    return CartResponseModel.fromJson(data);
  }

  @override
  Future<void> clearCart({
    String? guestToken,
    required String deliveryType,
  }) async {
    final queryParams = <String, dynamic>{'delivery_type': deliveryType};
    if (guestToken != null) {
      queryParams['guest_token'] = guestToken;
    }

    await apiClient.delete(
      '/cart/clear',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }
}
