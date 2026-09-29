import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/update_profile_params.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/user.dart';
import 'package:taksh_e_commerce/features/auth/domain/repositories/auth_repository.dart';

/// Use case for updating user profile details
class UpdateProfileUseCase extends UseCase<User, UpdateProfileParams> {
  final AuthRepository _repository;

  const UpdateProfileUseCase(this._repository);

  @override
  ResultFuture<User> call(UpdateProfileParams params) {
    return _repository.updateProfile(params);
  }
}
