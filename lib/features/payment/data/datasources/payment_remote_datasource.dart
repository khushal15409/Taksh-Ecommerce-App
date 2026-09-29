import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/data/models/initiate_payment_response_model.dart';
import 'package:taksh_e_commerce/features/payment/data/models/payment_model.dart';
import 'package:taksh_e_commerce/features/payment/data/models/payment_order_model.dart';
import 'package:taksh_e_commerce/features/payment/data/models/verify_payment_response_model.dart';

/// Remote data source contract for payment operations
abstract class PaymentRemoteDataSource {
  /// Create Razorpay order (legacy method)
  Future<PaymentOrderModel> createRazorpayOrder({
    required int amount,
    required String currency,
    required String receipt,
  });

  /// Initiate payment (new flow - after placing order)
  /// This creates a Razorpay order linked to the placed order_id
  Future<InitiatePaymentResponseModel> initiatePayment({
    required String orderId,
    String gateway = 'razorpay',
  });

  /// Verify payment signature (updated for new flow)
  Future<VerifyPaymentResponseModel> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  });

  /// Legacy verify payment signature
  Future<bool> verifyPaymentSignature({
    required String orderId,
    required String paymentId,
    required String signature,
  });

  /// Save payment details
  Future<PaymentModel> savePaymentDetails({
    required DataMap paymentData,
  });

  /// Get payment by ID
  Future<PaymentModel> getPaymentById(String paymentId);

  /// Get payment history
  Future<List<PaymentModel>> getPaymentHistory({
    required String userId,
    int page = 1,
    int limit = 20,
  });

  /// Process refund
  Future<PaymentModel> processRefund({
    required String paymentId,
    required int amount,
    required String reason,
  });

  /// Update payment status
  Future<void> updatePaymentStatus({
    required String paymentId,
    required String status,
  });
}
