import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/usecases/add_to_wishlist.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/usecases/get_wishlist.dart';
import 'package:taksh_e_commerce/features/wishlist/domain/usecases/remove_from_wishlist.dart';
import 'package:taksh_e_commerce/features/wishlist/presentation/cubit/wishlist_state.dart';

/// Cubit for managing wishlist state.
///
/// Registered as a lazy singleton so that the same instance is shared
/// between the product-details page (heart-icon toggle) and the
/// dedicated wishlist page (full list display).
class WishlistCubit extends Cubit<WishlistState> {
  final GetWishlist getWishlist;
  final AddToWishlist addToWishlist;
  final RemoveFromWishlist removeFromWishlist;

  /// In-memory cache of wishlisted product IDs for O(1) lookups.
  final Set<int> _wishlistedProductIds = {};

  /// Last known items for preserving data during loading states.
  List<WishlistItem>? _lastKnownItems;

  WishlistCubit({
    required this.getWishlist,
    required this.addToWishlist,
    required this.removeFromWishlist,
  }) : super(const WishlistInitial());

  // ─── Public helpers ─────────────────────────────────────────────────

  /// Whether a product is currently in the wishlist.
  bool isWishlisted(int productId) => _wishlistedProductIds.contains(productId);

  /// The last known wishlist items (useful for UI during loading).
  List<WishlistItem>? get lastKnownItems => _lastKnownItems;

  /// The number of items in the wishlist.
  int get itemCount => _wishlistedProductIds.length;

  // ─── Fetch ──────────────────────────────────────────────────────────

  /// Fetch the full wishlist from the server.
  Future<void> fetchWishlist() async {
    emit(WishlistLoading(previousItems: _lastKnownItems));

    final result = await getWishlist();

    if (isClosed) return;

    result.fold(
      (failure) => emit(WishlistError(failure.message)),
      (items) {
        _lastKnownItems = items;
        _wishlistedProductIds
          ..clear()
          ..addAll(items.map((e) => e.productId));
        emit(WishlistLoaded(items));
      },
    );
  }

  // ─── Add ────────────────────────────────────────────────────────────

  /// Add a product to the wishlist.
  Future<void> addProductToWishlist({required int productId}) async {
    // Optimistic local update
    _wishlistedProductIds.add(productId);
    emit(AddingToWishlist(
      currentItems: _lastKnownItems,
      productId: productId,
    ));

    final result = await addToWishlist(
      AddToWishlistParams(productId: productId),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        // Revert optimistic update
        _wishlistedProductIds.remove(productId);
        emit(WishlistError(failure.message));
        // Restore previous state
        if (_lastKnownItems != null) {
          emit(WishlistLoaded(_lastKnownItems!));
        }
      },
      (_) {
        // Refresh the full list to get complete data
        _refreshAfterOperation('Added to wishlist');
      },
    );
  }

  // ─── Remove ─────────────────────────────────────────────────────────

  /// Remove a product from the wishlist.
  Future<void> removeProductFromWishlist({required int productId}) async {
    // Optimistic local update
    _wishlistedProductIds.remove(productId);
    final optimisticItems =
        _lastKnownItems?.where((e) => e.productId != productId).toList();

    emit(RemovingFromWishlist(
      currentItems: optimisticItems,
      productId: productId,
    ));

    final result = await removeFromWishlist(
      RemoveFromWishlistParams(productId: productId),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        // Revert optimistic update
        _wishlistedProductIds.add(productId);
        emit(WishlistError(failure.message));
        // Restore previous state
        if (_lastKnownItems != null) {
          emit(WishlistLoaded(_lastKnownItems!));
        }
      },
      (_) {
        // Update local cache immediately (optimistic was correct)
        _lastKnownItems = optimisticItems;
        _refreshAfterOperation('Removed from wishlist');
      },
    );
  }

  // ─── Toggle ─────────────────────────────────────────────────────────

  /// Toggle a product's wishlist status (add if absent, remove if present).
  Future<void> toggleWishlist({required int productId}) async {
    if (isWishlisted(productId)) {
      await removeProductFromWishlist(productId: productId);
    } else {
      await addProductToWishlist(productId: productId);
    }
  }

  // ─── Internal ───────────────────────────────────────────────────────

  /// Refresh the wishlist after a successful add/remove and emit success.
  Future<void> _refreshAfterOperation(String message) async {
    final result = await getWishlist();

    if (isClosed) return;

    result.fold(
      (failure) {
        // Even if refresh fails, the operation succeeded – emit with cached data
        final items = _lastKnownItems ?? [];
        emit(WishlistOperationSuccess(items, message));
        emit(WishlistLoaded(items));
      },
      (items) {
        _lastKnownItems = items;
        _wishlistedProductIds
          ..clear()
          ..addAll(items.map((e) => e.productId));
        emit(WishlistOperationSuccess(items, message));
        emit(WishlistLoaded(items));
      },
    );
  }
}
