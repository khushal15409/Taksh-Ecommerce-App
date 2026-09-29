import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/delivery_boy_join_response.dart';

/// Model class for delivery boy join response
class DeliveryBoyJoinResponseModel extends DeliveryBoyJoinResponse {
  const DeliveryBoyJoinResponseModel({
    required super.id,
    required super.status,
    required super.createdAt,
  });

  /// Create from JSON
  factory DeliveryBoyJoinResponseModel.fromJson(DataMap json) {
    return DeliveryBoyJoinResponseModel(
      id: json['id'] as int,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  /// Convert to JSON
  DataMap toJson() {
    return {
      'id': id,
      'status': status,
      'created_at': createdAt,
    };
  }
}
