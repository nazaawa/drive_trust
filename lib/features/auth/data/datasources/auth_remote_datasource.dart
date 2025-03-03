import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_trust/core/error/exceptions.dart';
import 'package:drive_trust/features/auth/data/models/user_model.dart';
import 'package:drive_trust/features/auth/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(
      String name, String email, String password, UserRole role);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<UserModel> updateUserProfile(UserModel user);
  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw UserNotFoundException('User not found');
      }

      // Fetch user data from Firestore
      final userDoc = await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw UserNotFoundException('User data not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      return UserModel.fromJson({
        'id': userCredential.user!.uid,
        ...userData,
      });
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailException();
        case 'user-disabled':
          throw UserDisabledException();
        case 'user-not-found':
          throw UserNotFoundException('No user found for that email');
        case 'wrong-password':
          throw WrongPasswordException();
        default:
          throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
      String name, String email, String password, UserRole role) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw ServerException();
      }

      final user = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        role: role,
      );

      // Save user data to Firestore
      await firestore.collection('users').doc(user.id).set(user.toJson());

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw EmailAlreadyInUseException();
        case 'invalid-email':
          throw InvalidEmailException();
        case 'weak-password':
          throw WeakPasswordException();
        default:
          throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        return null;
      }

      // Fetch user data from Firestore
      final userDoc =
          await firestore.collection('users').doc(currentUser.uid).get();

      if (!userDoc.exists) {
        throw UserNotFoundException('User data not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      return UserModel.fromJson({
        'id': currentUser.uid,
        ...userData,
      });
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> updateUserProfile(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.id).update(user.toJson());
      return user;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw UserNotFoundException('No user is currently signed in');
      }

      // Delete user data from Firestore
      await firestore.collection('users').doc(currentUser.uid).delete();

      // Delete user authentication
      await currentUser.delete();
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw ServerException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
