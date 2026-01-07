import 'package:flutter/material.dart';
import 'package:furcare_app/core/utils/theme.dart';
import 'package:furcare_app/presentation/providers/branch_provider.dart';
import 'package:furcare_app/presentation/providers/client_provider.dart';
import 'package:furcare_app/presentation/screens/customer/pets/pets.dart';
import 'package:furcare_app/presentation/screens/customer/tabs/home.dart';
import 'package:furcare_app/presentation/screens/customer/tabs/settings.dart';
import 'package:furcare_app/presentation/widgets/common/custom_bottomnav.dart';
import 'package:furcare_app/presentation/widgets/dialog/custom_branch_selection_dialog.dart';
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

  bool _hasProfileLoaded = false;

  // Define your navigation items here - easily add more!
  late final List<BottomNavItem> _navItems;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        _getProfile();
      }
    });

    _navItems = [
      BottomNavItem(
        icon: Icons.calendar_month_outlined,
        activeIcon: Icons.calendar_month,
        label: 'Appointments',
        screen: const MainTabScreen(),
      ),
      BottomNavItem(
        icon: Icons.pets_outlined,
        activeIcon: Icons.pets,
        label: 'Pets',
        screen: const PetsScreen(),
      ),
      BottomNavItem(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        label: 'Settings',
        screen: const SettingsTabScreen(),
      ),
    ];
  }

  void _getProfile() {
    context.read<ClientProvider>().getProfile().then((_) {
      if (mounted) {
        setState(() {
          _hasProfileLoaded = true;
        });
      }
    });
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
