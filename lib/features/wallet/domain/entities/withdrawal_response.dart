import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/wallet/domain/entities/bank_account.dart';

/// Response entity for a withdrawal request
class WithdrawalResponse extends Equatable {
  final int id;
  final int userId;
  final int bankDetailId;
  final int points;
  final int amountRupees;
  final String status;
  final String? rejectionReason;
  final String? processedAt;
  final String createdAt;
  final String updatedAt;
  final BankAccount? bankDetail;

  const WithdrawalResponse({
    required this.id,
    required this.userId,
    required this.bankDetailId,
    required this.points,
    required this.amountRupees,
    required this.status,
    this.rejectionReason,
    this.processedAt,
    required this.createdAt,
    required this.updatedAt,
    this.bankDetail,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        bankDetailId,
        points,
        amountRupees,
        status,
        rejectionReason,
        processedAt,
        createdAt,
        updatedAt,
        bankDetail,
      ];
}

/// Parameters for making a withdrawal request
class WithdrawalParams extends Equatable {
  final int points;
  final int bankDetailId;

  const WithdrawalParams({
    required this.points,
    required this.bankDetailId,
  });

  @override
  List<Object?> get props => [points, bankDetailId];
}
