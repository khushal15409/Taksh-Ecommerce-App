import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:taksh_e_commerce/features/payment/data/models/initiate_payment_response_model.dart';
import 'package:taksh_e_commerce/features/payment/data/models/payment_model.dart';
import 'package:taksh_e_commerce/features/payment/data/models/payment_order_model.dart';
import 'package:taksh_e_commerce/features/payment/data/models/verify_payment_response_model.dart';

/// Mock implementation of PaymentRemoteDataSource for development/testing
class PaymentMockDataSource implements PaymentRemoteDataSource {
  final _log = loggerWithContext({
    'feature': 'payment',
    'layer': 'datasource',
    'type': 'mock',
  });

  @override
  Future<PaymentOrderModel> createRazorpayOrder({
    required int amount,
    required String currency,
    required String receipt,
  }) async {
    _log.infoWithContext('Creating Razorpay order', {
      'amount': amount,
      'currency': currency,
      'receipt': receipt,
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Generate mock Razorpay order ID
    final razorpayOrderId = 'order_${DateTime.now().millisecondsSinceEpoch}';

    return PaymentOrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      razorpayOrderId: razorpayOrderId,
      amount: amount,
      currency: currency,
      receipt: receipt,
      status: 'created',
      attempts: 0,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<bool> verifyPaymentSignature({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    _log.infoWithContext('Verifying payment signature', {
      'orderId': orderId,
      'paymentId': paymentId,
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock verification - always returns true
    return true;
  }

  @override
  Future<PaymentModel> savePaymentDetails({
    required DataMap paymentData,
  }) async {
    _log.infoWithContext('Saving payment details', paymentData);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();

    return PaymentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderId: paymentData['order_id'] as String,
      amount: paymentData['amount'] as int,
      currency: paymentData['currency'] as String? ?? 'INR',
      statusString:
          paymentData['razorpay_payment_id'] != null ? 'success' : 'failed',
      methodString: 'razorpay',
      razorpayPaymentId: paymentData['razorpay_payment_id'] as String?,
      razorpayOrderId: paymentData['razorpay_order_id'] as String,
      razorpaySignature: paymentData['razorpay_signature'] as String?,
      errorCode: paymentData['error_code'] as String?,
      errorMessage: paymentData['error_message'] as String?,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<PaymentModel> getPaymentById(String paymentId) async {
    _log.infoWithContext('Getting payment by ID', {'paymentId': paymentId});

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();

    return PaymentModel(
      id: paymentId,
      orderId: '12345',
      amount: 15000,
      currency: 'INR',
      statusString: 'success',
      methodString: 'razorpay',
      razorpayPaymentId: 'pay_mock123',
      razorpayOrderId: 'order_mock123',
      razorpaySignature: 'sig_mock123',
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<List<PaymentModel>> getPaymentHistory({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    _log.infoWithContext('Getting payment history', {
      'userId': userId,
      'page': page,
      'limit': limit,
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return empty list for mock
    return [];
  }

  @override
  Future<PaymentModel> processRefund({
    required String paymentId,
    required int amount,
    required String reason,
  }) async {
    _log.infoWithContext('Processing refund', {
      'paymentId': paymentId,
      'amount': amount,
      'reason': reason,
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final now = DateTime.now();

    return PaymentModel(
      id: paymentId,
      orderId: '12345',
      amount: amount,
      currency: 'INR',
      statusString: 'refunded',
      methodString: 'razorpay',
      createdAt: now.subtract(const Duration(days: 1)),
      updatedAt: now,
    );
  }

  @override
  Future<void> updatePaymentStatus({
    required String paymentId,
    required String status,
  }) async {
    _log.infoWithContext('Updating payment status', {
      'paymentId': paymentId,
      'status': status,
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<InitiatePaymentResponseModel> initiatePayment({
    required String orderId,
    String gateway = 'razorpay',
  }) async {
    _log.infoWithContext('Initiating payment', {
      'orderId': orderId,
      'gateway': gateway,
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Generate mock Razorpay order ID
    final razorpayOrderId = 'order_${DateTime.now().millisecondsSinceEpoch}';

    return InitiatePaymentResponseModel(
      razorpayOrderId: razorpayOrderId,
      orderId: orderId,
      amount: 15000, // Mock amount in paise
      currency: 'INR',
      receipt: 'receipt_$orderId',
      razorpayKey: 'rzp_test_mock_key',
      status: 'success',
      message: 'Payment initiated successfully',
    );
  }

  @override
  Future<VerifyPaymentResponseModel> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    _log.infoWithContext('Verifying payment', {
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    return const VerifyPaymentResponseModel(
      status: 'success',
      message: 'Payment verified successfully',
      verified: true,
    );
  }
}
