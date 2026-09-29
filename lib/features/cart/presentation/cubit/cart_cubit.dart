import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taksh_e_commerce/core/utils/secure_store.dart';
import 'package:taksh_e_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:taksh_e_commerce/features/cart/data/models/cart_model.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:taksh_e_commerce/features/cart/domain/usecases/add_to_cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/usecases/clear_cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/usecases/get_cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/usecases/update_cart_item.dart';
import 'package:taksh_e_commerce/features/cart/presentation/cubit/cart_state.dart';

/// Cubit for managing cart state.
///
/// The backend exposes separate carts per delivery mode, so this cubit keeps
/// quick (`30_min`) and standard (`normal`) buckets internally. It still emits
/// a merged cart so app-wide consumers like the badge and add-to-cart widgets
/// keep working without needing separate state trees.
class CartCubit extends Cubit<CartState> {
  final GetCart getCart;
  final AddToCart addToCart;
  final UpdateCartItem updateCartItem;
  final RemoveFromCart removeFromCart;
  final ClearCart clearCart;
  final SecureStore secureStore;
  final SharedPreferences sharedPreferences;

  static const _legacyCartCacheKey = 'cached_cart';
  static const _standardCartCacheKey = 'cached_cart_standard';
  static const _quickCartCacheKey = 'cached_cart_quick';

  static const deliveryTypeStandard = 'normal';
  static const deliveryTypeExpress = '30_min';

  final Map<String, Cart> _cartsByDeliveryType = {
    deliveryTypeStandard: Cart.empty(),
    deliveryTypeExpress: Cart.empty(),
  };

  String _activeDeliveryType = deliveryTypeStandard;
  String? _guestToken;
  Cart? _lastKnownCart;

  CartCubit({
    required this.getCart,
    required this.addToCart,
    required this.updateCartItem,
    required this.removeFromCart,
    required this.clearCart,
    required this.secureStore,
    required this.sharedPreferences,
  }) : super(const CartInitial()) {
    _loadCachedCart();
  }

  String? get guestToken => _guestToken;

  String get activeDeliveryType => _activeDeliveryType;

  Cart? get lastKnownCart => _lastKnownCart;

  Cart get standardCart => cartForDeliveryType(deliveryTypeStandard);

  Cart get quickCart => cartForDeliveryType(deliveryTypeExpress);

  Cart cartForDeliveryType(String deliveryType) {
    final normalizedDeliveryType = _normalizeDeliveryType(deliveryType);
    return _cartsByDeliveryType[normalizedDeliveryType] ?? Cart.empty();
  }

  static bool matchesDeliveryType(CartItem item, String deliveryType) {
    final isExpress = deliveryType == deliveryTypeExpress;
    return isExpress ? item.isExpress30 == true : item.isExpress30 != true;
  }

  static String deliveryTypeForItem(CartItem item) =>
      item.isExpress30 == true ? deliveryTypeExpress : deliveryTypeStandard;

  void _loadCachedCart() {
    if (isClosed) return;

    var hasCachedCart = _restoreCachedCartForType(deliveryTypeStandard);
    hasCachedCart = _restoreCachedCartForType(deliveryTypeExpress) ||
        hasCachedCart;

    if (!hasCachedCart) {
      final raw = sharedPreferences.getString(_legacyCartCacheKey);
      if (raw != null) {
        try {
          final json = jsonDecode(raw) as Map<String, dynamic>;
          final cart = CartModel.fromJson(json);
          _storeCart(
            _normalizeDeliveryType(cart.deliveryChargeCode),
            cart,
            persist: true,
          );
          hasCachedCart = true;
        } catch (_) {
          // Ignore corrupted legacy cache. Remote fetch will refresh it.
        }
      }
    }

    _refreshMergedCart();
    if (hasCachedCart && _lastKnownCart != null && _lastKnownCart!.isNotEmpty) {
      emit(CartLoaded(_lastKnownCart!));
    }
  }

  bool _restoreCachedCartForType(String deliveryType) {
    final raw = sharedPreferences.getString(_cacheKeyForDeliveryType(deliveryType));
    if (raw == null) return false;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final cart = CartModel.fromJson(json);
      _storeCart(deliveryType, cart, persist: false);
      return true;
    } catch (_) {
      return false;
    }
  }

  void _cacheCart(String deliveryType, Cart cart) {
    try {
      final model = cart is CartModel
          ? cart
          : CartModel(
              itemModels: cart.items
                  .map(
                    (item) => CartItemModel(
                      id: item.id,
                      productVariantId: item.productVariantId,
                      productName: item.productName,
                      sku: item.sku,
                      price: item.price,
                      qty: item.qty,
                      total: item.total,
                      image: item.image,
                      productId: item.productId,
                      isExpress30: item.isExpress30,
                    ),
                  )
                  .toList(),
              total: cart.total,
              guestToken: cart.guestToken,
              extraCharges: cart.extraCharges,
              deliveryChargeCode: cart.deliveryChargeCode,
              deliveryEstimatedMinutes: cart.deliveryEstimatedMinutes,
              deliveryChargePrice: cart.deliveryChargePrice,
              totalWithDelivery: cart.totalWithDelivery,
            );

      sharedPreferences.remove(_legacyCartCacheKey);
      sharedPreferences.setString(
        _cacheKeyForDeliveryType(deliveryType),
        jsonEncode(model.toJson()),
      );
    } catch (_) {
      // Best-effort caching only.
    }
  }

  void _clearCartCache({String? deliveryType}) {
    if (deliveryType == null) {
      sharedPreferences.remove(_legacyCartCacheKey);
      sharedPreferences.remove(_standardCartCacheKey);
      sharedPreferences.remove(_quickCartCacheKey);
      return;
    }

    sharedPreferences.remove(_cacheKeyForDeliveryType(deliveryType));
  }

  bool _isExpressType(String deliveryType) =>
      deliveryType == deliveryTypeExpress;

  String _normalizeDeliveryType(String? deliveryType) =>
      deliveryType == deliveryTypeExpress
      ? deliveryTypeExpress
      : deliveryTypeStandard;

  String _cacheKeyForDeliveryType(String deliveryType) =>
      _normalizeDeliveryType(deliveryType) == deliveryTypeExpress
      ? _quickCartCacheKey
      : _standardCartCacheKey;

  String? _deliveryTypeForCartItemId(int cartItemId) {
    for (final entry in _cartsByDeliveryType.entries) {
      final hasItem = entry.value.items.any((item) => item.id == cartItemId);
      if (hasItem) {
        return entry.key;
      }
    }

    return null;
  }

  CartItem _copyCartItemWithDeliveryType(CartItem item, String deliveryType) {
    final isExpress = _isExpressType(deliveryType);
    if (item.isExpress30 == isExpress) {
      return item;
    }

    return CartItem(
      id: item.id,
      productVariantId: item.productVariantId,
      productName: item.productName,
      sku: item.sku,
      price: item.price,
      qty: item.qty,
      total: item.total,
      image: item.image,
      productId: item.productId,
      isExpress30: isExpress,
    );
  }

  Cart _normalizeCartForDeliveryType(Cart cart, String deliveryType) {
    final resolvedDeliveryType = _isExpressType(cart.deliveryChargeCode ?? '')
        ? deliveryTypeExpress
        : _normalizeDeliveryType(deliveryType);

    final items = cart.items
        .map((item) => _copyCartItemWithDeliveryType(item, resolvedDeliveryType))
        .toList();

    return Cart(
      items: items,
      total: cart.total,
      guestToken: cart.guestToken ?? _guestToken,
      extraCharges: cart.extraCharges,
      deliveryChargeCode:
          cart.deliveryChargeCode ?? (items.isNotEmpty ? resolvedDeliveryType : null),
      deliveryEstimatedMinutes: cart.deliveryEstimatedMinutes,
      deliveryChargePrice: cart.deliveryChargePrice,
      totalWithDelivery: cart.totalWithDelivery,
    );
  }

  Cart _metadataCartForMergedState() {
    final activeCart = cartForDeliveryType(_activeDeliveryType);
    if (activeCart.isNotEmpty) {
      return activeCart;
    }
    if (quickCart.isNotEmpty) {
      return quickCart;
    }
    if (standardCart.isNotEmpty) {
      return standardCart;
    }
    return activeCart;
  }

  Cart _buildMergedCart() {
    final mergedItems = <CartItem>[
      ...quickCart.items,
      ...standardCart.items,
    ];
    final total = quickCart.total + standardCart.total;
    final detailCart = _metadataCartForMergedState();
    final totalWithDelivery =
        (quickCart.totalWithDelivery ?? quickCart.total) +
        (standardCart.totalWithDelivery ?? standardCart.total);

    return Cart(
      items: mergedItems,
      total: total,
      guestToken: _guestToken ??
          detailCart.guestToken ??
          quickCart.guestToken ??
          standardCart.guestToken,
      extraCharges: detailCart.extraCharges,
      deliveryChargeCode: detailCart.deliveryChargeCode,
      deliveryEstimatedMinutes: detailCart.deliveryEstimatedMinutes,
      deliveryChargePrice: detailCart.deliveryChargePrice,
      totalWithDelivery: mergedItems.isNotEmpty ? totalWithDelivery : null,
    );
  }

  void _refreshMergedCart() {
    _lastKnownCart = _buildMergedCart();
  }

  void _saveGuestTokenIfPresent(String? token) {
    if (token == null) return;
    _guestToken = token;
    secureStore.saveGuestToken(token);
  }

  void _storeCart(
    String deliveryType,
    Cart cart, {
    bool persist = true,
  }) {
    final normalizedDeliveryType = _normalizeDeliveryType(deliveryType);
    final normalizedCart = _normalizeCartForDeliveryType(
      cart,
      normalizedDeliveryType,
    );
    _cartsByDeliveryType[normalizedDeliveryType] = normalizedCart;
    _refreshMergedCart();
    if (persist) {
      _cacheCart(normalizedDeliveryType, normalizedCart);
    }
  }

  Future<String?> _fetchAndStoreDeliveryBucket(
    String deliveryType, {
    String? guestToken,
  }) async {
    final result = await getCart(
      GetCartParams(
        guestToken: guestToken,
        deliveryType: _normalizeDeliveryType(deliveryType),
      ),
    );

    if (isClosed) return 'closed';

    String? failureMessage;
    result.fold((failure) {
      failureMessage = failure.message;
    }, (cart) {
      _saveGuestTokenIfPresent(cart.guestToken);
      _storeCart(deliveryType, cart);
    });

    return failureMessage;
  }

  Future<void> setGuestToken(String? token) async {
    _guestToken = token;
    if (token != null) {
      await secureStore.saveGuestToken(token);
    } else {
      await secureStore.clearGuestToken();
    }
  }

  Future<void> loadPersistedGuestToken() async {
    _guestToken = await secureStore.getGuestToken();
  }

  Future<void> fetchCart({
    bool withGuestToken = false,
    String? deliveryType,
  }) async {
    if (isClosed) return;
    emit(CartLoading(previousCart: _lastKnownCart));

    final token = withGuestToken ? _guestToken : null;
    final resolvedDeliveryType =
        _normalizeDeliveryType(deliveryType ?? _activeDeliveryType);
    _activeDeliveryType = resolvedDeliveryType;

    final failureMessage = await _fetchAndStoreDeliveryBucket(
      resolvedDeliveryType,
      guestToken: token,
    );

    if (isClosed) return;

    if (failureMessage != null && failureMessage != 'closed') {
      emit(CartError(failureMessage));
      return;
    }

    emit(CartLoaded(_lastKnownCart ?? Cart.empty()));
  }

  Future<void> fetchAllCarts({bool withGuestToken = false}) async {
    if (isClosed) return;
    emit(CartLoading(previousCart: _lastKnownCart));

    final token = withGuestToken ? _guestToken : null;
    final standardFailure = await _fetchAndStoreDeliveryBucket(
      deliveryTypeStandard,
      guestToken: token,
    );
    if (isClosed) return;

    final quickFailure = await _fetchAndStoreDeliveryBucket(
      deliveryTypeExpress,
      guestToken: token,
    );
    if (isClosed) return;

    if (_lastKnownCart != null &&
        (standardFailure == null || quickFailure == null)) {
      emit(CartLoaded(_lastKnownCart!));
      return;
    }

    final failures = [standardFailure, quickFailure]
        .whereType<String>()
        .where((message) => message != 'closed')
        .toList();
    if (failures.isNotEmpty) {
      emit(CartError(failures.first));
      return;
    }

    emit(CartLoaded(_lastKnownCart ?? Cart.empty()));
  }

  Future<void> syncGuestCartAfterLogin() async {
    await fetchAllCarts(withGuestToken: true);
    await setGuestToken(null);
  }

  Future<void> addItemToCart({
    required int productVariantId,
    required int qty,
    String? deliveryType,
  }) async {
    if (isClosed) return;

    final resolvedDeliveryType =
        _normalizeDeliveryType(deliveryType ?? _activeDeliveryType);
    _activeDeliveryType = resolvedDeliveryType;

    emit(
      AddingToCart(
        currentCart: _lastKnownCart,
        productVariantId: productVariantId,
        deliveryType: resolvedDeliveryType,
      ),
    );

    final result = await addToCart(
      AddToCartParams(
        productVariantId: productVariantId,
        qty: qty,
        guestToken: _guestToken,
        deliveryType: resolvedDeliveryType,
      ),
    );

    if (isClosed) return;

    await result.fold((failure) async {
      emit(CartError(failure.message));
    }, (cart) async {
      _saveGuestTokenIfPresent(cart.guestToken);
      final refreshFailure = await _fetchAndStoreDeliveryBucket(
        resolvedDeliveryType,
      );
      if (isClosed) return;
      if (refreshFailure != null && refreshFailure != 'closed') {
        emit(CartError(refreshFailure));
        return;
      }

      final mergedCart = _lastKnownCart ?? Cart.empty();
      emit(CartOperationSuccess(mergedCart, 'Item added to cart'));
      emit(CartLoaded(mergedCart));
    });
  }

  Future<void> updateItem({
    required int cartItemId,
    required int qty,
    String? deliveryType,
  }) async {
    if (isClosed) return;
    emit(UpdatingCartItem(currentCart: _lastKnownCart, cartItemId: cartItemId));

    final resolvedDeliveryType = _normalizeDeliveryType(
      deliveryType ?? _deliveryTypeForCartItemId(cartItemId) ?? _activeDeliveryType,
    );
    _activeDeliveryType = resolvedDeliveryType;

    final result = await updateCartItem(
      UpdateCartItemParams(
        cartItemId: cartItemId,
        qty: qty,
        guestToken: _guestToken,
        deliveryType: resolvedDeliveryType,
      ),
    );

    if (isClosed) return;

    await result.fold((failure) async {
      emit(CartError(failure.message));
    }, (cart) async {
      _saveGuestTokenIfPresent(cart.guestToken);
      final refreshFailure = await _fetchAndStoreDeliveryBucket(
        resolvedDeliveryType,
      );
      if (isClosed) return;
      if (refreshFailure != null && refreshFailure != 'closed') {
        emit(CartError(refreshFailure));
        return;
      }

      final mergedCart = _lastKnownCart ?? Cart.empty();
      emit(CartOperationSuccess(mergedCart, 'Cart updated'));
      emit(CartLoaded(mergedCart));
    });
  }

  Future<void> removeItem(int itemId, {String? deliveryType}) async {
    if (isClosed) return;
    emit(RemovingFromCart(currentCart: _lastKnownCart, cartItemId: itemId));

    final resolvedDeliveryType = _normalizeDeliveryType(
      deliveryType ?? _deliveryTypeForCartItemId(itemId) ?? _activeDeliveryType,
    );
    _activeDeliveryType = resolvedDeliveryType;

    final result = await removeFromCart(
      RemoveFromCartParams(
        itemId: itemId,
        guestToken: _guestToken,
        deliveryType: resolvedDeliveryType,
      ),
    );

    if (isClosed) return;

    await result.fold((failure) async {
      emit(CartError(failure.message));
    }, (cart) async {
      _saveGuestTokenIfPresent(cart.guestToken);
      final refreshFailure = await _fetchAndStoreDeliveryBucket(
        resolvedDeliveryType,
      );
      if (isClosed) return;
      if (refreshFailure != null && refreshFailure != 'closed') {
        emit(CartError(refreshFailure));
        return;
      }

      final mergedCart = _lastKnownCart ?? Cart.empty();
      emit(CartOperationSuccess(mergedCart, 'Item removed'));
      emit(CartLoaded(mergedCart));
    });
  }

  Future<void> clearAllItems({String? deliveryType}) async {
    if (isClosed) return;
    emit(const ClearingCart());

    final resolvedDeliveryType =
        _normalizeDeliveryType(deliveryType ?? _activeDeliveryType);
    _activeDeliveryType = resolvedDeliveryType;

    final result = await clearCart(
      ClearCartParams(
        guestToken: _guestToken,
        deliveryType: resolvedDeliveryType,
      ),
    );

    if (isClosed) return;

    result.fold((failure) => emit(CartError(failure.message)), (_) {
      _cartsByDeliveryType[resolvedDeliveryType] = Cart.empty();
      _clearCartCache(deliveryType: resolvedDeliveryType);
      _refreshMergedCart();

      final mergedCart = _lastKnownCart ?? Cart.empty();
      emit(CartOperationSuccess(mergedCart, 'Cart cleared'));
      emit(CartLoaded(mergedCart));
    });
  }
}
