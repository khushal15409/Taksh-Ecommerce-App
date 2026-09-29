import 'package:equatable/equatable.dart';

/// Service info returned after a service inquiry
class ServiceInquiryService extends Equatable {
  final int id;
  final String name;
  final String slug;

  const ServiceInquiryService({
    required this.id,
    required this.name,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, name, slug];
}

/// Represents a service inquiry (price check / booking request)
class ServiceInquiry extends Equatable {
  final int serviceInquiryId;
  final ServiceInquiryService service;
  final double tokenAmount;
  final String status;
  final String paymentStatus;
  final String? productImage;
  final String message;

  // Customer details
  final String? customerName;
  final String? customerMobile;

  // Address details
  final String? fullAddress;
  final String? pincode;
  final String? description;

  // Courier-specific fields
  final String? trackingId;
  final String? deliveryPartner;
  final String? pickupAddress;
  final String? pickupPincode;
  final String? deliveryAddress;
  final String? deliveryPincode;

  // Dates
  final DateTime? bookingDate;
  final DateTime? completedDate;

  // Payment breakdown
  final double? bookingCharge;
  final double? platformFees;
  final double? cgst;
  final double? sgst;
  final double? otherCharges;
  final double? totalCharges;
  final double? discount;
  final double? finalAmount;
  final String? paymentMode;

  const ServiceInquiry({
    required this.serviceInquiryId,
    required this.service,
    required this.tokenAmount,
    required this.status,
    required this.paymentStatus,
    this.productImage,
    required this.message,
    this.customerName,
    this.customerMobile,
    this.fullAddress,
    this.pincode,
    this.description,
    this.trackingId,
    this.deliveryPartner,
    this.pickupAddress,
    this.pickupPincode,
    this.deliveryAddress,
    this.deliveryPincode,
    this.bookingDate,
    this.completedDate,
    this.bookingCharge,
    this.platformFees,
    this.cgst,
    this.sgst,
    this.otherCharges,
    this.totalCharges,
    this.discount,
    this.finalAmount,
    this.paymentMode,
  });

  @override
  List<Object?> get props => [
        serviceInquiryId,
        service,
        tokenAmount,
        status,
        paymentStatus,
        productImage,
        message,
        customerName,
        customerMobile,
        fullAddress,
        pincode,
        description,
        trackingId,
        deliveryPartner,
        pickupAddress,
        pickupPincode,
        deliveryAddress,
        deliveryPincode,
        bookingDate,
        completedDate,
        bookingCharge,
        platformFees,
        cgst,
        sgst,
        otherCharges,
        totalCharges,
        discount,
        finalAmount,
        paymentMode,
      ];
}
