// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseAuthHash() => r'cb440927c3ab863427fd4b052a8ccba4c024c863';

/// See also [firebaseAuth].
@ProviderFor(firebaseAuth)
final firebaseAuthProvider = Provider<FirebaseAuth>.internal(
  firebaseAuth,
  name: r'firebaseAuthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firebaseAuthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthRef = ProviderRef<FirebaseAuth>;
String _$authRepositoryHash() => r'b7a35f88a035f2f9a3c1d2e0df7f5e3484cd6101';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<IAuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = ProviderRef<IAuthRepository>;
String _$signInUseCaseHash() => r'bbdfca9c09e64fa09581aac4a9bf6daa7e51843e';

/// See also [signInUseCase].
@ProviderFor(signInUseCase)
final signInUseCaseProvider = Provider<SignInUseCase>.internal(
  signInUseCase,
  name: r'signInUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignInUseCaseRef = ProviderRef<SignInUseCase>;
String _$signUpUseCaseHash() => r'a3e387d875f496e2b0a9ab21c12a23c1bf5889d1';

/// See also [signUpUseCase].
@ProviderFor(signUpUseCase)
final signUpUseCaseProvider = Provider<SignUpUseCase>.internal(
  signUpUseCase,
  name: r'signUpUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signUpUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignUpUseCaseRef = ProviderRef<SignUpUseCase>;
String _$resetPasswordUseCaseHash() =>
    r'fb6a2857c931b6f075774ee2d6c68174c98e1d10';

/// See also [resetPasswordUseCase].
@ProviderFor(resetPasswordUseCase)
final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>.internal(
  resetPasswordUseCase,
  name: r'resetPasswordUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resetPasswordUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResetPasswordUseCaseRef = ProviderRef<ResetPasswordUseCase>;
String _$userNotifierHash() => r'd409c648e75dec57eb39d2f62debd9ee6b233b0b';

/// See also [userNotifier].
@ProviderFor(userNotifier)
final userNotifierProvider = StreamProvider<User?>.internal(
  userNotifier,
  name: r'userNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserNotifierRef = StreamProviderRef<User?>;
String _$currentUserNotifierHash() =>
    r'b8cdbebb0b2c60269a77ff0ac1c6565bc10976f0';

/// See also [currentUserNotifier].
@ProviderFor(currentUserNotifier)
final currentUserNotifierProvider =
    Provider<Raw<AsyncValueNotifier<User?>>>.internal(
  currentUserNotifier,
  name: r'currentUserNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserNotifierRef = ProviderRef<Raw<AsyncValueNotifier<User?>>>;
String _$authNotifierHash() => r'75937bf571a7e331ed8cdb69d6d3b3c4bbc3fbf2';

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AuthNotifier, void>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
