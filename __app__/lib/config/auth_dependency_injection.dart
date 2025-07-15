import 'package:flutter_application_1/config/dependency_instance.dart';
import 'package:flutter_application_1/data/datasources/remote/auth_header_provider.dart';
import 'package:flutter_application_1/data/datasources/remote/auth_local_datasource.dart';
import 'package:flutter_application_1/data/datasources/remote/auth_remote_datasource.dart';
import 'package:flutter_application_1/data/repositories/auth_repository.dart';
import 'package:flutter_application_1/presentation/providers/auth_provider.dart';

Future<void> authDependencyInjection() async {
  // DataSource goes here
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      networkService: getIt(),
      authHeaderProvider: getIt(),
    ),
  );

  // Repository goes here
  getIt.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(remoteDataSource: getIt(), localDataSource: getIt()),
  );

  // Providers go here
  getIt.registerLazySingleton<AuthHeaderProvider>(
    () => AuthHeaderProvider(authLocalDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => AuthProvider(authRepository: getIt()));
}
