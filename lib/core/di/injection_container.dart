import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_trust/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:drive_trust/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:drive_trust/features/auth/domain/repositories/auth_repository.dart';
import 'package:drive_trust/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:drive_trust/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:drive_trust/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:drive_trust/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  //! External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
