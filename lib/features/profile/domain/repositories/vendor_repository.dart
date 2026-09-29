import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/vendor_join_request.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/vendor_join_response.dart';

/// Repository interface for vendor operations
abstract class VendorRepository {
  /// Submit a vendor join request
  ResultFuture<VendorJoinResponse> submitJoinRequest(
    VendorJoinRequest request,
  );
}
