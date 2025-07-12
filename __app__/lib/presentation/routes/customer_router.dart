import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/home.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/index.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/registration.dart';
import 'package:flutter_application_1/presentation/screens/shared/change_theme.dart';
import 'package:go_router/go_router.dart';

final GoRouter customerRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const CustomerMainScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/registration',
          builder: (BuildContext context, GoRouterState state) {
            return const RegistrationScreen();
          },
        ),
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return const CustomerHomeScreen();
          },
        ),
        GoRoute(
          path: '/settings/theme',
          builder: (BuildContext context, GoRouterState state) {
            return const ThemeToggleScreen();
          },
        ),
      ],
    ),
  ],
);
