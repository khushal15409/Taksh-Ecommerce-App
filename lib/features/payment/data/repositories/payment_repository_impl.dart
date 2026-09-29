import 'package:dartz/dartz.dart';
import 'package:taksh_e_commerce/core/error/exceptions.dart';
import 'package:taksh_e_commerce/core/error/failures.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/initiate_payment_response.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment_order.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/verify_payment_response.dart';
import 'package:taksh_e_commerce/features/payment/domain/repositories/payment_repository.dart';

/// Implementation of PaymentRepository
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({
    required this.remoteDataSource,
  });

  final _log = loggerWithContext({
    'feature': 'payment',
    'layer': 'repository',
  });

  @override
  ResultFuture<PaymentOrder> createRazorpayOrder({
    required int amount,
    required String currency,
    required String receipt,
  }) async {
    try {
      _log.infoWithContext('Creating Razorpay order', {
        'amount': amount,
        'currency': currency,
      });

      final result = await remoteDataSource.createRazorpayOrder(
        amount: amount,
        currency: currency,
        receipt: receipt,
      );

      return Right(result.toEntity());
    } on ServerException catch (e) {
      _log.errorWithContext(
          'Server error creating order', {'error': e.message});
      return Left(ServerFailure(e.message));
    } catch (e) {
      _log.errorWithContext(
          'Unexpected error creating order', {'error': e.toString()});
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<bool> verifyPaymentSignature({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      _log.infoWithContext('Verifying payment signature', {
        'orderId': orderId,
        'paymentId': paymentId,
      });

      final result = await remoteDataSource.verifyPaymentSignature(
        orderId: orderId,
        paymentId: paymentId,
        signature: signature,
      );

      return Right(result);
    } on ServerException catch (e) {
      _log.errorWithContext(
          'Server error verifying signature', {'error': e.message});
      return Left(ServerFailure(e.message));
    } catch (e) {
      _log.errorWithContext(
          'Unexpected error verifying signature', {'error': e.toString()});
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<Payment> savePaymentDetails({
    required String orderId,
    required int amount,
    required String razorpayOrderId,
    String? razorpayPaymentId,
    String? razorpaySignature,
    String? errorCode,
    String? errorMessage,
  }) async {
    try {
      _log.infoWithContext('Saving payment details', {'orderId': orderId});

      final paymentData = {
        'order_id': orderId,
        'amount': amount,
        'razorpay_order_id': razorpayOrderId,
        if (razorpayPaymentId != null) 'razorpay_payment_id': razorpayPaymentId,
        if (razorpaySignature != null) 'razorpay_signature': razorpaySignature,
        if (errorCode != null) 'error_code': errorCode,
        if (errorMessage != null) 'error_message': errorMessage,
      };

      final result = await remoteDataSource.savePaymentDetails(
        paymentData: paymentData,
      );

      return Right(result.toEntity());
    } on ServerException catch (e) {
      _log.errorWithContext(
          'Server error saving payment', {'error': e.message});
      return Left(ServerFailure(e.message));
    } catch (e) {
      _log.errorWithContext(
          'Unexpected error saving payment', {'error': e.toString()});
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<Payment> getPaymentById(String paymentId) async {
    try {
      final result = await remoteDataSource.getPaymentById(paymentId);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<Payment>> getPaymentHistory({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await remoteDataSource.getPaymentHistory(
        userId: userId,
        page: page,
        limit: limit,
      );
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<Payment> processRefund({
    required String paymentId,
    required int amount,
    required String reason,
  }) async {
    try {
      final result = await remoteDataSource.processRefund(
        paymentId: paymentId,
        amount: amount,
        reason: reason,
      );
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultVoid updatePaymentStatus({
    required String paymentId,
    required String status,
  }) async {
    try {
      await remoteDataSource.updatePaymentStatus(
        paymentId: paymentId,
        status: status,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<InitiatePaymentResponse> initiatePayment({
    required String orderId,
    String gateway = 'razorpay',
  }) async {
    try {
      _log.infoWithContext('Initiating payment', {
        'orderId': orderId,
        'gateway': gateway,
      });

      final result = await remoteDataSource.initiatePayment(
        orderId: orderId,
        gateway: gateway,
      );

      return Right(result.toEntity());
    } on ServerException catch (e) {
      _log.errorWithContext(
          'Server error initiating payment', {'error': e.message});
      return Left(ServerFailure(e.message));
    } catch (e) {
      _log.errorWithContext(
          'Unexpected error initiating payment', {'error': e.toString()});
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  ResultFuture<VerifyPaymentResponse> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      _log.infoWithContext('Verifying payment', {
        'razorpayOrderId': razorpayOrderId,
        'razorpayPaymentId': razorpayPaymentId,
      });

      final result = await remoteDataSource.verifyPayment(
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
      );

      return Right(result.toEntity());
    } on ServerException catch (e) {
      _log.errorWithContext(
          'Server error verifying payment', {'error': e.message});
      return Left(ServerFailure(e.message));
    } catch (e) {
      _log.errorWithContext(
          'Unexpected error verifying payment', {'error': e.toString()});
      return Left(ServerFailure(e.toString()));
    }
  }
}
