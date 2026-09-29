import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/profile/domain/entities/callback_response.dart';
import 'package:taksh_e_commerce/features/profile/domain/repositories/callback_repository.dart';

/// Use case for requesting a callback
class RequestCallback extends UseCaseNoParams<CallbackResponse> {
  final CallbackRepository _repository;

  const RequestCallback(this._repository);

  @override
  ResultFuture<CallbackResponse> call() {
    return _repository.requestCallback();
  }
}
