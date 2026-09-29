import 'package:equatable/equatable.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';

/// Response data for update profile API
class UpdateProfileData extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobile;
  final String? birthday;

  const UpdateProfileData({
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.birthday,
  });

  factory UpdateProfileData.fromJson(DataMap json) {
    return UpdateProfileData(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      birthday: json['birthday'] as String?,
    );
  }

  String? get fullName {
    final first = firstName?.trim() ?? '';
    final last = lastName?.trim() ?? '';
    final combined = '$first $last'.trim();
    return combined.isEmpty ? null : combined;
  }

  @override
  List<Object?> get props => [firstName, lastName, email, mobile, birthday];
}
