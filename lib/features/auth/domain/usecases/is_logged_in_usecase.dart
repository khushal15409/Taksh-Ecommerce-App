import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/auth/domain/repositories/auth_repository.dart';

/// Use case for checking if user is logged in
class IsLoggedInUseCase extends UseCaseNoParams<bool> {
  final AuthRepository _repository;

  const IsLoggedInUseCase(this._repository);

  @override
  ResultFuture<bool> call() {
    return _repository.isLoggedIn();
  }
}
