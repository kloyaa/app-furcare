import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/tabs/home.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/tabs/settings.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_bottomnav.dart';

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
    _navItems = [
      BottomNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Home',
        screen: const HomeTabScreen(),
      ),
      BottomNavItem(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        label: 'Settings',
        screen: const SettingsTabScreen(),
      ),
      // Add more items easily:
      // BottomNavItem(
      //   icon: Icons.favorite_outline,
      //   activeIcon: Icons.favorite,
      //   label: 'Favorites',
      //   screen: const FavoritesTabScreen(),
      // ),
      // BottomNavItem(
      //   icon: Icons.person_outline,
      //   activeIcon: Icons.person,
      //   label: 'Profile',
      //   screen: const ProfileTabScreen(),
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _navItems.map((item) => item.screen).toList(),
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
  }
}
