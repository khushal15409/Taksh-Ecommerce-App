import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/wallet/data/models/bank_account_model.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/withdrawal_response.dart';

/// Model for the withdrawal API response
class WithdrawalResponseModel extends WithdrawalResponse {
  const WithdrawalResponseModel({
    required super.id,
    required super.userId,
    required super.bankDetailId,
    required super.points,
    required super.amountRupees,
    required super.status,
    super.rejectionReason,
    super.processedAt,
    required super.createdAt,
    required super.updatedAt,
    super.bankDetail,
  });

  factory WithdrawalResponseModel.fromJson(DataMap json) {
    return WithdrawalResponseModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      bankDetailId: json['bank_detail_id'] as int,
      points: _toInt(json['points']),
      amountRupees: _toInt(json['amount_rupees']),
      status: json['status'] as String? ?? 'pending',
      rejectionReason: json['rejection_reason'] as String?,
      processedAt: json['processed_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      bankDetail: json['bank_detail'] != null
          ? BankAccountModel.fromJson(json['bank_detail'] as DataMap)
          : null,
    );
  }

  DataMap toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bank_detail_id': bankDetailId,
      'points': points,
      'amount_rupees': amountRupees,
      'status': status,
      'rejection_reason': rejectionReason,
      'processed_at': processedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'bank_detail': bankDetail != null
          ? (bankDetail as BankAccountModel).toJson()
          : null,
    };
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
