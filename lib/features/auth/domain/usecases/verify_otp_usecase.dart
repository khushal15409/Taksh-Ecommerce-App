import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/auth_credentials.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/user.dart';
import 'package:taksh_e_commerce/features/auth/domain/repositories/auth_repository.dart';

/// Use case for verifying OTP and completing login
class VerifyOtpUseCase extends UseCase<User, OtpCredentials> {
  final AuthRepository _repository;

  const VerifyOtpUseCase(this._repository);

  @override
  ResultFuture<User> call(OtpCredentials params) {
    return _repository.verifyOtp(params);
  }
}
