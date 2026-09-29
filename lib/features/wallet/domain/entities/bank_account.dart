import 'package:equatable/equatable.dart';

/// Bank account entity for withdrawal destination
class BankAccount extends Equatable {
  final int id;
  final String accountHolderName;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String branch;
  final String? upi;
  final String createdAt;
  final String updatedAt;

  const BankAccount({
    required this.id,
    required this.accountHolderName,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.branch,
    this.upi,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Display name for dropdown: "Bank Name - ****1234"
  String get displayName {
    final lastFour = accountNumber.length >= 4
        ? accountNumber.substring(accountNumber.length - 4)
        : accountNumber;
    return '$bankName • ****$lastFour';
  }

  @override
  List<Object?> get props => [
        id,
        accountHolderName,
        bankName,
        accountNumber,
        ifscCode,
        branch,
        upi,
        createdAt,
        updatedAt,
      ];
}
