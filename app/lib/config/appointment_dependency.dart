import 'package:furcare_app/config/dependency_instance.dart';
import 'package:furcare_app/data/datasources/remote/appointment_remote_datasource.dart';
import 'package:furcare_app/data/repositories/appointment_repository.dart';
import 'package:furcare_app/presentation/providers/appointment_provider.dart';
import 'package:furcare_app/presentation/providers/staff/appointment_provider.dart';

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

  getIt.registerLazySingleton(
    () => StaffAppointmentProvider(
      appointmentRepository: AppointmentRepositoryImpl(
        remoteDataSource: getIt(),
      ),
    ),
  );
}
