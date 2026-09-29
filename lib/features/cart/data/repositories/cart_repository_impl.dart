import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/network/network_info.dart';
import 'package:taksh_e_commerce/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/cart.dart';
import 'package:taksh_e_commerce/features/cart/domain/repositories/cart_repository.dart';

/// Implementation of [CartRepository]
class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Cart>> getCart({
    String? guestToken,
    String deliveryType = 'normal',
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final response = await remoteDataSource.getCart(
        guestToken: guestToken,
        deliveryType: deliveryType,
      );
      // Update cart with guest token from response
      final cart = Cart(
        items: response.cart.items,
        total: response.cart.total,
        guestToken: response.guestToken ?? response.cart.guestToken,
        extraCharges: response.cart.extraCharges,
        deliveryChargeCode: response.cart.deliveryChargeCode,
        deliveryEstimatedMinutes: response.cart.deliveryEstimatedMinutes,
        deliveryChargePrice: response.cart.deliveryChargePrice,
        totalWithDelivery: response.cart.totalWithDelivery,
      );
      return Right(cart);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> addToCart({
    required int productVariantId,
    required int qty,
    String? guestToken,
    String deliveryType = 'normal',
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final response = await remoteDataSource.addToCart(
        productVariantId: productVariantId,
        qty: qty,
        guestToken: guestToken,
        deliveryType: deliveryType,
      );
      // Update cart with guest token from response
      final cart = Cart(
        items: response.cart.items,
        total: response.cart.total,
        guestToken: response.guestToken ?? response.cart.guestToken,
        extraCharges: response.cart.extraCharges,
        deliveryChargeCode: response.cart.deliveryChargeCode,
        deliveryEstimatedMinutes: response.cart.deliveryEstimatedMinutes,
        deliveryChargePrice: response.cart.deliveryChargePrice,
        totalWithDelivery: response.cart.totalWithDelivery,
      );
      return Right(cart);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> updateCartItem({
    required int cartItemId,
    required int qty,
    String? guestToken,
    String deliveryType = 'normal',
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final response = await remoteDataSource.updateCartItem(
        cartItemId: cartItemId,
        qty: qty,
        guestToken: guestToken,
        deliveryType: deliveryType,
      );
      // Update cart with guest token from response
      final cart = Cart(
        items: response.cart.items,
        total: response.cart.total,
        guestToken: response.guestToken ?? response.cart.guestToken,
        extraCharges: response.cart.extraCharges,
        deliveryChargeCode: response.cart.deliveryChargeCode,
        deliveryEstimatedMinutes: response.cart.deliveryEstimatedMinutes,
        deliveryChargePrice: response.cart.deliveryChargePrice,
        totalWithDelivery: response.cart.totalWithDelivery,
      );
      return Right(cart);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> removeFromCart({
    required int itemId,
    String? guestToken,
    String deliveryType = 'normal',
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final response = await remoteDataSource.removeFromCart(
        itemId: itemId,
        guestToken: guestToken,
        deliveryType: deliveryType,
      );
      // Update cart with guest token from response
      final cart = Cart(
        items: response.cart.items,
        total: response.cart.total,
        guestToken: response.guestToken ?? response.cart.guestToken,
        extraCharges: response.cart.extraCharges,
        deliveryChargeCode: response.cart.deliveryChargeCode,
        deliveryEstimatedMinutes: response.cart.deliveryEstimatedMinutes,
        deliveryChargePrice: response.cart.deliveryChargePrice,
        totalWithDelivery: response.cart.totalWithDelivery,
      );
      return Right(cart);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart({
    String? guestToken,
    String deliveryType = 'normal',
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      await remoteDataSource.clearCart(
        guestToken: guestToken,
        deliveryType: deliveryType,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
