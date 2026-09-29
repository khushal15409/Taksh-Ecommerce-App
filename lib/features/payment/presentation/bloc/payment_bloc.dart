import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/payment/domain/usecases/create_razorpay_order.dart';
import 'package:taksh_e_commerce/features/payment/domain/usecases/save_payment.dart';
import 'package:taksh_e_commerce/features/payment/domain/usecases/verify_payment.dart';
import 'package:taksh_e_commerce/features/payment/presentation/bloc/payment_event.dart';
import 'package:taksh_e_commerce/features/payment/presentation/bloc/payment_state.dart';

/// BLoC for managing payment flow
///
/// IMPORTANT: This BLoC is legacy/deprecated for new payment flows.
/// For new Razorpay payments, use CheckoutBloc's flow:
/// 1. PlaceOrder (POST /orders/place)
/// 2. InitiatePayment (POST /payments/create)
/// 3. Razorpay Checkout (handled by RazorpayService)
/// 4. VerifyPayment (POST /payments/verify)
///
/// This BLoC may be used for:
/// - Payment history/status queries
/// - Legacy payment flows (if any)
/// - Payment refunds/cancellations
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreateRazorpayOrder _createRazorpayOrder;
  final VerifyPayment _verifyPayment;
  final SavePayment _savePayment;

  PaymentBloc({
    required CreateRazorpayOrder createRazorpayOrder,
    required VerifyPayment verifyPayment,
    required SavePayment savePayment,
  })  : _createRazorpayOrder = createRazorpayOrder,
        _verifyPayment = verifyPayment,
        _savePayment = savePayment,
        super(const PaymentInitial()) {
    on<CreateRazorpayOrderEvent>(_onCreateRazorpayOrder);
    on<PaymentSuccessEvent>(_onPaymentSuccess);
    on<PaymentFailedEvent>(_onPaymentFailed);
    on<VerifyPaymentEvent>(_onVerifyPayment);
    on<ResetPaymentEvent>(_onResetPayment);
  }

  final _log = loggerWithContext({
    'feature': 'payment',
    'layer': 'presentation',
    'class': 'PaymentBloc',
  });

  /// Handle create Razorpay order event
  Future<void> _onCreateRazorpayOrder(
    CreateRazorpayOrderEvent event,
    Emitter<PaymentState> emit,
  ) async {
    _log.infoWithContext('Creating Razorpay order', {
      'orderId': event.order.id,
      'amount': event.order.totalAmount,
    });

    emit(const CreatingRazorpayOrder());

    // Parse amount from string (assuming it's in rupees)
    final amountInPaise = (double.parse(event.order.totalAmount) * 100).toInt();

    final params = CreateRazorpayOrderParams(
      amount: amountInPaise,
      currency: 'INR',
      receipt: event.order.orderNumber,
    );

    final result = await _createRazorpayOrder(params);

    result.fold(
      (failure) {
        _log.errorWithContext('Failed to create Razorpay order', {
          'error': failure.message,
        });
        emit(PaymentError(failure.message));
      },
      (paymentOrder) {
        _log.infoWithContext('Razorpay order created', {
          'razorpayOrderId': paymentOrder.razorpayOrderId,
        });
        emit(RazorpayOrderCreated(paymentOrder));
      },
    );
  }

  /// Handle payment success event
  Future<void> _onPaymentSuccess(
    PaymentSuccessEvent event,
    Emitter<PaymentState> emit,
  ) async {
    _log.infoWithContext('Payment success callback received', {
      'paymentId': event.paymentId,
      'orderId': event.orderId,
    });

    emit(PaymentSucceeded(
      paymentId: event.paymentId,
      orderId: event.orderId,
      signature: event.signature,
    ));

    // Auto-trigger verification
    add(VerifyPaymentEvent(
      paymentId: event.paymentId,
      orderId: event.orderId,
      signature: event.signature,
    ));
  }

  /// Handle payment failed event
  Future<void> _onPaymentFailed(
    PaymentFailedEvent event,
    Emitter<PaymentState> emit,
  ) async {
    _log.errorWithContext('Payment failed callback received', {
      'errorCode': event.errorCode,
      'errorMessage': event.errorMessage,
    });

    emit(PaymentFailed(
      errorCode: event.errorCode,
      errorMessage: event.errorMessage,
    ));

    // TODO: Save failed payment record
  }

  /// Handle verify payment event
  Future<void> _onVerifyPayment(
    VerifyPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const VerifyingPayment());

    final verifyParams = VerifyPaymentParams(
      orderId: event.orderId,
      paymentId: event.paymentId,
      signature: event.signature,
    );

    final result = await _verifyPayment(verifyParams);

    await result.fold(
      (failure) async {
        _log.errorWithContext('Payment verification failed', {
          'error': failure.message,
        });
        emit(PaymentError(failure.message));
      },
      (isValid) async {
        if (isValid) {
          _log.infoWithContext('Payment verified successfully', {
            'paymentId': event.paymentId,
          });

          // Save payment details
          final saveParams = SavePaymentParams(
            orderId: event.orderId,
            amount: 0, // TODO: Get from order
            razorpayOrderId: event.orderId,
            razorpayPaymentId: event.paymentId,
            razorpaySignature: event.signature,
          );

          final saveResult = await _savePayment(saveParams);

          saveResult.fold(
            (failure) {
              _log.errorWithContext('Failed to save payment', {
                'error': failure.message,
              });
              emit(PaymentError(failure.message));
            },
            (payment) {
              emit(PaymentVerified(payment));
            },
          );
        } else {
          emit(const PaymentError('Payment verification failed'));
        }
      },
    );
  }

  /// Handle reset payment event
  Future<void> _onResetPayment(
    ResetPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentInitial());
  }
}
