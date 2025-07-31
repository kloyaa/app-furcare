import 'package:flutter_application_1/config/dependency_instance.dart';
import 'package:flutter_application_1/data/datasources/remote/client_romote_datasource.dart';
import 'package:flutter_application_1/data/repositories/client_repository.dart';
import 'package:flutter_application_1/presentation/providers/client_provider.dart';

Future<void> clientDependencyInjection() async {
  // DataSource goes here
  getIt.registerLazySingleton<ClientRemoteDataSource>(
    () => ClientRemoteDataSourceImpl(
      networkService: getIt(),
      authHeaderProvider: getIt(),
    ),
  );

  // Repository goes here
  getIt.registerLazySingleton<ClientRepository>(
    () => ClientRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  // Providers go here
  getIt.registerLazySingleton(() => ClientProvider(clientRepository: getIt()));
}
