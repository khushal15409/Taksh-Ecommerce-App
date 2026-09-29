import 'package:json_annotation/json_annotation.dart';
import 'package:taksh_e_commerce/core/utils/typedef.dart';
import 'package:taksh_e_commerce/features/auth/domain/entities/user.dart';

part 'user_model.g.dart';

/// User model with JSON serialization
@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends User {
  const UserModel({
    required super.id,
    super.name,
    required super.mobile,
    super.email,
    super.profileImage,
    required super.isVerified,
    super.createdAt,
    super.updatedAt,
    super.birthday,
  });

  /// Create UserModel from User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      mobile: user.mobile,
      email: user.email,
      profileImage: user.profileImage,
      isVerified: user.isVerified,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      birthday: user.birthday,
    );
  }

  /// Create empty UserModel
  factory UserModel.empty() {
    return const UserModel(
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

  /// Create UserModel from JSON
  factory UserModel.fromJson(DataMap json) => _$UserModelFromJson(json);

  /// Convert UserModel to JSON
  DataMap toJson() => _$UserModelToJson(this);

  /// Copy with method
  UserModel copyWith({
    int? id,
    String? name,
    String? mobile,
    String? email,
    String? profileImage,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? birthday,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      birthday: birthday ?? this.birthday,
    );
  }
}
