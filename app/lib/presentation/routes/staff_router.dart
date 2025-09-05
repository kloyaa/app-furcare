import 'package:flutter/material.dart';
import 'package:furcare_app/presentation/screens/shared/activity_log.dart';
import 'package:furcare_app/presentation/screens/shared/change_password.dart';
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

class _StaffUserRoutes {
  const _StaffUserRoutes();

  final String changePassword = '/change-password';
}

class StaffRoute {
  static const String root = '/';

  static const String login = '/login';
  static const String home = '/home';

  static const String activities = '/activity';

  static const profile = _StaffProfileRoutes();
  static const user = _StaffUserRoutes();
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
        GoRoute(
          path: StaffRoute.activities,
          builder: (BuildContext context, GoRouterState state) {
            return const ActivityLogScreen();
          },
        ),

        // User
        GoRoute(
          path: StaffRoute.user.changePassword,
          builder: (BuildContext context, GoRouterState state) {
            return const ChangePasswordScreen();
          },
        ),
      ],
    ),
  ],
);
