// General exceptions
class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

// Auth exceptions
class InvalidEmailException implements Exception {}

class WrongPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class WeakPasswordException implements Exception {}

class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException([this.message = 'User not found']);
}

class UserDisabledException implements Exception {}

// Data validation exceptions
class InvalidInputException implements Exception {
  final String message;

  InvalidInputException(this.message);
}

// Permission exceptions
class InsufficientPermissionException implements Exception {}

// Not found exceptions
class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);
}
