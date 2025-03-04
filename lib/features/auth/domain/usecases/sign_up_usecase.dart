import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/core/utils/use_cases.dart';

import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  final String email;
  final String password;
  final String? name;

  SignUpParams({required this.email, required this.password, this.name});
}

class SignUpUseCase implements UseCase<AuthUser, SignUpParams> {
  final IAuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUser>> call(SignUpParams params) {
    return repository.signUpWithEmailAndPassword(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}
