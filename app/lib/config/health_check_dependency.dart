import 'package:furcare_app/config/dependency_instance.dart';
import 'package:furcare_app/data/datasources/remote/health_check_datasource.dart';
import 'package:furcare_app/data/repositories/health_check_repository.dart';
import 'package:furcare_app/presentation/providers/health_check_provider.dart';

Future<void> healthCheckDependencies() async {
  // Health Check Datasource
  getIt.registerLazySingleton<HealthCheckRemoteDataSource>(
    () => HealthCheckRemoteDataSourceImpl(
      networkService: getIt(), // Your existing NetworkService
    ),
  );

  // Health Check Repository
  getIt.registerLazySingleton<HealthCheckRepository>(
    () => HealthCheckRepositoryImpl(
      remoteDataSource: getIt<HealthCheckRemoteDataSource>(),
    ),
  );

  // Health Check Provider
  getIt.registerFactory<HealthCheckProvider>(
    () => HealthCheckProvider(repository: getIt<HealthCheckRepository>()),
  );
}
