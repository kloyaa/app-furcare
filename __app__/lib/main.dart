import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/routes/customer_router.dart';
import 'package:flutter_application_1/presentation/widgets/common/theme_toggle_button.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeNotifier.isDarkMode,
      builder: (context, isDarkMode, _) {
        return MaterialApp.router(
          theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          routerConfig: customerRouter,
          // routerConfig: customerRouter,
          // routerConfig: customerRouter,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
