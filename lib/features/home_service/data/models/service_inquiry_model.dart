import 'package:taksh_e_commerce/features/home_service/domain/entities/service_inquiry.dart';

/// Model for [ServiceInquiryService].
class ServiceInquiryServiceModel extends ServiceInquiryService {
  const ServiceInquiryServiceModel({
    required super.id,
    required super.name,
    required super.slug,
  });

  factory ServiceInquiryServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceInquiryServiceModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}

/// Model for [ServiceInquiry].
class ServiceInquiryModel extends ServiceInquiry {
  const ServiceInquiryModel({
    required super.serviceInquiryId,
    required super.service,
    required super.tokenAmount,
    required super.status,
    required super.paymentStatus,
    super.productImage,
    required super.message,
    super.customerName,
    super.customerMobile,
    super.fullAddress,
    super.pincode,
    super.description,
    super.trackingId,
    super.deliveryPartner,
    super.pickupAddress,
    super.pickupPincode,
    super.deliveryAddress,
    super.deliveryPincode,
    super.bookingDate,
    super.completedDate,
    super.bookingCharge,
    super.platformFees,
    super.cgst,
    super.sgst,
    super.otherCharges,
    super.totalCharges,
    super.discount,
    super.finalAmount,
    super.paymentMode,
  });

  factory ServiceInquiryModel.fromJson(Map<String, dynamic> json) {
    return ServiceInquiryModel(
      serviceInquiryId: json['id'] as int,
      service: ServiceInquiryServiceModel.fromJson(
        json['service'] as Map<String, dynamic>,
      ),
      tokenAmount: (json['token_amount'] as num?)?.toDouble() ?? 0.0,
      status: (json['status'] ?? 'pending') as String,
      paymentStatus: (json['payment_status'] ?? 'pending') as String,
      productImage: json['product_image'] as String?,
      message: (json['customer_notes'] ?? json['message'] ?? '') as String,
      customerName: json['contact_person'] as String?,
      customerMobile: json['contact_phone'] as String?,
      fullAddress: json['complete_address'] ?? json['pickup_address'] as String?,
      pincode: json['address_pincode'] ?? json['pickup_pincode'] as String?,
      description: json['service_description'] ?? json['customer_notes'] as String?,
      trackingId: json['tracking_id'] as String?,
      deliveryPartner: json['delivery_partner'] as String?,
      pickupAddress: json['pickup_address'] as String?,
      pickupPincode: json['pickup_pincode'] as String?,
      deliveryAddress: json['delivery_address'] as String?,
      deliveryPincode: json['delivery_pincode'] as String?,
      bookingDate: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      completedDate: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'].toString())
          : null,
      bookingCharge: (json['booking_charge'] as num?)?.toDouble(),
      platformFees: (json['platform_fees'] as num?)?.toDouble(),
      cgst: (json['cgst'] as num?)?.toDouble(),
      sgst: (json['sgst'] as num?)?.toDouble(),
      otherCharges: (json['other_charges'] as num?)?.toDouble(),
      totalCharges: (json['total_charges'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      finalAmount: (json['final_amount'] as num?)?.toDouble(),
      paymentMode: json['payment_gateway'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': serviceInquiryId,
      'service': (service as ServiceInquiryServiceModel).toJson(),
      'token_amount': tokenAmount,
      'status': status,
      'payment_status': paymentStatus,
      'product_image': productImage,
      'customer_notes': message,
      'contact_person': customerName,
      'contact_phone': customerMobile,
      'complete_address': fullAddress,
      'address_pincode': pincode,
      'service_description': description,
      'tracking_id': trackingId,
      'delivery_partner': deliveryPartner,
      'pickup_address': pickupAddress,
      'pickup_pincode': pickupPincode,
      'delivery_address': deliveryAddress,
      'delivery_pincode': deliveryPincode,
      'created_at': bookingDate?.toIso8601String(),
      'completed_at': completedDate?.toIso8601String(),
      'booking_charge': bookingCharge,
      'platform_fees': platformFees,
      'cgst': cgst,
      'sgst': sgst,
      'other_charges': otherCharges,
      'total_charges': totalCharges,
      'discount': discount,
      'final_amount': finalAmount,
      'payment_gateway': paymentMode,
    };
  }
}
