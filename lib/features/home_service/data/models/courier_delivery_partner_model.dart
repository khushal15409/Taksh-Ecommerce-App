import 'package:taksh_e_commerce/features/home_service/domain/entities/courier_delivery_partner.dart';

int _partnerAsInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _partnerAsDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

String _partnerAsString(dynamic value) {
  if (value == null) {
    return '';
  }

  return value.toString().trim();
}

class CourierDeliveryPartnerModel extends CourierDeliveryPartner {
  const CourierDeliveryPartnerModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.baseCharge,
    required super.chargePerKg,
  });

  factory CourierDeliveryPartnerModel.fromJson(Map<String, dynamic> json) {
    return CourierDeliveryPartnerModel(
      id: _partnerAsInt(json['id']),
      name: _partnerAsString(json['name']),
      slug: _partnerAsString(json['slug']),
      baseCharge: _partnerAsDouble(json['base_charge']),
      chargePerKg: _partnerAsDouble(json['charge_per_kg']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'base_charge': baseCharge,
      'charge_per_kg': chargePerKg,
    };
  }
}