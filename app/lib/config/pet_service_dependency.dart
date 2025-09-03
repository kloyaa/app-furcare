import 'package:furcare_app/config/dependency_instance.dart';
import 'package:furcare_app/data/datasources/remote/pet_service_remote_datasource.dart';
import 'package:furcare_app/data/repositories/pet_service_repository.dart';
import 'package:furcare_app/presentation/providers/pet_service_provider.dart';

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
