import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment_order.dart';
import 'package:taksh_e_commerce/features/payment/domain/repositories/payment_repository.dart';

/// Parameters for creating Razorpay order
class CreateRazorpayOrderParams {
  final int amount;
  final String currency;
  final String receipt;

  const CreateRazorpayOrderParams({
    required this.amount,
    required this.currency,
    required this.receipt,
  });
}

/// Use case for creating Razorpay order
class CreateRazorpayOrder
    implements UseCase<PaymentOrder, CreateRazorpayOrderParams> {
  final PaymentRepository repository;

  CreateRazorpayOrder(this.repository);

  @override
  ResultFuture<PaymentOrder> call(CreateRazorpayOrderParams params) async {
    return await repository.createRazorpayOrder(
      amount: params.amount,
      currency: params.currency,
      receipt: params.receipt,
    );
  }
}
