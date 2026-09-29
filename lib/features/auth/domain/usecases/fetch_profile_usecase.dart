import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/user.dart';
import 'package:taksh_e_commerce/features/auth/domain/repositories/auth_repository.dart';

/// Use case for fetching user profile from server
class FetchProfileUseCase extends UseCaseNoParams<User> {
  final AuthRepository _repository;

  FetchProfileUseCase(this._repository);

  @override
  ResultFuture<User> call() async {
    return await _repository.fetchProfile();
  }
}
