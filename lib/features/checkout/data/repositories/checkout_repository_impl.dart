import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';
import 'package:taksh_e_commerce/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:taksh_e_commerce/features/checkout/data/models/order_request_model.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/checkout_summary.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/delivery_option.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/order_request.dart';
import 'package:taksh_e_commerce/features/checkout/domain/entities/place_order_response.dart';
import 'package:taksh_e_commerce/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:taksh_e_commerce/features/orders/domain/entities/order.dart'
    as order_entity;

/// Implementation of CheckoutRepository
class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;

  CheckoutRepositoryImpl({required this.remoteDataSource});

  final _log = loggerWithContext({
    'feature': 'checkout',
    'layer': 'repository',
  });

  @override
  ResultFuture<CheckoutSummary> calculateCheckout({
    required List<int> cartItemIds,
    required String deliveryType,
    String? addressId,
    String? couponCode,
  }) async {
    try {
      _log.infoWithContext('Calculating checkout', {
        'itemIds': cartItemIds,
        'deliveryType': deliveryType,
      });

      final result = await remoteDataSource.calculateCheckout(
        cartItemIds: cartItemIds,
        deliveryType: deliveryType,
        addressId: addressId,
        couponCode: couponCode,
      );

      return Right(result.toEntity());
    } on ServerException catch (e) {
      _log.errorWithContext('Server error calculating checkout', {
        'error': e.message,
      });
      return Left(ServerFailure(e.message));
    } catch (e) {
      _log.errorWithContext('Unexpected error calculating checkout', {
        'error': e.toString(),
      });
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<DeliveryOption>> getDeliveryOptions({
    required String addressId,
  }) async {
    try {
      _log.infoWithContext('Getting delivery options', {
        'addressId': addressId,
      });

      final result = await remoteDataSource.getDeliveryOptions(
        addressId: addressId,
      );

      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      _log.errorWithContext('Server error getting delivery options', {
        'error': e.message,
      });
      return Left(ServerFailure(e.message));
    } catch (e) {
      _log.errorWithContext('Unexpected error getting delivery options', {
        'error': e.toString(),
      });
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> validateCheckout({
    required OrderRequest orderRequest,
  }) async {
    try {
      _log.infoWithContext('Validating checkout', {
        'items': orderRequest.cartItemIds.length,
      });

      final model = OrderRequestModel.fromEntity(orderRequest);
      final result = await remoteDataSource.validateCheckout(
        orderRequest: model.toJson(),
      );

      return Right(result);
    } on ServerException catch (e) {
      _log.errorWithContext('Server error validating checkout', {
        'error': e.message,
      });
      return Left(ServerFailure(e.message));
    } catch (e) {
      _log.errorWithContext('Unexpected error validating checkout', {
        'error': e.toString(),
      });
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<order_entity.Order> createOrder({
    required OrderRequest orderRequest,
  }) async {
    try {
      _log.infoWithContext('Creating order', {
        'items': orderRequest.cartItemIds.length,
        'total': orderRequest.expectedTotal,
      });

      final model = OrderRequestModel.fromEntity(orderRequest);
      final result = await remoteDataSource.createOrder(
        orderRequest: model.toJson(),
      );

      return Right(result);
    } on ServerException catch (e) {
      _log.errorWithContext('Server error creating order', {
        'error': e.message,
      });
      return Left(ServerFailure(e.message));
    } catch (e) {
      _log.errorWithContext('Unexpected error creating order', {
        'error': e.toString(),
      });
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<PlaceOrderResponse> placeOrder({
    required String addressId,
    required String warehouseId,
    required String deliveryType,
    required String paymentMethod,
    required String vendorId,
    required List<ExtraCharge> extraCharges,
  }) async {
    try {
      _log.infoWithContext('Placing order', {
        'addressId': addressId,
        'warehouseId': warehouseId,
        'deliveryType': deliveryType,
        'paymentMethod': paymentMethod,
        'vendorId': vendorId,
        'extraChargesCount': extraCharges.length,
      });

      final result = await remoteDataSource.placeOrder(
        addressId: addressId,
        warehouseId: warehouseId,
        deliveryType: deliveryType,
        paymentMethod: paymentMethod,
        vendorId: vendorId,
        extraCharges: extraCharges,
      );

      return Right(result.toEntity());
    } on ServerException catch (e) {
      _log.errorWithContext('Server error placing order', {'error': e.message});
      return Left(ServerFailure(e.message));
    } catch (e) {
      _log.errorWithContext('Unexpected error placing order', {
        'error': e.toString(),
      });
      return Left(ServerFailure(e.toString()));
    }
  }
}
