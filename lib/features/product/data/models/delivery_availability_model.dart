import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/product/domain/entities/delivery_availability.dart';

/// Data model for [DeliveryVendor]
class DeliveryVendorModel extends DeliveryVendor {
  const DeliveryVendorModel({
    required super.id,
    required super.vendorName,
    required super.shopName,
  });

  factory DeliveryVendorModel.fromJson(DataMap json) {
    return DeliveryVendorModel(
      id: (json['id'] as num).toInt(),
      vendorName: json['vendor_name'] as String? ?? '',
      shopName: json['shop_name'] as String? ?? '',
    );
  }
}

/// Data model for [DeliveryAvailability]
class DeliveryAvailabilityModel extends DeliveryAvailability {
  const DeliveryAvailabilityModel({
    required super.productId,
    required super.productName,
    required super.pincode,
    required super.isDeliverable,
    required super.message,
    super.vendor,
  });

  factory DeliveryAvailabilityModel.fromJson(DataMap json) {
    final vendorJson = json['vendor'] as DataMap?;
    return DeliveryAvailabilityModel(
      productId: (json['product_id'] as num).toInt(),
      productName: json['product_name'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      isDeliverable: json['is_deliverable'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      vendor: vendorJson != null
          ? DeliveryVendorModel.fromJson(vendorJson)
          : null,
    );
  }
}
