import 'package:dartz/dartz.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._firebaseAuth)
      : _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Set reCAPTCHA verification to be automatically triggered for risky requests
      await _configureRecaptchaIfNeeded();

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return Left(AuthFailure('Échec de l\'authentification'));
      }

      // Get user profile from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      final String? name =
          userDoc.exists ? userDoc.data()!['name'] as String? : null;

      return Right(AuthUser(
        id: userCredential.user!.uid,
        email: userCredential.user!.email,
        name: name,
        isEmailVerified: userCredential.user!.emailVerified,
      ));
    } on FirebaseAuthException catch (e, st) {
      debugPrint("FirebaseAuthException: ${e.toString()} \nStackTrace: $st");
      return Left(AuthFailure(_getErrorMessage(e.code)));
    } catch (e, st) {
      debugPrint("Unexpected error: ${e.toString()} \nStackTrace: $st");
      return Left(AuthFailure('Une erreur inattendue est survenue'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      // Set reCAPTCHA verification to be automatically triggered for risky requests
      await _configureRecaptchaIfNeeded();

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return Left(AuthFailure('Échec de la création du compte'));
      }

      // Create user profile in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Right(AuthUser(
        id: userCredential.user!.uid,
        email: userCredential.user!.email,
        name: name,
        isEmailVerified: userCredential.user!.emailVerified,
      ));
    } on FirebaseAuthException catch (e, st) {
      debugPrint("FirebaseAuthException: ${e.toString()} \nStackTrace: $st");

      if (e.code == 'operation-not-allowed') {
        return Left(AuthFailure('La création de compte est désactivée'));
      } else if (e.code == 'captcha-check-failed' ||
          e.code == 'missing-recaptcha-token') {
        return Left(
            AuthFailure('Vérification reCAPTCHA échouée. Veuillez réessayer.'));
      }

      return Left(AuthFailure(_getErrorMessage(e.code)));
    } catch (e, st) {
      debugPrint("Unexpected error: ${e.toString()} \nStackTrace: $st");
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
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        // Get user profile from Firestore
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        final String? name =
            userDoc.exists ? userDoc.data()!['name'] as String? : null;

        return AuthUser(
          id: user.uid,
          email: user.email,
          name: name,
          isEmailVerified: user.emailVerified,
        );
      } catch (e) {
        debugPrint("Error fetching user profile: $e");
        return AuthUser(
          id: user.uid,
          email: user.email,
          isEmailVerified: user.emailVerified,
        );
      }
    });
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
  }) async {
    try {
      await _configureRecaptchaIfNeeded();
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e, st) {
      debugPrint("FirebaseAuthException: ${e.toString()} \nStackTrace: $st");
      return Left(AuthFailure(_getErrorMessage(e.code)));
    } catch (e, st) {
      debugPrint("Unexpected error: ${e.toString()} \nStackTrace: $st");
      return Left(AuthFailure('Une erreur inattendue est survenue'));
    }
  }

  /// Configure reCAPTCHA for web platform
  Future<void> _configureRecaptchaIfNeeded() async {
    // This is only needed for web platform
    if (kIsWeb) {
      try {
        // For web, we need to configure reCAPTCHA
        await _firebaseAuth.setPersistence(Persistence.LOCAL);
        // Additional reCAPTCHA configuration would go here if needed
      } catch (e) {
        debugPrint("Error configuring reCAPTCHA: $e");
      }
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
      case 'too-many-requests':
        return 'Trop de tentatives. Veuillez réessayer plus tard.';
      case 'operation-not-allowed':
        return 'Cette opération n\'est pas autorisée';
      case 'captcha-check-failed':
      case 'missing-recaptcha-token':
        return 'Vérification reCAPTCHA échouée. Veuillez réessayer.';
      default:
        return 'Une erreur est survenue: $code';
    }
  }
}
