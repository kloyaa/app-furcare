import 'package:flutter_application_1/config/dependency_instance.dart';
import 'package:flutter_application_1/data/datasources/remote/pet_service_remode_datasource.dart';
import 'package:flutter_application_1/data/repositories/pet_service_repository.dart';
import 'package:flutter_application_1/presentation/providers/pet_service_provider.dart';

Future<void> petServiceDependencyInjection() async {
  // DataSource goes here
  getIt.registerLazySingleton<PetServiceRemoteDataSource>(
    () => PetServiceRemoteDataSourceImpl(
      networkService: getIt(),
      authHeaderProvider: getIt(),
    ),
  );

  // Repository goes here
  getIt.registerLazySingleton<PetServiceRepository>(
    () => PetServiceRepositoryImpl(remoteDataSource: getIt()),
  );

  // Providers go here
  getIt.registerLazySingleton(
    () => PetServiceProvider(petServiceRepository: getIt()),
  );
}
