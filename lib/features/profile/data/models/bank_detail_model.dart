import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/bank_detail.dart';

/// Model class for bank detail request parameters
class BankDetailParamsModel extends BankDetailParams {
  const BankDetailParamsModel({
    required super.accountHolderName,
    required super.bankName,
    required super.accountNumber,
    required super.ifscCode,
    required super.branchName,
  });

  /// Create from entity
  factory BankDetailParamsModel.fromEntity(BankDetailParams params) {
    return BankDetailParamsModel(
      accountHolderName: params.accountHolderName,
      bankName: params.bankName,
      accountNumber: params.accountNumber,
      ifscCode: params.ifscCode,
      branchName: params.branchName,
    );
  }

  /// Convert to form data for API submission
  FormData toFormData() {
    return FormData.fromMap({
      'account_holder_name': accountHolderName,
      'bank_name': bankName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'branch': branchName,
    });
  }

  /// Convert to JSON
  DataMap toJson() {
    return {
      'account_holder_name': accountHolderName,
      'bank_name': bankName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'branch': branchName,
    };
  }
}

/// Model class for bank detail response
class BankDetailModel extends BankDetail {
  const BankDetailModel({
    required super.id,
    required super.accountHolderName,
    required super.bankName,
    required super.accountNumber,
    required super.ifscCode,
    required super.branchName,
    required super.createdAt,
    super.updatedAt,
  });

  /// Create from JSON
  factory BankDetailModel.fromJson(DataMap json) {
    return BankDetailModel(
      id: json['id'] as int,
      accountHolderName: json['account_holder_name'] as String,
      bankName: json['bank_name'] as String,
      accountNumber: json['account_number'] as String,
      ifscCode: json['ifsc_code'] as String,
      branchName: json['branch'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
    );
  }

  /// Convert to JSON
  DataMap toJson() {
    return {
      'id': id,
      'account_holder_name': accountHolderName,
      'bank_name': bankName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'branch': branchName,
      'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}
