import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/repositories/cart_repository.dart';

/// Parameters for [GetCart] use case
class GetCartParams {
  final String? guestToken;
  final String deliveryType;

  const GetCartParams({this.guestToken, this.deliveryType = 'normal'});
}

/// Use case for getting current user's cart
class GetCart implements UseCase<Cart, GetCartParams> {
  final CartRepository repository;

  GetCart(this.repository);

  @override
  ResultFuture<Cart> call(GetCartParams params) async {
    return await repository.getCart(
      guestToken: params.guestToken,
      deliveryType: params.deliveryType,
    );
  }
}
