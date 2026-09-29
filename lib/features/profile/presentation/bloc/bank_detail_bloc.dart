import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/core/utils/logger/logger.dart';
import 'package:taksh_e_commerce/features/profile/domain/usecases/save_bank_detail.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/bank_detail_event.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/bank_detail_state.dart';

/// BLoC for managing bank detail operations
class BankDetailBloc extends Bloc<BankDetailEvent, BankDetailState> {
  final SaveBankDetail _saveBankDetail;

  BankDetailBloc({
    required SaveBankDetail saveBankDetail,
  })  : _saveBankDetail = saveBankDetail,
        super(const BankDetailInitial()) {
    on<BankDetailSaveRequested>(_onBankDetailSaveRequested);
  }

  Future<void> _onBankDetailSaveRequested(
    BankDetailSaveRequested event,
    Emitter<BankDetailState> emit,
  ) async {
    final log = loggerWithContext({
      'feature': 'profile',
      'bloc': 'BankDetailBloc',
      'event': 'BankDetailSaveRequested',
    });
    final startTime = DateTime.now();

    log.infoWithContext(
      'Initiating bank detail save',
      {
        'account_holder': event.params.accountHolderName,
        'bank_name': event.params.bankName,
      },
    );

    emit(const BankDetailLoading());

    final result = await _saveBankDetail(event.params);

    result.fold(
      (failure) {
        log.errorWithContext(
          'Bank detail save failed',
          {
            'failure_type': failure.runtimeType.toString(),
            'failure_message': failure.message,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!emit.isDone) {
          emit(BankDetailError(message: failure.message));
        }
      },
      (bankDetail) {
        log.infoWithContext(
          'Bank detail saved successfully',
          {
            'bank_detail_id': bankDetail.id,
            'duration_ms': DateTime.now().difference(startTime).inMilliseconds,
          },
        );
        if (!emit.isDone) {
          emit(BankDetailSaveSuccess(
            bankDetail: bankDetail,
            message: 'Bank details saved successfully',
          ));
        }
      },
    );
  }
}
