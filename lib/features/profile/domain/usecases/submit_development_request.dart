import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/development_request.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/development_response.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/development_repository.dart';

/// Use case for submitting development request
class SubmitDevelopmentRequest
    extends UseCase<DevelopmentResponse, DevelopmentRequest> {
  final DevelopmentRepository _repository;

  const SubmitDevelopmentRequest(this._repository);

  @override
  ResultFuture<DevelopmentResponse> call(DevelopmentRequest params) {
    return _repository.submitDevelopmentRequest(params);
  }
}
