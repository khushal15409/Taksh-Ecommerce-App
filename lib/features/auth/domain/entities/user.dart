import 'package:equatable/equatable.dart';

/// User entity representing a user in the domain layer
class User extends Equatable {
  final int id;
  final String? name;
  final String mobile;
  final String? email;
  final String? profileImage;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? birthday;

  const User({
    required this.id,
    this.name,
    required this.mobile,
    this.email,
    this.profileImage,
    required this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.birthday,
  });

  /// Create an empty user (for initial/unauthenticated state)
  factory User.empty() {
    return const User(
      id: 0,
      name: null,
      mobile: '',
      email: null,
      profileImage: null,
      isVerified: false,
      createdAt: null,
      updatedAt: null,
      birthday: null,
    );
  }

  /// Check if user is empty (not authenticated)
  bool get isEmpty => id == 0;

  /// Check if user is not empty (authenticated)
  bool get isNotEmpty => id != 0;

  @override
  List<Object?> get props => [
        id,
        name,
        mobile,
        email,
        profileImage,
        isVerified,
        createdAt,
        updatedAt,
        birthday,
      ];

  @override
  String toString() {
    return 'User(id: $id, name: $name, mobile: $mobile, email: $email, isVerified: $isVerified, birthday: $birthday)';
  }
}
