import 'package:furcare_app/config/dependency_instance.dart';
import 'package:furcare_app/data/datasources/remote/activity_remote_datasource.dart';
import 'package:furcare_app/data/repositories/activity_repository.dart';
import 'package:furcare_app/presentation/providers/activity_provider.dart';

Future<void> activityDependencyInjection() async {
  // DataSource goes here
  getIt.registerLazySingleton<ActivityRemoteDatasource>(
    () => ActivityRemoteDatasourceImpl(
      networkService: getIt(),
      authHeaderProvider: getIt(),
    ),
  );

  // Repository goes here
  getIt.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(remoteDataSource: getIt()),
  );

  // Providers go here
  getIt.registerLazySingleton(
    () => ActivityProvider(activityRepository: getIt()),
  );
}
