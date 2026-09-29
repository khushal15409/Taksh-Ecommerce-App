import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/delivery_boy_join_request.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/delivery_boy_join_response.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/delivery_boy_repository.dart';

/// Use case for submitting delivery boy join request
class SubmitDeliveryBoyJoinRequest
    extends UseCase<DeliveryBoyJoinResponse, DeliveryBoyJoinRequest> {
  final DeliveryBoyRepository _repository;

  const SubmitDeliveryBoyJoinRequest(this._repository);

  @override
  ResultFuture<DeliveryBoyJoinResponse> call(DeliveryBoyJoinRequest params) {
    return _repository.submitJoinRequest(params);
  }
}
