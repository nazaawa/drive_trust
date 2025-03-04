import 'package:drive_trust/core/utils/async_value_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
IAuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(firebaseAuthProvider));
}

@Riverpod(keepAlive: true)
SignInUseCase signInUseCase(Ref ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
}

@Riverpod(keepAlive: true)
SignUpUseCase signUpUseCase(Ref ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
}

@Riverpod(keepAlive: true)
ResetPasswordUseCase resetPasswordUseCase(Ref ref) {
  return ResetPasswordUseCase(ref.watch(authRepositoryProvider));
}

@Riverpod(keepAlive: true)
Stream<User?> userNotifier(Ref ref) => FirebaseAuth.instance.authStateChanges();

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();

    final result = await ref.read(signInUseCaseProvider).call(
          SignInParams(email: email, password: password),
        );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (user) => const AsyncData(null),
    );
  }

  Future<void> signUp(String email, String password, {String? name}) async {
    state = const AsyncLoading();

    final result = await ref.read(signUpUseCaseProvider).call(
          SignUpParams(email: email, password: password, name: name),
        );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (user) => const AsyncData(null),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    final result = await ref.read(authRepositoryProvider).signOut();

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();

    final result = await ref.read(resetPasswordUseCaseProvider).call(
          ResetPasswordParams(email: email),
        );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}

@Riverpod(keepAlive: true)
Raw<AsyncValueNotifier<User?>> currentUserNotifier(Ref ref) {
  final asyncValue = ref.watch(userNotifierProvider);
  final notifier = AsyncValueNotifier<User?>(asyncValue);

  ref.listen<AsyncValue<User?>>(userNotifierProvider, (previous, next) {
    notifier.update(next);
  });

  return notifier;
}
