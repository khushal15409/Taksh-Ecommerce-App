import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/repositories/cart_repository.dart';

/// Use case for removing item from cart
class RemoveFromCart implements UseCase<Cart, RemoveFromCartParams> {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  @override
  ResultFuture<Cart> call(RemoveFromCartParams params) async {
    return await repository.removeFromCart(
      itemId: params.itemId,
      guestToken: params.guestToken,
      deliveryType: params.deliveryType,
    );
  }
}

/// Parameters for RemoveFromCart use case
class RemoveFromCartParams extends Equatable {
  final int itemId;
  final String? guestToken;
  final String deliveryType;

  const RemoveFromCartParams({
    required this.itemId,
    this.guestToken,
    this.deliveryType = 'normal',
  });

  @override
  List<Object?> get props => [itemId, guestToken, deliveryType];
}
