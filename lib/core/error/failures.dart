import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

// Auth failures
class InvalidEmailFailure extends Failure {}

class WrongPasswordFailure extends Failure {}

class EmailAlreadyInUseFailure extends Failure {}

class WeakPasswordFailure extends Failure {}

class UserNotFoundFailure extends Failure {}

class UserDisabledFailure extends Failure {}

// Data validation failures
class InvalidInputFailure extends Failure {
  final String message;

  InvalidInputFailure(this.message);

  @override
  List<Object> get props => [message];
}

// Permission failures
class InsufficientPermissionFailure extends Failure {}

// Not found failures
class NotFoundFailure extends Failure {
  final String message;

  NotFoundFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AuthFailure extends Failure {
  final String message;

  AuthFailure(this.message) : super();

  @override
  List<Object> get props => [message];
}
