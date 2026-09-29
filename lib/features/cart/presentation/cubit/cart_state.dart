import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart.dart';

/// Base state for cart operations
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CartInitial extends CartState {
  const CartInitial();
}

/// Loading state for cart — optionally preserves the previous cart so
/// product-card buttons keep showing the correct qty during a refetch.
class CartLoading extends CartState {
  final Cart? previousCart;
  const CartLoading({this.previousCart});

  @override
  List<Object?> get props => [previousCart];
}

/// Success state for cart loaded
class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}

/// Loading state for adding to cart - preserves current cart
class AddingToCart extends CartState {
  final Cart? currentCart;
  final int productVariantId;
  final String deliveryType;

  const AddingToCart({
    this.currentCart,
    required this.productVariantId,
    required this.deliveryType,
  });

  @override
  List<Object?> get props => [currentCart, productVariantId, deliveryType];
}

/// Loading state for updating cart item - preserves current cart
class UpdatingCartItem extends CartState {
  final Cart? currentCart;
  final int cartItemId;

  const UpdatingCartItem({this.currentCart, required this.cartItemId});

  @override
  List<Object?> get props => [currentCart, cartItemId];
}

/// Loading state for removing from cart - preserves current cart
class RemovingFromCart extends CartState {
  final Cart? currentCart;
  final int cartItemId;

  const RemovingFromCart({this.currentCart, required this.cartItemId});

  @override
  List<Object?> get props => [currentCart, cartItemId];
}

/// Loading state for clearing cart
class ClearingCart extends CartState {
  const ClearingCart();
}

/// Success state for cart operation
class CartOperationSuccess extends CartState {
  final Cart cart;
  final String message;

  const CartOperationSuccess(this.cart, this.message);

  @override
  List<Object?> get props => [cart, message];
}

/// Error state
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
