import 'dart:io';

import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/vendor_join_request.dart';

/// Model class for vendor registration request
class VendorJoinRequestModel extends VendorJoinRequest {
  const VendorJoinRequestModel({
    required super.vendorName,
    required super.address,
    required super.pincode,
    required super.stateId,
    required super.cityId,
    required super.shopName,
    required super.shopAddress,
    required super.shopPincode,
    super.shopLatitude,
    super.shopLongitude,
    super.shopImagePaths,
    required super.ownerName,
    required super.ownerAddress,
    required super.ownerPincode,
    super.ownerLatitude,
    super.ownerLongitude,
    required super.mobileNumber,
    required super.email,
    super.ownerImagePath,
    required super.aadhaarNumber,
    super.aadhaarFilePath,
    super.panNumber,
    super.panFilePath,
    super.bankAccountNumber,
    super.ifscCode,
    super.bankName,
    super.bankFilePath,
    super.gstNumber,
    super.gstFilePath,
    super.nonGstFilePath,
    super.msmeFilePath,
    super.fssaiFilePath,
    super.shopAgreementFilePath,
  });

  /// Convert from entity to model
  factory VendorJoinRequestModel.fromEntity(VendorJoinRequest entity) {
    return VendorJoinRequestModel(
      vendorName: entity.vendorName,
      address: entity.address,
      pincode: entity.pincode,
      stateId: entity.stateId,
      cityId: entity.cityId,
      shopName: entity.shopName,
      shopAddress: entity.shopAddress,
      shopPincode: entity.shopPincode,
      shopLatitude: entity.shopLatitude,
      shopLongitude: entity.shopLongitude,
      shopImagePaths: entity.shopImagePaths,
      ownerName: entity.ownerName,
      ownerAddress: entity.ownerAddress,
      ownerPincode: entity.ownerPincode,
      ownerLatitude: entity.ownerLatitude,
      ownerLongitude: entity.ownerLongitude,
      mobileNumber: entity.mobileNumber,
      email: entity.email,
      ownerImagePath: entity.ownerImagePath,
      aadhaarNumber: entity.aadhaarNumber,
      aadhaarFilePath: entity.aadhaarFilePath,
      panNumber: entity.panNumber,
      panFilePath: entity.panFilePath,
      bankAccountNumber: entity.bankAccountNumber,
      ifscCode: entity.ifscCode,
      bankName: entity.bankName,
      bankFilePath: entity.bankFilePath,
      gstNumber: entity.gstNumber,
      gstFilePath: entity.gstFilePath,
      nonGstFilePath: entity.nonGstFilePath,
      msmeFilePath: entity.msmeFilePath,
      fssaiFilePath: entity.fssaiFilePath,
      shopAgreementFilePath: entity.shopAgreementFilePath,
    );
  }

  /// Convert to multipart form data for API request
  Future<FormData> toFormData() async {
    final DataMap fields = {
      // Vendor details
      'vendor_name': vendorName,
      'address': address,
      'pincode': pincode,
      'state_id': stateId.toString(),
      'city_id': cityId.toString(),
      // Shop details
      'shop_name': shopName,
      'shop_address': shopAddress,
      'shop_pincode': shopPincode,
      // Owner details
      'owner_name': ownerName,
      'owner_address': ownerAddress,
      'owner_pincode': ownerPincode,
      'mobile_number': mobileNumber,
      'email': email,
      // Documents
      'aadhaar_number': aadhaarNumber,
    };

    // Optional text fields helper
    void addIfPresent(String key, String? value) {
      if (value != null && value.isNotEmpty) fields[key] = value;
    }

    // Optional location fields
    if (shopLatitude != null) {
      fields['shop_latitude'] = shopLatitude.toString();
    }
    if (shopLongitude != null) {
      fields['shop_longitude'] = shopLongitude.toString();
    }
    if (ownerLatitude != null) {
      fields['owner_latitude'] = ownerLatitude.toString();
    }
    if (ownerLongitude != null) {
      fields['owner_longitude'] = ownerLongitude.toString();
    }

    // Optional document text fields
    addIfPresent('pan_number', panNumber);
    addIfPresent('bank_account_number', bankAccountNumber);
    addIfPresent('ifsc_code', ifscCode);
    addIfPresent('bank_name', bankName);
    addIfPresent('gst_number', gstNumber);

    final List<MapEntry<String, MultipartFile>> files = [];

    // Shop images (multiple)
    for (int i = 0; i < shopImagePaths.length; i++) {
      if (File(shopImagePaths[i]).existsSync()) {
        files.add(MapEntry(
          'shop_images[]',
          await MultipartFile.fromFile(
            shopImagePaths[i],
            filename: 'shop_image_$i.jpg',
          ),
        ));
      }
    }

    // Owner image (single)
    if (ownerImagePath != null &&
        ownerImagePath!.isNotEmpty &&
        File(ownerImagePath!).existsSync()) {
      files.add(MapEntry(
        'owner_image',
        await MultipartFile.fromFile(
          ownerImagePath!,
          filename: ownerImagePath!.split('/').last,
        ),
      ));
    }

    // Document file upload helper
    Future<void> addFileIfPresent(String key, String? path) async {
      if (path != null && path.isNotEmpty && File(path).existsSync()) {
        files.add(MapEntry(
          key,
          await MultipartFile.fromFile(
            path,
            filename: path.split('/').last,
          ),
        ));
      }
    }

    // Document files
    await addFileIfPresent('aadhaar_file', aadhaarFilePath);
    await addFileIfPresent('pan_file', panFilePath);
    await addFileIfPresent('bank_file', bankFilePath);
    await addFileIfPresent('gst_file', gstFilePath);
    await addFileIfPresent('fssai_file', fssaiFilePath);
    await addFileIfPresent('msme_file', msmeFilePath);
    await addFileIfPresent('shop_agreement_file', shopAgreementFilePath);
    await addFileIfPresent('non_gst_file', nonGstFilePath);

    return FormData.fromMap({
      ...fields,
      ...Map.fromEntries(files),
    });
  }
}
