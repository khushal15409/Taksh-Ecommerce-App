import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/repositories/cart_repository.dart';

/// Use case for adding item to cart
class AddToCart implements UseCase<Cart, AddToCartParams> {
  final CartRepository repository;

  AddToCart(this.repository);

  @override
  ResultFuture<Cart> call(AddToCartParams params) async {
    return await repository.addToCart(
      productVariantId: params.productVariantId,
      qty: params.qty,
      guestToken: params.guestToken,
      deliveryType: params.deliveryType,
    );
  }
}

/// Parameters for AddToCart use case
class AddToCartParams extends Equatable {
  final int productVariantId;
  final int qty;
  final String? guestToken;
  final String deliveryType;

  const AddToCartParams({
    required this.productVariantId,
    required this.qty,
    this.guestToken,
    this.deliveryType = 'normal',
  });

  @override
  List<Object?> get props => [productVariantId, qty, guestToken, deliveryType];
}
