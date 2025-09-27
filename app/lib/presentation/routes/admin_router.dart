import 'package:flutter/material.dart';
import 'package:furcare_app/presentation/screens/admin/admin_dashboard_screen.dart';
import 'package:furcare_app/presentation/screens/admin/admin_reports_screen.dart';
import 'package:furcare_app/presentation/screens/admin/admin_services_screen.dart';
import 'package:furcare_app/presentation/screens/admin/admin_users_screen.dart';
import 'package:furcare_app/presentation/screens/admin/admin_layout_screen.dart';
import 'package:furcare_app/presentation/screens/admin/login.dart';
import 'package:furcare_app/presentation/screens/shared/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AdminRoute {
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String activities = '/activity';
  static const String users = '/admin/users';
  static const String reports = '/admin/reports';
  static const String appointments = '/admin/appointments';
}

final GoRouter adminRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: AdminRoute.root,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <GoRoute>[
        // Login route (no layout wrapper)
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const AdminLoginScreen();
          },
        ),

        // Home/Dashboard route with layout
        GoRoute(
          path: AdminRoute.home,
          builder: (BuildContext context, GoRouterState state) {
            return AdminLayoutScreen(
              currentRoute: AdminRoute.home,
              child: const AdminDashboardScreen(),
            );
          },
        ),

        // Admin Users route with layout
        GoRoute(
          path: AdminRoute.users,
          builder: (BuildContext context, GoRouterState state) {
            return AdminLayoutScreen(
              currentRoute: AdminRoute.users,
              child: const AdminUsersScreen(),
            );
          },
        ),

        // Admin Reports route with layout
        GoRoute(
          path: AdminRoute.reports,
          builder: (BuildContext context, GoRouterState state) {
            return AdminLayoutScreen(
              currentRoute: AdminRoute.reports,
              child: const AdminReportsScreen(),
            );
          },
        ),

        // Activities route (if you want to add layout here too)
        GoRoute(
          path: AdminRoute.activities,
          builder: (BuildContext context, GoRouterState state) {
            return AdminLayoutScreen(
              currentRoute: AdminRoute.activities,
              child: const Placeholder(), // Replace with your activities screen
            );
          },
        ),

        // Admin Appointments route (if you want to add layout here too)
        GoRoute(
          path: AdminRoute.appointments,
          builder: (BuildContext context, GoRouterState state) {
            return AdminLayoutScreen(
              currentRoute: AdminRoute.appointments,
              child:
                  const AdminServicesScreen(), // Replace with your appointments screen
            );
          },
        ),
      ],
    ),
  ],
);
