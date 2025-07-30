import 'package:flutter_application_1/config/dependency_instance.dart';
import 'package:flutter_application_1/core/network/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> coreDependencyInjection() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Network service
  getIt.registerLazySingleton(() => NetworkService());
}
