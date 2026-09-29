import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart.dart';

/// Repository interface for cart operations
abstract class CartRepository {
  /// Get current user's cart
  ResultFuture<Cart> getCart({
    String? guestToken,
    String deliveryType = 'normal',
  });

  /// Add item to cart
  ResultFuture<Cart> addToCart({
    required int productVariantId,
    required int qty,
    String? guestToken,
    String deliveryType = 'normal',
  });

  /// Update cart item quantity
  ResultFuture<Cart> updateCartItem({
    required int cartItemId,
    required int qty,
    String? guestToken,
    String deliveryType = 'normal',
  });

  /// Remove item from cart
  ResultFuture<Cart> removeFromCart({
    required int itemId,
    String? guestToken,
    String deliveryType = 'normal',
  });

  /// Clear all items from cart
  ResultFuture<void> clearCart({
    String? guestToken,
    String deliveryType = 'normal',
  });
}
