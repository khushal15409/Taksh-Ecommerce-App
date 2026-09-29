import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/bank_detail.dart';

/// Base class for all bank detail events
abstract class BankDetailEvent extends Equatable {
  const BankDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Event to save bank account details
class BankDetailSaveRequested extends BankDetailEvent {
  final BankDetailParams params;

  const BankDetailSaveRequested(this.params);

  @override
  List<Object?> get props => [params];
}
