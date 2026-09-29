import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/quick_delivery/domain/entities/quick_delivery_tracking.dart';
import 'package:taksh_e_commerce/features/quick_delivery/domain/repositories/quick_delivery_repository.dart';

class GetQuickDeliveryLocation
    extends UseCase<QuickDeliveryTracking, GetQuickDeliveryLocationParams> {
  final QuickDeliveryRepository _repository;

  const GetQuickDeliveryLocation(this._repository);

  @override
  ResultFuture<QuickDeliveryTracking> call(
    GetQuickDeliveryLocationParams params,
  ) {
    return _repository.getDeliveryLocation(params.orderId);
  }
}

class GetQuickDeliveryLocationParams extends Equatable {
  final int orderId;

  const GetQuickDeliveryLocationParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
