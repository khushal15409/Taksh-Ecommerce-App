import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/profile/domain/usecases/submit_development_request.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/development_event.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/development_state.dart';

/// BLoC for managing development request
class DevelopmentBloc extends Bloc<DevelopmentEvent, DevelopmentState> {
  final SubmitDevelopmentRequest _submitDevelopmentRequest;

  DevelopmentBloc({
    required SubmitDevelopmentRequest submitDevelopmentRequest,
  })  : _submitDevelopmentRequest = submitDevelopmentRequest,
        super(const DevelopmentInitial()) {
    on<DevelopmentRequestSubmitted>(_onDevelopmentRequestSubmitted);
  }

  Future<void> _onDevelopmentRequestSubmitted(
    DevelopmentRequestSubmitted event,
    Emitter<DevelopmentState> emit,
  ) async {
    emit(const DevelopmentLoading());

    final result = await _submitDevelopmentRequest(event.request);

    result.fold(
      (failure) => emit(DevelopmentError(message: failure.message)),
      (response) => emit(
        DevelopmentRequestSuccess(
          response: response,
          message: 'Development request submitted successfully',
        ),
      ),
    );
  }
}
