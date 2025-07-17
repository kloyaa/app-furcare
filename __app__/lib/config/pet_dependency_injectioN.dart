import 'package:flutter_application_1/config/dependency_instance.dart';
import 'package:flutter_application_1/data/datasources/remote/pet_remote_datasource.dart';
import 'package:flutter_application_1/data/repositories/pet_repository.dart';
import 'package:flutter_application_1/presentation/providers/pet_provider.dart';

Future<void> petDependencyInjection() async {
  // DataSource goes here
  getIt.registerLazySingleton<PetRemoteDataSource>(
    () => PetRemoteDataSourceImpl(
      networkService: getIt(),
      authHeaderProvider: getIt(),
    ),
  );

  // Repository goes here
  getIt.registerLazySingleton<PetRepository>(
    () => PetRepositoryImpl(remoteDataSource: getIt()),
  );

  // Providers go here
  getIt.registerLazySingleton(() => PetProvider(petRepository: getIt()));
}
