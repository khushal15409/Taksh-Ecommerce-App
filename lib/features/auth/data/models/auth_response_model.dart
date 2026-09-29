import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/network/base_response_model.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/auth/data/models/user_model.dart';

part 'auth_response_model.g.dart';

/// Data model for Send OTP response
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class SendOtpData {
  final String message;
  final String expiresAt;

  const SendOtpData({
    required this.message,
    required this.expiresAt,
  });

  /// Create SendOtpData from JSON
  factory SendOtpData.fromJson(DataMap json) => _$SendOtpDataFromJson(json);

  /// Convert SendOtpData to JSON
  DataMap toJson() => _$SendOtpDataToJson(this);
}

/// Data model for authentication (verify OTP) response
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AuthData {
  final UserModel user;
  final String token;

  const AuthData({
    required this.user,
    required this.token,
  });

  /// Create AuthData from JSON
  factory AuthData.fromJson(DataMap json) => _$AuthDataFromJson(json);

  /// Convert AuthData to JSON
  DataMap toJson() => _$AuthDataToJson(this);
}

/// Type alias for Send OTP Response
typedef SendOtpResponse = BaseResponse<SendOtpData>;

/// Type alias for Verify OTP Response
typedef VerifyOtpResponse = BaseResponse<AuthData>;

/// Legacy model - kept for backward compatibility
/// Use VerifyOtpResponse (BaseResponse<AuthData>) instead
class AuthResponseModel extends BaseResponse<AuthData> {
  const AuthResponseModel({
    required super.success,
    required super.message,
    required super.data,
  });

  /// Create AuthResponseModel from JSON
  factory AuthResponseModel.fromJson(DataMap json) {
    final baseResponse = BaseResponse<AuthData>.fromJson(
      json,
      (data) => AuthData.fromJson(data as DataMap),
    );
    return AuthResponseModel(
      success: baseResponse.success,
      message: baseResponse.message,
      data: baseResponse.data,
    );
  }

  /// Convenience getters for backward compatibility
  String get token => data!.token;
  UserModel get user => data!.user;
}
