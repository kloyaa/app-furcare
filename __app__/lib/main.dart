import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/activity_dependency_injection.dart';
import 'package:flutter_application_1/config/auth_dependency_injection.dart';
import 'package:flutter_application_1/config/client_dependency_injection.dart';
import 'package:flutter_application_1/config/core_dependency_injection.dart';
import 'package:flutter_application_1/config/dependency_instance.dart';
import 'package:flutter_application_1/config/pet_service_dependency_injection.dart';
import 'package:flutter_application_1/core/theme/theme_notifier.dart';
import 'package:flutter_application_1/presentation/providers/activity_provider.dart';
import 'package:flutter_application_1/presentation/providers/auth_provider.dart';
import 'package:flutter_application_1/presentation/providers/client_provider.dart';
import 'package:flutter_application_1/presentation/providers/pet_service_provider.dart';
import 'package:flutter_application_1/presentation/routes/customer_router.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeNotifier.initializeTheme();

  await coreDependencyInjection();
  await authDependencyInjection();
  await clientDependencyInjection();
  await activityDependencyInjection();
  await petServiceDependencyInjection();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeNotifier.isDarkMode,
      builder: (context, isDarkMode, _) {
        return ValueListenableBuilder<ThemeColorData>(
          valueListenable: ThemeNotifier.selectedColor,
          builder: (context, value, child) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
                ChangeNotifierProvider(create: (_) => getIt<ClientProvider>()),
                ChangeNotifierProvider(
                  create: (_) => getIt<ActivityProvider>(),
                ),
                ChangeNotifierProvider(
                  create: (_) => getIt<PetServiceProvider>(),
                ),
              ],
              child: MaterialApp.router(
                theme: ThemeNotifier.lightTheme,
                darkTheme: ThemeNotifier.darkTheme,
                themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                routerConfig: customerRouter,
                // routerConfig: customerRouter,
                // routerConfig: customerRouter,
                debugShowCheckedModeBanner: false,
              ),
            );
          },
        );
      },
    );
  }
}
