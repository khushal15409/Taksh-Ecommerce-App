import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/repositories/wishlist_repository.dart';

/// Use case for getting all wishlist items
class GetWishlist implements UseCaseNoParams<List<WishlistItem>> {
  final WishlistRepository repository;

  GetWishlist(this.repository);

  @override
  ResultFuture<List<WishlistItem>> call() async {
    return await repository.getWishlist();
  }
}
