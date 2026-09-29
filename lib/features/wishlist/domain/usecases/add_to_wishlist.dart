import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/repositories/wishlist_repository.dart';

/// Use case for adding a product to the wishlist
class AddToWishlist implements UseCase<WishlistItem, AddToWishlistParams> {
  final WishlistRepository repository;

  AddToWishlist(this.repository);

  @override
  ResultFuture<WishlistItem> call(AddToWishlistParams params) async {
    return await repository.addToWishlist(productId: params.productId);
  }
}

/// Parameters for AddToWishlist use case
class AddToWishlistParams extends Equatable {
  final int productId;

  const AddToWishlistParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
