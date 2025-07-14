// lib/config/dependency_injection.dart
import 'package:flutter_application_1/core/network/network_service.dart';
import 'package:flutter_application_1/data/datasources/remote/activity_remote_datasource.dart';
import 'package:flutter_application_1/data/datasources/remote/auth_header_provider.dart';
import 'package:flutter_application_1/data/datasources/remote/auth_local_datasource.dart';
import 'package:flutter_application_1/data/datasources/remote/auth_remote_datasource.dart';
import 'package:flutter_application_1/data/datasources/remote/client_romote_datasource.dart';
import 'package:flutter_application_1/data/repositories/activity_repository.dart';
import 'package:flutter_application_1/data/repositories/auth_repository.dart';
import 'package:flutter_application_1/data/repositories/client_repository.dart';
import 'package:flutter_application_1/presentation/providers/activity_provider.dart';
import 'package:flutter_application_1/presentation/providers/auth_provider.dart';
import 'package:flutter_application_1/presentation/providers/client_provider.dart';
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

  getIt.registerLazySingleton<AuthHeaderProvider>(
    () => AuthHeaderProvider(authLocalDataSource: getIt()),
  );

  getIt.registerLazySingleton<ClientRemoteDataSource>(
    () => ClientRemoteDataSourceImpl(
      networkService: getIt(),
      authHeaderProvider: getIt(),
    ),
  );

  getIt.registerLazySingleton<ActivityRemoteDatasource>(
    () => ActivityRemoteDatasourceImpl(
      networkService: getIt(),
      authHeaderProvider: getIt(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(remoteDataSource: getIt(), localDataSource: getIt()),
  );
  getIt.registerLazySingleton<ClientRepository>(
    () => ClientRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(remoteDataSource: getIt()),
  );

  // Providers
  getIt.registerLazySingleton(() => AuthProvider(authRepository: getIt()));
  getIt.registerLazySingleton(() => ClientProvider(clientRepository: getIt()));
  getIt.registerLazySingleton(
    () => ActivityProvider(activityRepository: getIt()),
  );
}
