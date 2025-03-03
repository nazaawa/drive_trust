import 'package:drive_trust/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String name,
    required String email,
    required UserRole role,
  }) : super(
          id: id,
          name: name,
          email: email,
          role: role,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: _mapStringToUserRole(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
    };
  }

  static UserRole _mapStringToUserRole(String role) {
    switch (role) {
      case 'owner':
        return UserRole.owner;
      case 'driver':
        return UserRole.driver;
      default:
        return UserRole.owner;
    }
  }
}
