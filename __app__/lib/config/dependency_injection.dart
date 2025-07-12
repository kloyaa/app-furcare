// lib/config/dependency_injection.dart
import 'package:flutter_application_1/core/network/network_service.dart';
import 'package:flutter_application_1/data/datasources/remote/auth_local_datasource.dart';
import 'package:flutter_application_1/data/datasources/remote/auth_remote_datasource.dart';
import 'package:flutter_application_1/data/repositories/auth_repository.dart';
import 'package:flutter_application_1/presentation/providers/auth_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Core
  getIt.registerLazySingleton(() => NetworkService());

  // Data sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(networkService: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(remoteDataSource: getIt(), localDataSource: getIt()),
  );

  // Providers
  getIt.registerLazySingleton(() => AuthProvider(authRepository: getIt()));
}
