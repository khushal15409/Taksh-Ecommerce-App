import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/home/domain/entities/express_fulfillment_center_entity.dart';

/// Model for express fulfillment center
class ExpressFulfillmentCenterModel extends ExpressFulfillmentCenterEntity {
  const ExpressFulfillmentCenterModel({
    required super.id,
    required super.name,
  });

  factory ExpressFulfillmentCenterModel.fromJson(DataMap json) {
    return ExpressFulfillmentCenterModel(
      id: (json['id'] as int?) ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  DataMap toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
