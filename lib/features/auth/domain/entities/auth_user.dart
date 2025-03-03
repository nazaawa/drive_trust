import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String? email;
  final bool isEmailVerified;

  const AuthUser({
    required this.id,
    this.email,
    this.isEmailVerified = false,
  });

  @override
  List<Object?> get props => [id, email, isEmailVerified];
}
