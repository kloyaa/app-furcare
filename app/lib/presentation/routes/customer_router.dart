import 'package:flutter/material.dart';
import 'package:furcare_app/core/utils/navigation_logger.dart';
import 'package:furcare_app/presentation/screens/customer/payments/bank/bank_payment.dart';
import 'package:furcare_app/presentation/screens/customer/payments/bank/bank_payment_receipt.dart';
import 'package:furcare_app/presentation/screens/customer/payments/ewallet/gcash/gcash_payment.dart';
import 'package:furcare_app/presentation/screens/customer/payments/ewallet/gcash/gcash_payment_receipt.dart';
import 'package:furcare_app/presentation/screens/customer/payments/otc_payment.dart';
import 'package:furcare_app/presentation/screens/customer/payments/payment_methods.dart';
import 'package:furcare_app/presentation/screens/customer/tabs/settings_subitems/accounts.dart';
import 'package:furcare_app/presentation/screens/customer/appointments/boarding/boarding_appointment_create.dart';
import 'package:furcare_app/presentation/screens/customer/appointments/home_service/home_service_appointment_create.dart';
import 'package:furcare_app/presentation/screens/customer/pets/pet_create.dart';
import 'package:furcare_app/presentation/screens/customer/pets/pet_edit.dart';
import 'package:furcare_app/presentation/screens/customer/pets/pets.dart';
import 'package:furcare_app/presentation/screens/customer/appointments/grooming/grooming_appointment_create.dart';
import 'package:furcare_app/presentation/screens/customer/home.dart';
import 'package:furcare_app/presentation/screens/customer/login.dart';
import 'package:furcare_app/presentation/screens/customer/pre_login.dart';
import 'package:furcare_app/presentation/screens/customer/tabs/settings_subitems/security.dart';
import 'package:furcare_app/presentation/screens/customer/profile/profile_edit.dart';
import 'package:furcare_app/presentation/screens/customer/profile/profile.dart';
import 'package:furcare_app/presentation/screens/customer/profile/profile_create.dart';
import 'package:furcare_app/presentation/screens/customer/registration.dart';
import 'package:furcare_app/presentation/screens/shared/activity_log.dart';
import 'package:furcare_app/presentation/screens/shared/change_password.dart';
import 'package:furcare_app/presentation/screens/shared/change_theme.dart';
import 'package:furcare_app/presentation/screens/shared/splash_screen.dart';
import 'package:go_router/go_router.dart';

// Named imports
import 'package:furcare_app/presentation/screens/customer/appointments/grooming/grooming_appointment_list.dart'
    as grooming;
import 'package:furcare_app/presentation/screens/customer/appointments/boarding/boarding_appointment_list.dart'
    as boarding;

import 'package:furcare_app/presentation/screens/customer/appointments/home_service/home_service_appointment_list.dart'
    as home_service;

class _CreateBookingRoutes {
  const _CreateBookingRoutes();

  final String grooming = '/appointments/grooming';
  final String boarding = '/appointments/boarding';
  final String homeService = '/appointments/home-service';
}

class _GetBookingRoutes {
  const _GetBookingRoutes();

  final String grooming = '/me/appointments/grooming';
  final String boarding = '/me/appointments/boarding';
  final String homeService = '/me/appointments/home-service';
}

class _PaymentRoutes {
  const _PaymentRoutes();

  final String paymentMethods = '/payment/methods';
  final String bankPayment = '/payment/bank';
  final String ewalletGcashPayment = '/payment/ewallet/gcash';
  final String ewalletMayaPayment = '/payment/ewallet/maya';
  final String otcPayment = '/payment/otc';
}

class _PaymentReceiptRoutes {
  const _PaymentReceiptRoutes();

  final String bankReceipt = '/receipt/bank';
  final String ewalletReceipt = '/receipt/ewallet';
  final String ewalletGcashReceipt = '/receipt/ewallet/gcash';
  final String ewalletMayaReceipt = '/receipt/ewallet/maya';
  final String otcReceipt = '/receipt/bank/otc';
}

class CustomerRoute {
  static const String root = '/';
  static const String preLogin = '/pre-login';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String home = '/home';

  static const create = _CreateBookingRoutes();
  static const me = _GetBookingRoutes();
  static const payment = _PaymentRoutes();
  static const receipt = _PaymentReceiptRoutes();

  // Pets
  static const String pets = '/me/pets';
  static const String createPet = '/me/pets/create';
  static const String editPet = '/me/pets/edit';

  // Profile
  static const String profile = '/me/profile';
  static const String createProfile = '/me/profile/create';
  static const String updateProfile = '/me/profile/update';

  // Settings
  static const String accountAndCompanions = '/settings/accounts';
  static const String accountSecurity = '/settings/privacy';

  // Shared
  static const String settingsTheme = '/settings/theme';
  static const String changePassword = '/settings/privacy/change-password';
  static const String settingsActivityLog = '/settings/activity-log';
}

final GoRouter customerRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: CustomerRoute.root,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: CustomerRoute.preLogin,
          builder: (BuildContext context, GoRouterState state) {
            return const CustomerPreLoginScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.login,
          builder: (BuildContext context, GoRouterState state) {
            return const CustomerLoginScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.registration,
          builder: (BuildContext context, GoRouterState state) {
            return const RegistrationScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.home,
          builder: (BuildContext context, GoRouterState state) {
            return const CustomerHomeScreen();
          },
        ),

        GoRoute(
          path: CustomerRoute.create.grooming,
          builder: (BuildContext context, GoRouterState state) {
            return const GroomingApptScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.create.boarding,
          builder: (BuildContext context, GoRouterState state) {
            return const BoardingApptScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.create.homeService,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeServiceApptScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.pets,
          builder: (BuildContext context, GoRouterState state) {
            return const PetsScreen();
          },
        ),

        GoRoute(
          path: CustomerRoute.editPet,
          builder: (BuildContext context, GoRouterState state) {
            return const CompanionEdit();
          },
        ),
        GoRoute(
          path: CustomerRoute.me.grooming,
          builder: (BuildContext context, GoRouterState state) {
            return const grooming.AppointmentsScreen();
          },
        ),

        GoRoute(
          path: CustomerRoute.me.boarding,
          builder: (BuildContext context, GoRouterState state) {
            return const boarding.AppointmentsScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.me.homeService,
          builder: (BuildContext context, GoRouterState state) {
            return const home_service.AppointmentsScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.createPet,
          builder: (BuildContext context, GoRouterState state) {
            return const CompanionCreationScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.profile,
          builder: (BuildContext context, GoRouterState state) {
            return const CustomerProfileScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.createProfile,
          builder: (BuildContext context, GoRouterState state) {
            return const CustomerProfileCreationScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.updateProfile,
          builder: (BuildContext context, GoRouterState state) {
            return const CustomerUpdateProfileScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.accountAndCompanions,
          builder: (BuildContext context, GoRouterState state) {
            return const AccountsScreen();
          },
        ),
        // Privacy screen
        GoRoute(
          path: CustomerRoute.accountSecurity,
          builder: (BuildContext context, GoRouterState state) {
            return const PrivacyScreen();
          },
        ),

        // Shared routes
        GoRoute(
          path: CustomerRoute.settingsTheme,
          builder: (BuildContext context, GoRouterState state) {
            return const ThemeToggleScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.settingsActivityLog,
          builder: (BuildContext context, GoRouterState state) {
            return const ActivityLogScreen();
          },
        ),

        GoRoute(
          path: CustomerRoute.changePassword,
          builder: (BuildContext context, GoRouterState state) {
            return const ChangePasswordScreen();
          },
        ),

        GoRoute(
          path: CustomerRoute.payment.paymentMethods,
          builder: (BuildContext context, GoRouterState state) {
            return const PaymentMethodsScreen();
          },
        ),

        GoRoute(
          path: CustomerRoute.payment.otcPayment,
          builder: (BuildContext context, GoRouterState state) {
            return const OTCPaymentReceiptScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.payment.bankPayment,
          builder: (BuildContext context, GoRouterState state) {
            return const BankPaymentScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.receipt.bankReceipt,
          builder: (BuildContext context, GoRouterState state) {
            return const BankPaymentReceiptScreen();
          },
        ),
        GoRoute(
          path: CustomerRoute.payment.ewalletGcashPayment,
          builder: (BuildContext context, GoRouterState state) {
            return const GCashPaymentScreen();
          },
        ),

        GoRoute(
          path: CustomerRoute.receipt.ewalletGcashReceipt,
          builder: (BuildContext context, GoRouterState state) {
            return const GCashPaymentReceiptScreen();
          },
        ),
      ],
    ),
  ],
  observers: [NavigationLogger()],
);
