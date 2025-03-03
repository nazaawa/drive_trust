import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/auth/domain/entities/user.dart';
import 'package:drive_trust/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUpWithEmailAndPassword(
      params.name,
      params.email,
      params.password,
      params.role,
    );
  }
}

class SignUpParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final UserRole role;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object> get props => [name, email, password, role];
}
