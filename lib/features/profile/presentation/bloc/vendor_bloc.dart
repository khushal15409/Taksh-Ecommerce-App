import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/profile/domain/usecases/submit_vendor_join_request.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/vendor_event.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/vendor_state.dart';

/// BLoC for managing vendor join request
class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final SubmitVendorJoinRequest _submitJoinRequest;

  VendorBloc({
    required SubmitVendorJoinRequest submitJoinRequest,
  })  : _submitJoinRequest = submitJoinRequest,
        super(const VendorInitial()) {
    on<VendorJoinRequestSubmitted>(_onJoinRequestSubmitted);
  }

  Future<void> _onJoinRequestSubmitted(
    VendorJoinRequestSubmitted event,
    Emitter<VendorState> emit,
  ) async {
    emit(const VendorLoading());

    final result = await _submitJoinRequest(event.request);

    result.fold(
      (failure) => emit(VendorError(message: failure.message)),
      (response) => emit(
        VendorJoinRequestSuccess(
          response: response,
          message: response.message,
        ),
      ),
    );
  }
}
