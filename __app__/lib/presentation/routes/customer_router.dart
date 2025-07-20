import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/accounts/accounts.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/companions/companion_create.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/companions/companions.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/appointments/get/appointments.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/appointments/create/appointment.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/home.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/login.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/pre_login.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/privacy/privacy.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/profile/customer_edit_profile.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/profile/customer_profile.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/profile/customer_profile_creation.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/registration.dart';
import 'package:flutter_application_1/presentation/screens/shared/activity_log.dart';
import 'package:flutter_application_1/presentation/screens/shared/change_password.dart';
import 'package:flutter_application_1/presentation/screens/shared/change_theme.dart';
import 'package:flutter_application_1/presentation/screens/shared/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter customerRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/pre-login',
          builder: (BuildContext context, GoRouterState state) {
            return const CustomerPreLoginScreen();
          },
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return const CustomerLoginScreen();
          },
        ),
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
          path: '/appointments/grooming',
          builder: (BuildContext context, GoRouterState state) {
            return const GroomingAppointmentScreen();
          },
        ),

        GoRoute(
          path: '/me/pets',
          builder: (BuildContext context, GoRouterState state) {
            return const PetsScreen();
          },
        ),

        GoRoute(
          path: '/me/appointments/grooming',
          builder: (BuildContext context, GoRouterState state) {
            return const GroomingAppointmentsScreen();
          },
        ),
        GoRoute(
          path: '/me/pets/create',
          builder: (BuildContext context, GoRouterState state) {
            return const CompanionCreationScreen();
          },
        ),
        GoRoute(
          path: '/me/profile',
          builder: (BuildContext context, GoRouterState state) {
            return const CustomerProfileScreen();
          },
        ),
        GoRoute(
          path: '/me/profile/create',
          builder: (BuildContext context, GoRouterState state) {
            return const CustomerProfileCreationScreen();
          },
        ),
        GoRoute(
          path: '/me/profile/update',
          builder: (BuildContext context, GoRouterState state) {
            return const CustomerUpdateProfileScreen();
          },
        ),

        GoRoute(
          path: '/settings/accounts',
          builder: (BuildContext context, GoRouterState state) {
            return const AccountsScreen();
          },
        ),

        // Privacy screen
        GoRoute(
          path: '/settings/privacy',
          builder: (BuildContext context, GoRouterState state) {
            return const PrivacyScreen();
          },
        ),

        // Shared routes
        GoRoute(
          path: '/settings/theme',
          builder: (BuildContext context, GoRouterState state) {
            return const ThemeToggleScreen();
          },
        ),
        GoRoute(
          path: '/settings/activity-log',
          builder: (BuildContext context, GoRouterState state) {
            return const ActivityLogScreen();
          },
        ),

        GoRoute(
          path: '/settings/privacy/change-password',
          builder: (BuildContext context, GoRouterState state) {
            return const ChangePasswordScreen();
          },
        ),
      ],
    ),
  ],
);
