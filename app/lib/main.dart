import 'package:flutter/material.dart';
import 'package:furcare_app/config/activity_dependency.dart';
import 'package:furcare_app/config/admin_dependency.dart';
import 'package:furcare_app/config/appointment_dependency.dart';
import 'package:furcare_app/config/authentication_dependency.dart';
import 'package:furcare_app/config/branch_dependency.dart';
import 'package:furcare_app/config/client_dependency.dart';
import 'package:furcare_app/config/core_dependency.dart';
import 'package:furcare_app/config/dependency_instance.dart';
import 'package:furcare_app/config/health_check_dependency.dart';
import 'package:furcare_app/config/payment_dependency.dart';
import 'package:furcare_app/config/pet_dependency.dart';
import 'package:furcare_app/config/pet_service_dependency.dart';
import 'package:furcare_app/core/theme/theme_notifier.dart';
import 'package:furcare_app/presentation/providers/activity_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_application_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_payment_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_statistics_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_user_provider.dart';
import 'package:furcare_app/presentation/providers/appointment_provider.dart';
import 'package:furcare_app/presentation/providers/auth_provider.dart';
import 'package:furcare_app/presentation/providers/branch_provider.dart';
import 'package:furcare_app/presentation/providers/client_provider.dart';
import 'package:furcare_app/presentation/providers/health_check_provider.dart';
import 'package:furcare_app/presentation/providers/payment_provider.dart';
import 'package:furcare_app/presentation/providers/pet_provider.dart';
import 'package:furcare_app/presentation/providers/pet_service_provider.dart';
import 'package:furcare_app/presentation/providers/staff/appointment_provider.dart';
import 'package:furcare_app/presentation/routes/admin_router.dart';
// import 'package:furcare_app/presentation/routes/customer_router.dart';
// import 'package:furcare_app/presentation/routes/staff_router.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeNotifier.initializeTheme();

  await healthCheckDependencies();
  await coreDependencyInjection();
  await authDependencyInjection();
  await clientDependencyInjection();
  await activityDependencyInjection();
  await petServiceDependencyInjection();
  await petDependencyInjection();
  await appointmentDependencyInjection();
  await branchDependencyInjection();
  await paymentDependencyInjection();
  await adminDependencyInjection();

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
                ChangeNotifierProvider(
                  create: (_) => getIt<HealthCheckProvider>(),
                ),
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
                ChangeNotifierProvider(create: (_) => getIt<PaymentProvider>()),
                ChangeNotifierProvider(
                  create: (_) => getIt<PaymentSettingsProvider>(),
                ),

                // Staff
                ChangeNotifierProvider(
                  create: (_) => getIt<StaffAppointmentProvider>(),
                ),

                // Admin Providers
                ChangeNotifierProvider(
                  create: (_) => getIt<AdminUserProvider>(),
                ),
                ChangeNotifierProvider(
                  create: (_) => getIt<AdminApplicationProvider>(),
                ),
                ChangeNotifierProvider(
                  create: (_) => getIt<AdminStatisticsProvider>(),
                ),
                ChangeNotifierProvider(
                  create: (_) => getIt<AdminPaymentProvider>(),
                ),
                ChangeNotifierProvider(create: (_) => getIt<AdminProvider>()),
              ],
              child: MaterialApp.router(
                theme: ThemeNotifier.lightTheme,
                darkTheme: ThemeNotifier.darkTheme,
                themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                // routerConfig: customerRouter,
                // routerConfig: staffRouter,
                routerConfig: adminRouter,
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
