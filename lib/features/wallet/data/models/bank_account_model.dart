import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/bank_account.dart';

/// Model for bank account details from the GET /bank-detail API
class BankAccountModel extends BankAccount {
  const BankAccountModel({
    required super.id,
    required super.accountHolderName,
    required super.bankName,
    required super.accountNumber,
    required super.ifscCode,
    required super.branch,
    super.upi,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BankAccountModel.fromJson(DataMap json) {
    return BankAccountModel(
      id: json['id'] as int,
      accountHolderName: json['account_holder_name'] as String? ?? '',
      bankName: json['bank_name'] as String? ?? '',
      accountNumber: json['account_number'] as String? ?? '',
      ifscCode: json['ifsc_code'] as String? ?? '',
      branch: json['branch'] as String? ?? '',
      upi: json['upi'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  DataMap toJson() {
    return {
      'id': id,
      'account_holder_name': accountHolderName,
      'bank_name': bankName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'branch': branch,
      'upi': upi,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
