import 'package:furcare_app/config/dependency_instance.dart';
import 'package:furcare_app/core/network/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> coreDependencyInjection() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Network service
  getIt.registerLazySingleton(() => NetworkService());
}
