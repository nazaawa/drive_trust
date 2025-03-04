import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import '../entities/auth_user.dart';

abstract class IAuthRepository {
  Future<Either<Failure, AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthUser>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> resetPassword({
    required String email,
  });

  Stream<AuthUser?> get authStateChanges;
}
