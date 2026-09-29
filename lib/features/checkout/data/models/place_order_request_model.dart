import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/cart/data/models/extra_charge_model.dart';
import 'package:taksh_e_commerce/features/cart/domain/entities/extra_charge.dart';

part 'place_order_request_model.g.dart';

/// Model for place order request
@JsonSerializable(createFactory: false)
class PlaceOrderRequestModel {
  @JsonKey(name: 'address_id')
  final String addressId;

  @JsonKey(name: 'warehouse_id')
  final String warehouseId;

  @JsonKey(name: 'delivery_type')
  final String deliveryType;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @JsonKey(name: 'vendor_id')
  final String vendorId;

  @JsonKey(includeToJson: false)
  final List<ExtraCharge> extraCharges;

  const PlaceOrderRequestModel({
    required this.addressId,
    required this.warehouseId,
    required this.deliveryType,
    required this.paymentMethod,
    required this.vendorId,
    this.extraCharges = const [],
  });

  Map<String, dynamic> toJson() => _$PlaceOrderRequestModelToJson(this);

  /// Convert to form data map for API
  DataMap toFormData() {
    return {
      'address_id': addressId,
      'warehouse_id': warehouseId,
      'delivery_type': deliveryType,
      'payment_method': paymentMethod,
      'vendor_id': vendorId,
      'extraCharges': jsonEncode(
        extraCharges
            .map((charge) => ExtraChargeModel.fromEntity(charge).toOrderJson())
            .toList(),
      ),
    };
  }
}
