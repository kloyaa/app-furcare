import 'package:flutter_application_1/config/dependency_instance.dart';
import 'package:flutter_application_1/data/datasources/remote/activity_remote_datasource.dart';
import 'package:flutter_application_1/data/repositories/activity_repository.dart';
import 'package:flutter_application_1/presentation/providers/activity_provider.dart';

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
