import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/development_request.dart';

/// Model class for development request
class DevelopmentRequestModel extends DevelopmentRequest {
  const DevelopmentRequestModel({
    super.name,
    required super.mobile,
    required super.email,
    required super.requestType,
    required super.description,
  });

  /// Convert from entity to model
  factory DevelopmentRequestModel.fromEntity(
    DevelopmentRequest entity,
  ) {
    return DevelopmentRequestModel(
      name: entity.name,
      mobile: entity.mobile,
      email: entity.email,
      requestType: entity.requestType,
      description: entity.description,
    );
  }

  /// Convert to form data map for API request
  DataMap toFormData() {
    final data = <String, dynamic>{
      'mobile': mobile,
      'email': email,
      'request_type': requestType,
      'description': description,
    };

    // Add optional name if provided
    if (name != null && name!.isNotEmpty) {
      data['name'] = name;
    }

    return data;
  }
}
