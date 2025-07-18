import 'package:flutter_application_1/config/dependency_instance.dart';
import 'package:flutter_application_1/data/datasources/remote/appointment_remote_datasource.dart';
import 'package:flutter_application_1/data/repositories/appointment_repository.dart';
import 'package:flutter_application_1/presentation/providers/application_provider.dart';

Future<void> appointmentDependencyInjection() async {
  // DataSource goes here
  getIt.registerLazySingleton<AppointmentRemoteDatasource>(
    () => AppointmentRemoteDatasourceImpl(
      networkService: getIt(),
      authHeaderProvider: getIt(),
    ),
  );

  // Repository goes here
  getIt.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(remoteDataSource: getIt()),
  );

  // Providers go here
  getIt.registerLazySingleton(
    () => AppointmentProvider(appointmentRepository: getIt()),
  );
}
