import 'package:equatable/equatable.dart';

/// Request parameters entity for bank details
class BankDetailParams extends Equatable {
  final String accountHolderName;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String branchName;

  const BankDetailParams({
    required this.accountHolderName,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.branchName,
  });

  @override
  List<Object?> get props => [
        accountHolderName,
        bankName,
        accountNumber,
        ifscCode,
        branchName,
      ];
}

/// Response entity for bank detail submission
class BankDetail extends Equatable {
  final int id;
  final String accountHolderName;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String branchName;
  final String createdAt;
  final String? updatedAt;

  const BankDetail({
    required this.id,
    required this.accountHolderName,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.branchName,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        accountHolderName,
        bankName,
        accountNumber,
        ifscCode,
        branchName,
        createdAt,
        updatedAt,
      ];
}
