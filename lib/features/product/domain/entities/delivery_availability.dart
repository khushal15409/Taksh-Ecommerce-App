import 'package:equatable/equatable.dart';

/// Vendor information returned in a delivery check
class DeliveryVendor extends Equatable {
  final int id;
  final String vendorName;
  final String shopName;

  const DeliveryVendor({
    required this.id,
    required this.vendorName,
    required this.shopName,
  });

  @override
  List<Object?> get props => [id, vendorName, shopName];
}

/// Domain entity representing the result of a delivery availability check
class DeliveryAvailability extends Equatable {
  final int productId;
  final String productName;
  final String pincode;
  final bool isDeliverable;
  final String message;
  final DeliveryVendor? vendor;

  const DeliveryAvailability({
    required this.productId,
    required this.productName,
    required this.pincode,
    required this.isDeliverable,
    required this.message,
    this.vendor,
  });

  @override
  List<Object?> get props => [
        productId,
        productName,
        pincode,
        isDeliverable,
        message,
        vendor,
      ];
}
