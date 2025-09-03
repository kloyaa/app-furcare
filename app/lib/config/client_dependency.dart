import 'package:furcare_app/config/dependency_instance.dart';
import 'package:furcare_app/data/datasources/remote/client_romote_datasource.dart';
import 'package:furcare_app/data/repositories/client_repository.dart';
import 'package:furcare_app/presentation/providers/client_provider.dart';

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
    () => ClientRepositoryImpl(remoteDataSource: getIt()),
  );

  // Providers go here
  getIt.registerLazySingleton(() => ClientProvider(clientRepository: getIt()));
}
