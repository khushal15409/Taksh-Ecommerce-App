import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/vendor_join_request.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/vendor_join_response.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/vendor_repository.dart';

/// Use case for submitting vendor join request
class SubmitVendorJoinRequest
    extends UseCase<VendorJoinResponse, VendorJoinRequest> {
  final VendorRepository _repository;

  const SubmitVendorJoinRequest(this._repository);

  @override
  ResultFuture<VendorJoinResponse> call(VendorJoinRequest params) {
    return _repository.submitJoinRequest(params);
  }
}
