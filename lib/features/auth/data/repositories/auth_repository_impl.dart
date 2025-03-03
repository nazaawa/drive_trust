import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<Either<Failure, AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return Left(AuthFailure('Échec de l\'authentification'));
      }

      return Right(AuthUser(
        id: userCredential.user!.uid,
        email: userCredential.user!.email,
        isEmailVerified: userCredential.user!.emailVerified,
      ));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getErrorMessage(e.code)));
    } catch (e) {
      return Left(AuthFailure('Une erreur inattendue est survenue'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return Left(AuthFailure('Échec de la création du compte'));
      }

      return Right(AuthUser(
        id: userCredential.user!.uid,
        email: userCredential.user!.email,
        isEmailVerified: userCredential.user!.emailVerified,
      ));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getErrorMessage(e.code)));
    } catch (e) {
      return Left(AuthFailure('Une erreur inattendue est survenue'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Échec de la déconnexion'));
    }
  }

  @override
  Stream<AuthUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return AuthUser(
        id: user.uid,
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
    });
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getErrorMessage(e.code)));
    } catch (e) {
      return Left(AuthFailure('Une erreur inattendue est survenue'));
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'invalid-email':
        return 'Email invalide';
      case 'weak-password':
        return 'Le mot de passe doit contenir au moins 6 caractères';
      default:
        return 'Une erreur est survenue';
    }
  }
}
