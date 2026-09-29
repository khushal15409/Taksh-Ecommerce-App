import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/callback_response.dart';

/// Model class for callback response
class CallbackResponseModel extends CallbackResponse {
  const CallbackResponseModel({
    required super.id,
    required super.name,
    required super.mobile,
    required super.status,
    required super.createdAt,
  });

  /// Create from JSON
  factory CallbackResponseModel.fromJson(DataMap json) {
    return CallbackResponseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  /// Convert to JSON
  DataMap toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'status': status,
      'created_at': createdAt,
    };
  }
}
