import 'package:furcare_app/config/dependency_instance.dart';
import 'package:furcare_app/data/datasources/remote/payment_remote_datasource.dart';
import 'package:furcare_app/data/repositories/payment_repository.dart';
import 'package:furcare_app/presentation/providers/payment_provider.dart';

Future<void> paymentDependencyInjection() async {
  // DataSource goes here
  getIt.registerLazySingleton<PaymentRemoteDatasource>(
    () => PaymentRemoteDatasourceImpl(
      networkService: getIt(),
      authHeaderProvider: getIt(),
    ),
  );

  // Repository goes here
  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: getIt()),
  );

  // Providers go here
  getIt.registerLazySingleton(
    () => PaymentProvider(paymentRepository: getIt()),
  );

  getIt.registerLazySingleton(() => PaymentSettingsProvider());
}
