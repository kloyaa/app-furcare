import 'package:flutter/material.dart';
import 'package:furcare_app/presentation/screens/shared/splash_screen.dart';
import 'package:furcare_app/presentation/screens/staff/home.dart';
import 'package:furcare_app/presentation/screens/staff/login.dart';
import 'package:furcare_app/presentation/screens/staff/profile/profile.dart';
import 'package:furcare_app/presentation/screens/staff/profile/profile_edit.dart';
import 'package:go_router/go_router.dart';

class _StaffProfileRoutes {
  const _StaffProfileRoutes();

  final String profile = '/profile';
  final String profileEdit = '/profile/edit';
}

class StaffRoute {
  static const String root = '/';

  static const String login = '/login';
  static const String home = '/home';

  static const profile = _StaffProfileRoutes();
}

final GoRouter staffRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: StaffRoute.root,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <GoRoute>[
        GoRoute(
          path: StaffRoute.login,
          builder: (BuildContext context, GoRouterState state) {
            return const StaffLoginScreen();
          },
        ),
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return const StaffHomeScreen();
          },
        ),

        // Profile
        GoRoute(
          path: StaffRoute.profile.profile,
          builder: (BuildContext context, GoRouterState state) {
            return const StaffProfileScreen();
          },
        ),
        GoRoute(
          path: StaffRoute.profile.profileEdit,
          builder: (BuildContext context, GoRouterState state) {
            return const StaffUpdateProfileScreen();
          },
        ),
      ],
    ),
  ],
);
