import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/entities/wishlist_item.dart';

/// Repository interface for wishlist operations
abstract class WishlistRepository {
  /// Get all items in the user's wishlist
  ResultFuture<List<WishlistItem>> getWishlist();

  /// Add a product to the wishlist
  ResultFuture<WishlistItem> addToWishlist({required int productId});

  /// Remove a product from the wishlist
  ResultVoid removeFromWishlist({required int productId});
}
