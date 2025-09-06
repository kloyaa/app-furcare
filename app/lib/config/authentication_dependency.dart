import 'package:furcare_app/config/dependency_instance.dart';
import 'package:furcare_app/data/datasources/remote/auth_header_provider.dart';
import 'package:furcare_app/data/datasources/local/auth_local_datasource.dart';
import 'package:furcare_app/data/datasources/remote/auth_remote_datasource.dart';
import 'package:furcare_app/data/repositories/auth_repository.dart';
import 'package:furcare_app/presentation/providers/auth_provider.dart';

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
