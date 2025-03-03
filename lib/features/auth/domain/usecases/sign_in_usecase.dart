import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/core/utils/use_cases.dart';

import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}

class SignInUseCase implements UseCase<AuthUser, SignInParams> {
  final IAuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUser>> call(SignInParams params) {
    return repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}
