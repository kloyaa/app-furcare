import 'package:flutter/material.dart';
import 'package:furcare_app/config/activity_dependency_injection.dart';
import 'package:furcare_app/config/appointment_injection.dart';
import 'package:furcare_app/config/auth_dependency_injection.dart';
import 'package:furcare_app/config/branch_injection.dart';
import 'package:furcare_app/config/client_dependency_injection.dart';
import 'package:furcare_app/config/core_dependency_injection.dart';
import 'package:furcare_app/config/dependency_instance.dart';
import 'package:furcare_app/config/pet_dependency_injectioN.dart';
import 'package:furcare_app/config/pet_service_dependency_injection.dart';
import 'package:furcare_app/core/theme/theme_notifier.dart';
import 'package:furcare_app/presentation/providers/activity_provider.dart';
import 'package:furcare_app/presentation/providers/appointment_provider.dart';
import 'package:furcare_app/presentation/providers/auth_provider.dart';
import 'package:furcare_app/presentation/providers/branch_provider.dart';
import 'package:furcare_app/presentation/providers/client_provider.dart';
import 'package:furcare_app/presentation/providers/pet_provider.dart';
import 'package:furcare_app/presentation/providers/pet_service_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeNotifier.initializeTheme();

  await coreDependencyInjection();
  await authDependencyInjection();
  await clientDependencyInjection();
  await activityDependencyInjection();
  await petServiceDependencyInjection();
  await petDependencyInjection();
  await appointmentDependencyInjection();
  await branchDependencyInjection();

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
                ChangeNotifierProvider(create: (_) => getIt<PetProvider>()),
                ChangeNotifierProvider(
                  create: (_) => getIt<AppointmentProvider>(),
                ),
                ChangeNotifierProvider(create: (_) => getIt<BranchProvider>()),
              ],
              child: MaterialApp.router(
                theme: ThemeNotifier.lightTheme,
                darkTheme: ThemeNotifier.darkTheme,
                themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                routerConfig: customerRouter,
                // routerConfig: customerRouter,
                // routerConfig: customerRouter,
                debugShowCheckedModeBanner: false,
                title: 'Furcare',
              ),
            );
          },
        );
      },
    );
  }
}
