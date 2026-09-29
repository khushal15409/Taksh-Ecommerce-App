import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';

/// Service for handling Razorpay payment gateway integration
///
/// SECURITY NOTE: This service ONLY handles the frontend Razorpay SDK integration.
/// - Razorpay PUBLIC KEY is received from backend (POST /payments/create)
/// - Razorpay SECRET KEY never exists in Flutter code
/// - Payment signature verification happens ONLY on backend
/// - Never trust payment success from client alone
class RazorpayService {
  late Razorpay _razorpay;
  Function(PaymentSuccessResponse)? _onSuccess;
  Function(PaymentFailureResponse)? _onFailure;

  final _log = loggerWithContext({
    'service': 'RazorpayService',
  });

  /// Initialize Razorpay
  void initialize({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
  }) {
    _onSuccess = onSuccess;
    _onFailure = onFailure;

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _log.info('Razorpay initialized');
  }

  /// Open Razorpay checkout
  ///
  /// IMPORTANT: All parameters except user info come from backend response.
  /// The razorpayKey parameter MUST be the public key received from
  /// POST /payments/create endpoint - NOT from .env file.
  void openCheckout({
    required String razorpayOrderId,
    required int amountInPaise,
    required String razorpayKey,
    String? orderNumber,
    String? userName,
    String? userEmail,
    String? userPhone,
  }) {
    // Validate that we received a proper Razorpay key from backend
    if (razorpayKey.isEmpty || !razorpayKey.startsWith('rzp_')) {
      _log.error('Invalid Razorpay key received from backend');
      _onFailure?.call(
        PaymentFailureResponse(
          1,
          'Payment gateway configuration error',
          {},
        ),
      );
      return;
    }

    final options = {
      'key': razorpayKey, // PUBLIC key from backend
      'amount': amountInPaise, // Amount in paise from backend
      'name': 'Taksh E-Commerce',
      'order_id': razorpayOrderId, // Razorpay order ID from backend
      'description':
          orderNumber != null ? 'Order #$orderNumber' : 'Order Payment',
      'timeout': 300, // 5 minutes in seconds
      'prefill': {
        if (userName != null) 'name': userName,
        if (userEmail != null) 'email': userEmail,
        if (userPhone != null) 'contact': userPhone,
      },
      'theme': {
        'color': '#FF6B35', // Orange theme color
      },
    };

    _log.infoWithContext('Opening Razorpay checkout', {
      'razorpayOrderId': razorpayOrderId,
      'amountInPaise': amountInPaise,
      'orderNumber': orderNumber,
      'keyPrefix': razorpayKey.substring(0, 8), // Log only prefix for security
    });

    try {
      _razorpay.open(options);
    } catch (e) {
      _log.errorWithContext('Error opening Razorpay checkout', {
        'error': e.toString(),
      });
      _onFailure?.call(
        PaymentFailureResponse(
          1,
          e.toString(),
          {},
        ),
      );
    }
  }

  /// Handle payment success
  ///
  /// CRITICAL: This callback does NOT mean payment is verified!
  /// The signature must be verified on backend before trusting this payment.
  /// This callback only provides the data needed for backend verification.
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _log.infoWithContext('Payment success callback from Razorpay', {
      'paymentId': response.paymentId,
      'orderId': response.orderId,
      'hasSignature': response.signature != null,
    });

    // WARNING: Do NOT mark order as paid here!
    // This must be verified on backend using POST /payments/verify
    _onSuccess?.call(response);
  }

  /// Handle payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    _log.errorWithContext('Payment failed', {
      'code': response.code,
      'message': response.message,
    });
    _onFailure?.call(response);
  }

  /// Handle external wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    _log.infoWithContext('External wallet selected', {
      'walletName': response.walletName,
    });
    // External wallets are handled by Razorpay
    // The success/failure callbacks will still be triggered
  }

  /// Dispose Razorpay
  void dispose() {
    _razorpay.clear();
    _log.info('Razorpay disposed');
  }
}
