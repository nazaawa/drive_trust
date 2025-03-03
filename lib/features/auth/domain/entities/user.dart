import 'package:equatable/equatable.dart';

enum UserRole { owner, driver }

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  List<Object> get props => [id, name, email, role];
}
