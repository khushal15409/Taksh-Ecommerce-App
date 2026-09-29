import 'package:taksh_e_commerce/core/usecase/usecase.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/auth_credentials.dart';
import 'package:taksh_e_commerce/features/auth/domain/repositories/auth_repository.dart';

/// Use case for sending OTP to phone number
class SendOtpUseCase extends UseCase<String, AuthCredentials> {
  final AuthRepository _repository;

  const SendOtpUseCase(this._repository);

  @override
  ResultFuture<String> call(AuthCredentials params) {
    return _repository.sendOtp(params);
  }
}
