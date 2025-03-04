import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'Une erreur est survenue']);

  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erreur de réseau']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erreur de cache']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Erreur de réseau']);
}

// Auth failures
class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure([super.message = 'Email invalide']);
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure([super.message = 'Mot de passe incorrect']);
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure(
      [super.message = 'Cet email est déjà utilisé']);
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure([super.message = 'Mot de passe trop faible']);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure([super.message = 'Utilisateur non trouvé']);
}

class UserDisabledFailure extends Failure {
  const UserDisabledFailure([super.message = 'Compte utilisateur désactivé']);
}

// Data validation failures
class InvalidInputFailure extends Failure {
  const InvalidInputFailure(super.message);
}

// Permission failures
class InsufficientPermissionFailure extends Failure {
  const InsufficientPermissionFailure(
      [super.message = 'Permissions insuffisantes']);
}

// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}
