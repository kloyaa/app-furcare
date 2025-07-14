import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/dependency_injection.dart';
import 'package:flutter_application_1/presentation/providers/activity_provider.dart';
import 'package:flutter_application_1/presentation/providers/auth_provider.dart';
import 'package:flutter_application_1/presentation/providers/client_provider.dart';
import 'package:flutter_application_1/presentation/routes/customer_router.dart';
import 'package:flutter_application_1/presentation/widgets/common/theme_toggle_button.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection(); // Add this line to initialize GetIt
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeNotifier.isDarkMode,
      builder: (context, isDarkMode, _) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
            ChangeNotifierProvider(create: (_) => getIt<ClientProvider>()),
            ChangeNotifierProvider(create: (_) => getIt<ActivityProvider>()),
          ],
          child: MaterialApp.router(
            theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
            routerConfig: customerRouter,
            // routerConfig: customerRouter,
            // routerConfig: customerRouter,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
