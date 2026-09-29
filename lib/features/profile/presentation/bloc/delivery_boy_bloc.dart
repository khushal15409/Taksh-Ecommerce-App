import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/profile/domain/usecases/submit_delivery_boy_join_request.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/delivery_boy_event.dart';
import 'package:taksh_e_commerce/features/profile/presentation/bloc/delivery_boy_state.dart';

/// BLoC for managing delivery boy join request
class DeliveryBoyBloc extends Bloc<DeliveryBoyEvent, DeliveryBoyState> {
  final SubmitDeliveryBoyJoinRequest _submitJoinRequest;

  DeliveryBoyBloc({
    required SubmitDeliveryBoyJoinRequest submitJoinRequest,
  })  : _submitJoinRequest = submitJoinRequest,
        super(const DeliveryBoyInitial()) {
    on<DeliveryBoyJoinRequestSubmitted>(_onJoinRequestSubmitted);
  }

  Future<void> _onJoinRequestSubmitted(
    DeliveryBoyJoinRequestSubmitted event,
    Emitter<DeliveryBoyState> emit,
  ) async {
    emit(const DeliveryBoyLoading());

    final result = await _submitJoinRequest(event.request);

    result.fold(
      (failure) => emit(DeliveryBoyError(message: failure.message)),
      (response) => emit(
        DeliveryBoyJoinRequestSuccess(
          response: response,
          message: 'Delivery boy join request submitted successfully',
        ),
      ),
    );
  }
}
