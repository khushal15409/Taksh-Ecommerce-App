import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/delivery_boy_join_request.dart';

/// Model class for delivery boy join request
class DeliveryBoyJoinRequestModel extends DeliveryBoyJoinRequest {
  const DeliveryBoyJoinRequestModel({
    required super.name,
    required super.mobile,
    super.email,
    super.address,
    super.pincode,
    super.description,
  });

  /// Convert from entity to model
  factory DeliveryBoyJoinRequestModel.fromEntity(
    DeliveryBoyJoinRequest entity,
  ) {
    return DeliveryBoyJoinRequestModel(
      name: entity.name,
      mobile: entity.mobile,
      email: entity.email,
      address: entity.address,
      pincode: entity.pincode,
      description: entity.description,
    );
  }

  /// Convert to form data map for API request
  DataMap toFormData() {
    final data = <String, dynamic>{
      'name': name,
      'mobile': mobile,
    };

    // Add optional fields only if they are not null and not empty
    if (email != null && email!.isNotEmpty) {
      data['email'] = email;
    }
    if (address != null && address!.isNotEmpty) {
      data['address'] = address;
    }
    if (pincode != null && pincode!.isNotEmpty) {
      data['pincode'] = pincode;
    }
    if (description != null && description!.isNotEmpty) {
      data['description'] = description;
    }

    return data;
  }
}
