import 'package:furcare_app/config/dependency_instance.dart';
import 'package:furcare_app/data/datasources/remote/branch_remote_datasource.dart';
import 'package:furcare_app/data/repositories/branch_repository.dart';
import 'package:furcare_app/presentation/providers/branch_provider.dart';

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
