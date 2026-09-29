import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/repositories/wishlist_repository.dart';

/// Use case for removing a product from the wishlist
class RemoveFromWishlist
    implements UseCaseVoid<RemoveFromWishlistParams> {
  final WishlistRepository repository;

  RemoveFromWishlist(this.repository);

  @override
  ResultVoid call(RemoveFromWishlistParams params) async {
    return await repository.removeFromWishlist(productId: params.productId);
  }
}

/// Parameters for RemoveFromWishlist use case
class RemoveFromWishlistParams extends Equatable {
  final int productId;

  const RemoveFromWishlistParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
