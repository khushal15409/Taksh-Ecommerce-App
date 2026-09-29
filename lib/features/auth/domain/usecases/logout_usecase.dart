import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/auth/domain/repositories/auth_repository.dart';

/// Use case for logging out current user
class LogoutUseCase extends UseCaseVoidNoParams {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  @override
  ResultVoid call() {
    return _repository.logout();
  }
}
