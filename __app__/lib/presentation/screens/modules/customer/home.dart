import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/helpers/theme.dart';
import 'package:flutter_application_1/presentation/providers/client_provider.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/tabs/appoimtents.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/tabs/settings.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_bottomnav.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _currentIndex = 0;

  // Define your navigation items here - easily add more!
  late final List<BottomNavItem> _navItems;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientProvider>().getProfile();
    });

    _navItems = [
      BottomNavItem(
        icon: Icons.calendar_month_outlined,
        activeIcon: Icons.calendar_month,
        label: 'Appointments',
        screen: const AppointmentTabScreen(),
      ),
      BottomNavItem(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        label: 'Settings',
        screen: const SettingsTabScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProvider>(
      builder: (context, clientProvider, child) {
        if (clientProvider.isLoading) {
          return Scaffold(
            body: Center(
              child: SpinKitThreeBounce(
                color: ThemeHelper.getOnBackgroundTextColor(context),
                size: 24.0,
              ),
            ),
          );
        }

        if (clientProvider.errorCode == "02") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.push("/me/profile/create");
          });
        }

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _navItems
                .map(
                  (item) => KeyedSubtree(
                    key: ValueKey(_currentIndex == _navItems.indexOf(item)),
                    child: item.screen,
                  ),
                )
                .toList(),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            items: _navItems,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
