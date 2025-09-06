import 'package:furcare_app/config/dependency_instance.dart';
import 'package:furcare_app/data/datasources/remote/admin/admin_remote_datasource.dart';
import 'package:furcare_app/data/repositories/admin/admin_repository.dart';
import 'package:furcare_app/presentation/providers/admin/admin_application_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_payment_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_statistics_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_user_provider.dart';

Future<void> adminDependencyInjection() async {
  // DataSource
  getIt.registerLazySingleton<AdminRemoteDatasource>(
    () => AdminRemoteDatasourceImpl(
      networkService: getIt(),
      authHeaderProvider: getIt(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: getIt()),
  );

  // Individual Providers
  getIt.registerLazySingleton(() => AdminUserProvider(repository: getIt()));
  getIt.registerLazySingleton(
    () => AdminApplicationProvider(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => AdminStatisticsProvider(repository: getIt()),
  );
  getIt.registerLazySingleton(() => AdminPaymentProvider(repository: getIt()));

  // Main coordinator provider
  getIt.registerLazySingleton(
    () => AdminProvider(
      userProvider: getIt<AdminUserProvider>(),
      applicationProvider: getIt<AdminApplicationProvider>(),
      statisticsProvider: getIt<AdminStatisticsProvider>(),
      paymentProvider: getIt<AdminPaymentProvider>(),
    ),
  );
}
