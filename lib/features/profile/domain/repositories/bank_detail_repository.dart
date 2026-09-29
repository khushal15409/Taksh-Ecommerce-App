import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/bank_detail.dart';

/// Repository interface for bank detail operations
abstract class BankDetailRepository {
  /// Save bank account details
  ResultFuture<BankDetail> saveBankDetail(BankDetailParams params);
}
