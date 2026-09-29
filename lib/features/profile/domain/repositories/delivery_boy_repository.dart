import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/delivery_boy_join_request.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/delivery_boy_join_response.dart';

/// Repository interface for delivery boy operations
abstract class DeliveryBoyRepository {
  /// Submit a delivery boy join request
  ResultFuture<DeliveryBoyJoinResponse> submitJoinRequest(
    DeliveryBoyJoinRequest request,
  );
}
