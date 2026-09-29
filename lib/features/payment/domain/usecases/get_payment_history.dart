import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/payment/domain/entities/payment.dart';
import 'package:taksh_e_commerce/features/payment/domain/repositories/payment_repository.dart';

/// Use case for getting payment history
class GetPaymentHistory implements UseCase<List<Payment>, String> {
  final PaymentRepository repository;

  GetPaymentHistory(this.repository);

  @override
  ResultFuture<List<Payment>> call(String userId) async {
    return await repository.getPaymentHistory(userId: userId);
  }
}
