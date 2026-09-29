import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/development_response.dart';

/// Model class for development response
class DevelopmentResponseModel extends DevelopmentResponse {
  const DevelopmentResponseModel({
    required super.id,
    required super.requestType,
    required super.mobile,
    required super.email,
    required super.status,
    required super.createdAt,
  });

  /// Create from JSON
  factory DevelopmentResponseModel.fromJson(DataMap json) {
    return DevelopmentResponseModel(
      id: json['id'] as int,
      requestType: json['request_type'] as String,
      mobile: json['mobile'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  /// Convert to JSON
  DataMap toJson() {
    return {
      'id': id,
      'request_type': requestType,
      'mobile': mobile,
      'email': email,
      'status': status,
      'created_at': createdAt,
    };
  }
}
