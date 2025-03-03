import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:equatable/equatable.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final IAuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await _repository.resetPassword(
      email: params.email,
    );
  }
}

class ResetPasswordParams extends Equatable {
  final String email;

  const ResetPasswordParams({required this.email});

  @override
  List<Object?> get props => [email];
}
