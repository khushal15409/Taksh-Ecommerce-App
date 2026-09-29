import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/repositories/cart_repository.dart';

/// Use case for updating cart item quantity
class UpdateCartItem implements UseCase<Cart, UpdateCartItemParams> {
  final CartRepository repository;

  UpdateCartItem(this.repository);

  @override
  ResultFuture<Cart> call(UpdateCartItemParams params) async {
    return await repository.updateCartItem(
      cartItemId: params.cartItemId,
      qty: params.qty,
      guestToken: params.guestToken,
      deliveryType: params.deliveryType,
    );
  }
}

/// Parameters for UpdateCartItem use case
class UpdateCartItemParams extends Equatable {
  final int cartItemId;
  final int qty;
  final String? guestToken;
  final String deliveryType;

  const UpdateCartItemParams({
    required this.cartItemId,
    required this.qty,
    this.guestToken,
    this.deliveryType = 'normal',
  });

  @override
  List<Object?> get props => [cartItemId, qty, guestToken, deliveryType];
}
