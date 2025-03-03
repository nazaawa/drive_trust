import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/exceptions.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:drive_trust/features/auth/domain/entities/user.dart';
import 'package:drive_trust/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      return Right(user);
    } on InvalidEmailException {
      return Left(InvalidEmailFailure());
    } on WrongPasswordException {
      return Left(WrongPasswordFailure());
    } on UserNotFoundException {
      return Left(UserNotFoundFailure());
    } on UserDisabledException {
      return Left(UserDisabledFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword(
      String name, String email, String password, UserRole role) async {
    try {
      final user = await remoteDataSource.signUpWithEmailAndPassword(
        name,
        email,
        password,
        role,
      );
      return Right(user);
    } on EmailAlreadyInUseException {
      return Left(EmailAlreadyInUseFailure());
    } on InvalidEmailException {
      return Left(InvalidEmailFailure());
    } on WeakPasswordException {
      return Left(WeakPasswordFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on UserNotFoundException {
      return Left(UserNotFoundFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> updateUserProfile(User user) async {
    try {
      // Since our domain entity User doesn't have toJson method,
      // we need to convert it to UserModel first
      final userModel = await remoteDataSource.updateUserProfile(
        user as dynamic, // This is a hack, in real app use proper conversion
      );
      return Right(userModel);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      return const Right(null);
    } on UserNotFoundException {
      return Left(UserNotFoundFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
