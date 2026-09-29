import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taksh_e_commerce/features/product/domain/usecases/check_delivery_availability.dart';
import 'package:taksh_e_commerce/features/product/presentation/cubit/delivery_check_state.dart';

/// Cubit for checking delivery availability for a product at a given pincode
class DeliveryCheckCubit extends Cubit<DeliveryCheckState> {
  final CheckDeliveryAvailability checkDeliveryAvailability;

  DeliveryCheckCubit({required this.checkDeliveryAvailability})
      : super(const DeliveryCheckInitial());

  /// Check whether the product can be delivered to [pincode].
  Future<void> check({
    required int productId,
    required String pincode,
  }) async {
    emit(const DeliveryCheckLoading());

    final result = await checkDeliveryAvailability(
      CheckDeliveryAvailabilityParams(
        productId: productId,
        pincode: pincode,
      ),
    );

    result.fold(
      (failure) => emit(DeliveryCheckError(failure.message)),
      (availability) => emit(DeliveryCheckLoaded(availability)),
    );
  }

  /// Reset back to initial state (e.g. when pincode input is cleared)
  void reset() => emit(const DeliveryCheckInitial());
}
