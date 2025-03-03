import 'dart:async';
import 'package:drive_trust/core/di/injection_container.dart';
import 'package:drive_trust/core/error/failures.dart';
import 'package:drive_trust/features/auth/domain/entities/user.dart';
import 'package:drive_trust/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:drive_trust/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:drive_trust/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:drive_trust/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Auth state
enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  factory AuthState.initial() {
    return AuthState(status: AuthStatus.initial);
  }

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthNotifier({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        super(AuthState.initial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _getCurrentUserUseCase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (user) {
        if (user != null) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
          );
        } else {
          state = state.copyWith(status: AuthStatus.unauthenticated);
        }
      },
    );
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = SignInParams(email: email, password: password);
    final result = await _signInUseCase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        );
      },
    );
  }

  Future<void> signUp(
      String name, String email, String password, UserRole role) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = SignUpParams(
      name: name,
      email: email,
      password: password,
      role: role,
    );
    final result = await _signUpUseCase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        );
      },
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _signOutUseCase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (_) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
        );
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Erreur serveur';
      case InvalidEmailFailure _:
        return 'Adresse e-mail invalide';
      case WrongPasswordFailure _:
        return 'Mot de passe incorrect';
      case UserNotFoundFailure _:
        return 'Utilisateur non trouvé';
      case UserDisabledFailure _:
        return 'Compte utilisateur désactivé';
      case EmailAlreadyInUseFailure _:
        return 'Cette adresse e-mail est déjà utilisée';
      case WeakPasswordFailure _:
        return 'Le mot de passe est trop faible';
      default:
        return 'Une erreur inattendue s\'est produite';
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    signInUseCase: sl<SignInUseCase>(),
    signUpUseCase: sl<SignUpUseCase>(),
    signOutUseCase: sl<SignOutUseCase>(),
    getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
  );
});

// Ajouter un StreamProvider pour suivre l'état d'authentification
final authStateChangesProvider = StreamProvider<AuthStatus>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  
  // Vérifier l'état d'authentification au démarrage
  authNotifier.checkAuthStatus();
  
  // Créer un contrôleur de flux pour émettre des mises à jour d'état
  final controller = StreamController<AuthStatus>();
  
  // Écouter les changements d'état d'authentification
  final subscription = ref.listen<AuthState>(authProvider, (previous, current) {
    controller.add(current.status);
  });
  
  // Fermer le contrôleur lorsque le provider est supprimé
  ref.onDispose(() {
    controller.close();
  });
  
  return controller.stream;
});
