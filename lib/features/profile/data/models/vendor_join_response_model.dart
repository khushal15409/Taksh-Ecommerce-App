import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/vendor_join_response.dart';

/// Model class for vendor registration response
class VendorJoinResponseModel extends VendorJoinResponse {
  const VendorJoinResponseModel({
    required super.vendorId,
    super.userId,
    super.documentsUploaded,
    super.assignedSalesman,
    required super.message,
  });

  /// Create from JSON
  factory VendorJoinResponseModel.fromJson(DataMap json) {
    return VendorJoinResponseModel(
      vendorId: json['vendor_id'] as int,
      userId: json['user_id'] as int?,
      documentsUploaded: json['documents_uploaded'] as int?,
      assignedSalesman: json['assigned_salesman'] as String?,
      message: json['message'] as String,
    );
  }

  /// Convert to JSON
  DataMap toJson() {
    return {
      'vendor_id': vendorId,
      'user_id': userId,
      'documents_uploaded': documentsUploaded,
      'assigned_salesman': assignedSalesman,
      'message': message,
    };
  }
}
