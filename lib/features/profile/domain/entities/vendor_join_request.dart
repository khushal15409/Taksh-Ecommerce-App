import 'package:equatable/equatable.dart';

/// Request entity for vendor registration
class VendorJoinRequest extends Equatable {
  // Vendor Details
  final String vendorName;
  final String address;
  final String pincode;
  final int stateId;
  final int cityId;

  // Shop Details
  final String shopName;
  final String shopAddress;
  final String shopPincode;
  final double? shopLatitude;
  final double? shopLongitude;
  final List<String> shopImagePaths;

  // Owner Details
  final String ownerName;
  final String ownerAddress;
  final String ownerPincode;
  final double? ownerLatitude;
  final double? ownerLongitude;
  final String mobileNumber;
  final String email;
  final String? ownerImagePath;

  // Documents
  final String aadhaarNumber;
  final String? aadhaarFilePath;
  final String? panNumber;
  final String? panFilePath;
  final String? bankAccountNumber;
  final String? ifscCode;
  final String? bankName;
  final String? bankFilePath;
  final String? gstNumber;
  final String? gstFilePath;
  final String? nonGstFilePath;
  final String? msmeFilePath;
  final String? fssaiFilePath;
  final String? shopAgreementFilePath;

  const VendorJoinRequest({
    required this.vendorName,
    required this.address,
    required this.pincode,
    required this.stateId,
    required this.cityId,
    required this.shopName,
    required this.shopAddress,
    required this.shopPincode,
    this.shopLatitude,
    this.shopLongitude,
    this.shopImagePaths = const [],
    required this.ownerName,
    required this.ownerAddress,
    required this.ownerPincode,
    this.ownerLatitude,
    this.ownerLongitude,
    required this.mobileNumber,
    required this.email,
    this.ownerImagePath,
    required this.aadhaarNumber,
    this.aadhaarFilePath,
    this.panNumber,
    this.panFilePath,
    this.bankAccountNumber,
    this.ifscCode,
    this.bankName,
    this.bankFilePath,
    this.gstNumber,
    this.gstFilePath,
    this.nonGstFilePath,
    this.msmeFilePath,
    this.fssaiFilePath,
    this.shopAgreementFilePath,
  });

  @override
  List<Object?> get props => [
        vendorName,
        address,
        pincode,
        stateId,
        cityId,
        shopName,
        shopAddress,
        shopPincode,
        shopLatitude,
        shopLongitude,
        shopImagePaths,
        ownerName,
        ownerAddress,
        ownerPincode,
        ownerLatitude,
        ownerLongitude,
        mobileNumber,
        email,
        ownerImagePath,
        aadhaarNumber,
        aadhaarFilePath,
        panNumber,
        panFilePath,
        bankAccountNumber,
        ifscCode,
        bankName,
        bankFilePath,
        gstNumber,
        gstFilePath,
        nonGstFilePath,
        msmeFilePath,
        fssaiFilePath,
        shopAgreementFilePath,
      ];
}
