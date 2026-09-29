import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/domain/repositories/cart_repository.dart';

/// Use case for clearing all items from cart
class ClearCart implements UseCaseVoid<ClearCartParams> {
  final CartRepository repository;

  ClearCart(this.repository);

  @override
  ResultVoid call(ClearCartParams params) async {
    return await repository.clearCart(
      guestToken: params.guestToken,
      deliveryType: params.deliveryType,
    );
  }
}

class ClearCartParams extends Equatable {
  final String? guestToken;
  final String deliveryType;

  const ClearCartParams({
    this.guestToken,
    this.deliveryType = 'normal',
  });

  @override
  List<Object?> get props => [guestToken, deliveryType];
}
