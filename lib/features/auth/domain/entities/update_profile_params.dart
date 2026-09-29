import 'package:equatable/equatable.dart';

/// Parameters for updating user profile details
class UpdateProfileParams extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobile;
  final String? birthday;

  const UpdateProfileParams({
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.birthday,
  });

  bool get hasUpdates =>
      (firstName?.isNotEmpty ?? false) ||
      (lastName?.isNotEmpty ?? false) ||
      (email?.isNotEmpty ?? false) ||
      (mobile?.isNotEmpty ?? false) ||
      (birthday?.isNotEmpty ?? false);

  @override
  List<Object?> get props => [firstName, lastName, email, mobile, birthday];
}
