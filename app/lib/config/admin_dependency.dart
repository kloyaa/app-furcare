import 'package:furcare_app/config/dependency_instance.dart';
import 'package:furcare_app/data/datasources/remote/admin/admin_remote_datasource.dart';
import 'package:furcare_app/data/repositories/admin/admin_repository.dart';
import 'package:furcare_app/presentation/providers/admin/admin_provider.dart';

Future<void> adminDependencyInjection() async {
  // DataSource goes here
  getIt.registerLazySingleton<AdminRemoteDatasource>(
    () => AdminRemoteDatasourceImpl(
      networkService: getIt(),
      authHeaderProvider: getIt(),
    ),
  );

  // Repository goes here
  getIt.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: getIt()),
  );

  // Providers go here
  getIt.registerLazySingleton(() => AdminProvider(adminRepository: getIt()));
}
