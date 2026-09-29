import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/bank_detail.dart';

/// Base class for all bank detail states
abstract class BankDetailState extends Equatable {
  const BankDetailState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class BankDetailInitial extends BankDetailState {
  const BankDetailInitial();
}

/// Loading state
class BankDetailLoading extends BankDetailState {
  const BankDetailLoading();
}

/// Success state
class BankDetailSaveSuccess extends BankDetailState {
  final BankDetail bankDetail;
  final String message;

  const BankDetailSaveSuccess({
    required this.bankDetail,
    required this.message,
  });

  @override
  List<Object?> get props => [bankDetail, message];
}

/// Error state
class BankDetailError extends BankDetailState {
  final String message;

  const BankDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
