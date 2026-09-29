import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/initiate_payment_response.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment_order.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/verify_payment_response.dart';

/// Repository contract for payment operations
abstract class PaymentRepository {
  /// Create Razorpay order (legacy method)
  ResultFuture<PaymentOrder> createRazorpayOrder({
    required int amount,
    required String currency,
    required String receipt,
  });

  /// Initiate payment (new flow - after placing order)
  /// This creates a Razorpay order linked to the placed order_id
  ResultFuture<InitiatePaymentResponse> initiatePayment({
    required String orderId,
    String gateway = 'razorpay',
  });

  /// Verify payment (new flow)
  ResultFuture<VerifyPaymentResponse> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  });

  /// Verify payment signature (legacy method)
  ResultFuture<bool> verifyPaymentSignature({
    required String orderId,
    required String paymentId,
    required String signature,
  });

  /// Save payment details
  ResultFuture<Payment> savePaymentDetails({
    required String orderId,
    required int amount,
    required String razorpayOrderId,
    String? razorpayPaymentId,
    String? razorpaySignature,
    String? errorCode,
    String? errorMessage,
  });

  /// Get payment by ID
  ResultFuture<Payment> getPaymentById(String paymentId);

  /// Get payment history for user
  ResultFuture<List<Payment>> getPaymentHistory({
    required String userId,
    int page = 1,
    int limit = 20,
  });

  /// Process refund
  ResultFuture<Payment> processRefund({
    required String paymentId,
    required int amount,
    required String reason,
  });

  /// Update payment status
  ResultVoid updatePaymentStatus({
    required String paymentId,
    required String status,
  });
}
