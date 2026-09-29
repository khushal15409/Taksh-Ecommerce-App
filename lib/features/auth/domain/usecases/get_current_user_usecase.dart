import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/user.dart';
import 'package:taksh_e_commerce/features/auth/domain/repositories/auth_repository.dart';

/// Use case for getting current authenticated user
class GetCurrentUserUseCase extends UseCaseNoParams<User> {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  @override
  ResultFuture<User> call() {
    return _repository.getCurrentUser();
  }
}
