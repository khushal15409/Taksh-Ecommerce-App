import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/entities/wishlist_item.dart';

/// Base state for wishlist operations
abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

/// Initial state – wishlist not yet loaded
class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

/// Loading state – fetching the wishlist from server
class WishlistLoading extends WishlistState {
  final List<WishlistItem>? previousItems;

  const WishlistLoading({this.previousItems});

  @override
  List<Object?> get props => [previousItems];
}

/// Success state – wishlist items loaded
class WishlistLoaded extends WishlistState {
  final List<WishlistItem> items;

  const WishlistLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// Loading state for adding a product to the wishlist
class AddingToWishlist extends WishlistState {
  final List<WishlistItem>? currentItems;
  final int productId;

  const AddingToWishlist({
    this.currentItems,
    required this.productId,
  });

  @override
  List<Object?> get props => [currentItems, productId];
}

/// Loading state for removing a product from the wishlist
class RemovingFromWishlist extends WishlistState {
  final List<WishlistItem>? currentItems;
  final int productId;

  const RemovingFromWishlist({
    this.currentItems,
    required this.productId,
  });

  @override
  List<Object?> get props => [currentItems, productId];
}

/// Success state after a wishlist operation (add/remove)
class WishlistOperationSuccess extends WishlistState {
  final List<WishlistItem> items;
  final String message;

  const WishlistOperationSuccess(this.items, this.message);

  @override
  List<Object?> get props => [items, message];
}

/// Error state
class WishlistError extends WishlistState {
  final String message;

  const WishlistError(this.message);

  @override
  List<Object?> get props => [message];
}
