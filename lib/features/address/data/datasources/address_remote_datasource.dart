import 'package:dio/dio.dart';
import 'package:taksh_e_commerce/core/constants/api_constants.dart';
import 'package:taksh_e_commerce/core/network/api_client.dart';
import 'package:taksh_e_commerce/features/address/data/models/address_model.dart';

/// Remote data source for address operations
abstract class AddressRemoteDataSource {
  /// Add a new address to the server
  Future<void> addAddress(AddressModel address);

  /// Get all addresses from the server
  Future<List<AddressModel>> getAddresses();

  /// Update an existing address on the server
  Future<void> updateAddress(AddressModel address);

  /// Delete an address from the server
  Future<void> deleteAddress(String id);

  /// Set an address as default on the server
  Future<void> setDefaultAddress(String id);
}

/// Implementation of [AddressRemoteDataSource]
class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiClient apiClient;

  AddressRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> addAddress(AddressModel address) async {
    // Convert address to form data format matching the API
    // Note: The API expects specific IDs for state, city, and area
    // For now, we're using placeholder values. In production, these should be
    // obtained from a location service or user selection
    final formData = <String, dynamic>{
      'state_id': '1', // TODO: Get actual state_id from location service
      'city_id': '1', // TODO: Get actual city_id from location service
      'area_id': '1', // TODO: Get actual area_id from location service
      'name': address.recipientName,
      'mobile': address.recipientPhone,
      'address_line_1': address.addressLine1,
      'pincode': address.location.postalCode ?? '000000',
      'address_type': address.type.name, // Send 'home', 'work', or 'other'
      'is_default': address.isDefault ? '1' : '0',
    };

    // Add optional fields
    if (address.addressLine2 != null && address.addressLine2!.isNotEmpty) {
      formData['address_line_2'] = address.addressLine2;
    }
    if (address.landmark != null && address.landmark!.isNotEmpty) {
      formData['landmark'] = address.landmark;
    }

    // API returns 201 with no body on success
    await apiClient.post(
      ApiConstants.addAddress,
      data: formData,
    );
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await apiClient.get(ApiConstants.addresses);

    // API returns addresses nested under data.addresses
    final dataWrapper = response.data['data'] as Map<String, dynamic>;
    final addressesList = dataWrapper['addresses'] as List;
    return addressesList.map((json) => AddressModel.fromJson(json)).toList();
  }

  @override
  Future<void> updateAddress(AddressModel address) async {
    final formData = <String, dynamic>{
      'state_id': '1', // TODO: Get actual state_id from location service
      'city_id': '1', // TODO: Get actual city_id from location service
      'area_id': '1', // TODO: Get actual area_id from location service
      'name': address.recipientName,
      'mobile': address.recipientPhone,
      'address_line_1': address.addressLine1,
      'pincode': address.location.postalCode ?? '000000',
      'address_type': address.type.name, // Send 'home', 'work', or 'other'
      'is_default': address.isDefault ? '1' : '0',
    };

    if (address.addressLine2 != null && address.addressLine2!.isNotEmpty) {
      formData['address_line_2'] = address.addressLine2;
    }
    if (address.landmark != null && address.landmark!.isNotEmpty) {
      formData['landmark'] = address.landmark;
    }

    await apiClient.put(
      ApiConstants.updateAddress(address.id),
      data: formData,
    );
  }

  @override
  Future<void> deleteAddress(String id) async {
    await apiClient.post(
      ApiConstants.deleteAddress(id),
      data: FormData.fromMap({'address_id': id}),
    );
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    await apiClient.put(ApiConstants.setDefaultAddress(id));
  }
}
