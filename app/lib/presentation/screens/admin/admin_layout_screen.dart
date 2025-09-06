import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/presentation/providers/auth_provider.dart';
import 'package:furcare_app/presentation/routes/admin_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminLayoutScreen extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const AdminLayoutScreen({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<AdminLayoutScreen> createState() => _AdminLayoutScreenState();
}

class _AdminLayoutScreenState extends State<AdminLayoutScreen> {
  bool _isSidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 768 && size.width <= 1024;
    final isMobile = size.width <= 768;

    if (isMobile) {
      return _buildMobileLayout(theme);
    } else if (isTablet) {
      return _buildTabletLayout(theme);
    } else {
      return _buildDesktopLayout(theme);
    }
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: Row(
        children: [
          _buildSidebar(theme, isCollapsed: _isSidebarCollapsed),
          Expanded(
            child: Column(
              children: [
                _buildTopNavBar(theme, showMenuButton: false),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: Row(
        children: [
          _buildSidebar(theme, isCollapsed: true),
          Expanded(
            child: Column(
              children: [
                _buildTopNavBar(theme, showMenuButton: false),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: _buildMobileAppBar(theme),
      drawer: _buildMobileDrawer(theme),
      body: widget.child,
    );
  }

  PreferredSizeWidget _buildMobileAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 1,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.pets, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          CustomText.title(
            'FurCare Admin',
            size: AppTextSize.lg,
            fontWeight: AppFontWeight.bold.value,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
      actions: [_buildUserProfileButton(theme)],
    );
  }

  Widget _buildMobileDrawer(ThemeData theme) {
    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          _buildDrawerHeader(theme),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _buildNavigationItems(theme, isMobile: true),
            ),
          ),
          _buildDrawerFooter(theme),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(ThemeData theme) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.pets, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          CustomText.title(
            'FurCare Admin',
            size: AppTextSize.lg,
            fontWeight: AppFontWeight.bold.value,
            color: Colors.white,
          ),
          CustomText.body(
            'Management Portal',
            size: AppTextSize.sm,
            color: Colors.white.withAlpha(220),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerFooter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline.withAlpha(40)),
        ),
      ),
      child: _buildLogoutButton(theme, isInDrawer: true),
    );
  }

  Widget _buildSidebar(ThemeData theme, {required bool isCollapsed}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCollapsed ? 80 : 280,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(color: theme.colorScheme.outline.withAlpha(40)),
        ),
      ),
      child: Column(
        children: [
          _buildSidebarHeader(theme, isCollapsed),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: _buildNavigationItems(theme, isCollapsed: isCollapsed),
            ),
          ),
          if (!isCollapsed) _buildSidebarFooter(theme),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader(ThemeData theme, bool isCollapsed) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline.withAlpha(40)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.pets, color: Colors.white, size: 24),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText.title(
                    'FurCare',
                    size: AppTextSize.md,
                    fontWeight: AppFontWeight.bold.value,
                    color: theme.colorScheme.primary,
                  ),
                  CustomText.body(
                    'Admin Portal',
                    size: AppTextSize.xs,
                    color: theme.colorScheme.onSurface.withAlpha(160),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                _isSidebarCollapsed
                    ? Icons.keyboard_arrow_right
                    : Icons.keyboard_arrow_left,
                color: theme.colorScheme.onSurface.withAlpha(160),
              ),
              onPressed: () {
                setState(() {
                  _isSidebarCollapsed = !_isSidebarCollapsed;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSidebarFooter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline.withAlpha(40)),
        ),
      ),
      child: Column(
        children: [
          _buildUserProfileButton(theme),
          const SizedBox(height: 12),
          _buildLogoutButton(theme),
        ],
      ),
    );
  }

  Widget _buildTopNavBar(ThemeData theme, {required bool showMenuButton}) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline.withAlpha(40)),
        ),
      ),
      child: Row(
        children: [
          if (showMenuButton)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  _isSidebarCollapsed = !_isSidebarCollapsed;
                });
              },
            ),
          Expanded(
            child: CustomText.title(
              _getPageTitle(),
              size: AppTextSize.md,
              fontWeight: AppFontWeight.bold.value,
            ),
          ),
          _buildUserProfileButton(theme),
        ],
      ),
    );
  }

  List<Widget> _buildNavigationItems(
    ThemeData theme, {
    bool isCollapsed = false,
    bool isMobile = false,
  }) {
    final items = [
      _NavigationItem(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        label: 'Dashboard',
        route: AdminRoute.home,
      ),
      _NavigationItem(
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        label: 'Users',
        route: AdminRoute.users,
      ),
      _NavigationItem(
        icon: Icons.assessment_outlined,
        activeIcon: Icons.assessment,
        label: 'Reports',
        route: AdminRoute.reports,
      ),
    ];

    return items.map((item) {
      final isActive = widget.currentRoute == item.route;

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: isCollapsed ? 8 : 12,
          vertical: 2,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (isMobile) {
                Navigator.of(context).pop(); // Close drawer
              }
              context.go(item.route);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 0 : 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? theme.colorScheme.primaryContainer.withAlpha(70)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isActive
                    ? Border.all(color: theme.colorScheme.primary.withAlpha(70))
                    : null,
              ),
              child: Row(
                children: [
                  if (isCollapsed)
                    Expanded(
                      child: Icon(
                        isActive ? item.activeIcon : item.icon,
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withAlpha(200),
                        size: 24,
                      ),
                    )
                  else ...[
                    Icon(
                      isActive ? item.activeIcon : item.icon,
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withAlpha(200),
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomText.body(
                        item.label,
                        fontWeight: isActive
                            ? AppFontWeight.semibold.value
                            : AppFontWeight.normal.value,
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withAlpha(220),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildUserProfileButton(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(70),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: theme.colorScheme.primary,
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText.body(
                'Admin User',
                size: AppTextSize.xs,
                fontWeight: AppFontWeight.semibold.value,
                color: theme.colorScheme.primary,
              ),
              CustomText.body(
                'Administrator',
                size: AppTextSize.xs,
                color: theme.colorScheme.onSurface.withAlpha(160),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(ThemeData theme, {bool isInDrawer = false}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _handleLogout(),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.error,
          side: BorderSide(color: theme.colorScheme.error.withAlpha(125)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        icon: const Icon(Icons.logout, size: 18),
        label: CustomText.body(
          'Logout',
          fontWeight: AppFontWeight.semibold.value,
          color: theme.colorScheme.error,
        ),
      ),
    );
  }

  String _getPageTitle() {
    switch (widget.currentRoute) {
      case AdminRoute.home:
        return 'Dashboard';
      case AdminRoute.users:
        return 'User Management';
      case AdminRoute.reports:
        return 'Reports & Analytics';
      default:
        return 'Admin Panel';
    }
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();
      if (mounted) {
        context.go(AdminRoute.login);
      }
    }
  }
}

class _NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
