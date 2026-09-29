import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/profile/domain/usecases/request_callback.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/callback_event.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/callback_state.dart';

/// BLoC for managing callback request
class CallbackBloc extends Bloc<CallbackEvent, CallbackState> {
  final RequestCallback _requestCallback;

  CallbackBloc({
    required RequestCallback requestCallback,
  })  : _requestCallback = requestCallback,
        super(const CallbackInitial()) {
    on<CallbackRequested>(_onCallbackRequested);
  }

  Future<void> _onCallbackRequested(
    CallbackRequested event,
    Emitter<CallbackState> emit,
  ) async {
    emit(const CallbackLoading());

    final result = await _requestCallback();

    result.fold(
      (failure) => emit(CallbackError(message: failure.message)),
      (response) => emit(
        CallbackRequestSuccess(
          response: response,
          message: 'Callback request created successfully',
        ),
      ),
    );
  }
}
