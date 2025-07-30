import 'package:flutter_application_1/config/dependency_instance.dart';
import 'package:flutter_application_1/data/datasources/remote/branch_remote_datasource.dart';
import 'package:flutter_application_1/data/repositories/branch_repository.dart';
import 'package:flutter_application_1/presentation/providers/branch_provider.dart';

Future<void> branchDependencyInjection() async {
  // DataSource goes here
  getIt.registerLazySingleton<BranchRemoteDataSource>(
    () => BranchRemoteDataSourceImpl(
      networkService: getIt(),
      authHeaderProvider: getIt(),
    ),
  );

  // Repository goes here
  getIt.registerLazySingleton<BranchRepository>(
    () => BranchRepositoryImpl(remoteDataSource: getIt()),
  );

  // Providers go here
  getIt.registerLazySingleton(() => BranchProvider(branchRepository: getIt()));
}
