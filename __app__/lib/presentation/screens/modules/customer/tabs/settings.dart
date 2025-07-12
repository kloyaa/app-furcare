import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/enums/text_enum.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_button.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_confirm_dialog.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_header.dart';
import 'package:flutter_application_1/presentation/widgets/common/default_snackbar.dart';
import 'package:go_router/go_router.dart';

/// Model class representing a settings item with all necessary properties
class SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool isEnabled;

  const SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconColor,
    this.isEnabled = true,
  });
}

/// Enhanced Settings Tab Screen with animations, theme support, and error handling
class SettingsTabScreen extends StatefulWidget {
  const SettingsTabScreen({super.key});

  @override
  State<SettingsTabScreen> createState() => _SettingsTabScreenState();
}

class _SettingsTabScreenState extends State<SettingsTabScreen>
    with TickerProviderStateMixin {
  /// Animation controller for staggered list animations
  late AnimationController _animationController;

  /// Animation controller for header fade-in effect
  late AnimationController _headerAnimationController;

  /// List of settings items to display
  late List<SettingsItem> _settingsItems;

  /// Track if the widget is disposed to prevent memory leaks
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSettingsItems();
    _startAnimations();
  }

  /// Initialize animation controllers with proper durations
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  /// Initialize the settings items list
  void _initializeSettingsItems() {
    _settingsItems = [
      SettingsItem(
        icon: Icons.person_outline,
        title: 'Account',
        subtitle: 'Manage your account information',
        onTap: () => _handleNotificationsTap(),
        iconColor: Colors.pink,
      ),
      SettingsItem(
        icon: Icons.notifications_outlined,
        title: 'Notifications',
        subtitle: 'Manage your notification preferences',
        onTap: () => _handleNotificationsTap(),
        iconColor: Colors.orange,
      ),
      SettingsItem(
        icon: Icons.security_outlined,
        title: 'Privacy & Security',
        subtitle: 'Control your privacy settings',
        onTap: () => _handlePrivacyTap(),
        iconColor: Colors.green,
      ),
      SettingsItem(
        icon: Icons.palette_outlined,
        title: 'Theme',
        subtitle: 'Choose your preferred theme',
        onTap: () => _handleThemeTap(),
        iconColor: Colors.purple,
      ),
      SettingsItem(
        icon: Icons.help_outline,
        title: 'Help & Support',
        subtitle: 'Get help and contact support',
        onTap: () => _handleHelpTap(),
        iconColor: Colors.blue,
      ),
    ];
  }

  /// Start animations with proper error handling
  void _startAnimations() {
    try {
      if (!_isDisposed) {
        _headerAnimationController.forward();
        // Add slight delay before starting list animation
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!_isDisposed) {
            _animationController.forward();
          }
        });
      }
    } catch (e) {
      // Handle animation errors gracefully
      debugPrint('Animation error: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Animated header section
            SliverToBoxAdapter(child: _buildAnimatedHeader(theme)),
            // Settings items list with staggered animation
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildAnimatedSettingsItem(
                  context,
                  _settingsItems[index],
                  index,
                ),
                childCount: _settingsItems.length,
              ),
            ),

            // Bottom padding for better scrolling experience
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  /// Build animated header with fade-in effect
  Widget _buildAnimatedHeader(ThemeData theme) {
    return AnimatedBuilder(
      animation: _headerAnimationController,
      builder: (context, child) {
        final fadeAnimation = Tween<double>(begin: 0.0, end: 5.0).animate(
          CurvedAnimation(
            parent: _headerAnimationController,
            curve: Curves.easeInOut,
          ),
        );

        final slideAnimation =
            Tween<Offset>(
              begin: const Offset(0, -0.2),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _headerAnimationController,
                curve: Curves.easeOutCubic,
              ),
            );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main title with proper null safety
                  CustomHeader(
                    title: 'Settings',
                    subtitle: 'Manage your app preferences',
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: "Logout",
                    height: 40,
                    width: 120,
                    textSize: AppTextSize.xs,
                    icon: Icons.logout,
                    onPressed: () => _handleLogout(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build animated settings item with staggered animation
  Widget _buildAnimatedSettingsItem(
    BuildContext context,
    SettingsItem item,
    int index,
  ) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Calculate staggered delay for each item
        final delay = index * 0.15;
        final animationValue = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              delay,
              (delay + 0.3).clamp(0.0, 1.0),
              curve: Curves.easeOutCubic,
            ),
          ),
        );

        final slideAnimation =
            Tween<Offset>(
              begin: const Offset(0.3, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                  delay,
                  (delay + 0.4).clamp(0.0, 1.0),
                  curve: Curves.easeOutCubic,
                ),
              ),
            );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: animationValue,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: _buildSettingsCard(context, item),
            ),
          ),
        );
      },
    );
  }

  /// Build enhanced settings card with hover effects and proper theming
  Widget _buildSettingsCard(BuildContext context, SettingsItem item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      // ignore: deprecated_member_use
      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        // ignore: deprecated_member_use
        side: BorderSide(color: colorScheme.outline.withOpacity(0.1), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.isEnabled ? item.onTap : null,
          borderRadius: BorderRadius.circular(16),
          // ignore: deprecated_member_use
          splashColor: colorScheme.primary.withOpacity(0.1),
          // ignore: deprecated_member_use
          highlightColor: colorScheme.primary.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon with background circle and proper theming
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (item.iconColor ?? colorScheme.primary).withOpacity(
                      0.1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    color: item.iconColor ?? colorScheme.primary,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // Title and subtitle with proper text styling
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style:
                            (theme.textTheme.titleMedium ?? const TextStyle())
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: item.isEnabled
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurface.withOpacity(0.5),
                                ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        item.subtitle,
                        style: (theme.textTheme.bodyMedium ?? const TextStyle())
                            .copyWith(
                              color: item.isEnabled
                                  ? colorScheme.onSurface.withOpacity(0.7)
                                  : colorScheme.onSurface.withOpacity(0.4),
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Trailing arrow with proper theming
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: item.isEnabled
                      ? colorScheme.onSurface.withOpacity(0.5)
                      : colorScheme.onSurface.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogout() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: "Confirm Logout",
      message: "Are you sure you want to logout? This will end your session.",
      confirmText: "Logout",
      cancelText: "Cancel",
      icon: Icons.logout,
      confirmColor: Colors.red,
    );

    if (confirmed == true) {
      if (!mounted) return;
      context.go('/');
    }
  }

  /// Handle notifications tap with error handling
  void _handleNotificationsTap() {
    try {
      // Add haptic feedback for better UX
      showCustomSnackBar(context, 'Notifications settings opened');
      // Navigate to notifications settings
    } catch (e) {
      _handleError('Failed to open notifications settings', e);
    }
  }

  /// Handle privacy settings tap
  void _handlePrivacyTap() {
    try {
      showCustomSnackBar(context, 'Privacy settings opened');
      // Navigate to privacy settings
    } catch (e) {
      _handleError('Failed to open privacy settings', e);
    }
  }

  /// Handle theme settings tap
  void _handleThemeTap() {
    try {
      context.go('/settings/theme', extra: {"from": "/settings/theme"});
      // showCustomSnackBar('Theme settings opened');
      // Navigate to theme settings
    } catch (e) {
      _handleError('Failed to open theme settings', e);
    }
  }

  /// Handle help settings tap
  void _handleHelpTap() {
    try {
      showCustomSnackBar(context, 'Help & Support opened');
      // Navigate to help settings
    } catch (e) {
      _handleError('Failed to open help settings', e);
    }
  }

  /// Show snackbar with proper error handling

  /// Handle errors gracefully with logging
  void _handleError(String message, Object error) {
    debugPrint('Settings Screen Error: $message - $error');

    if (mounted) {
      showCustomSnackBar(context, 'Something went wrong. Please try again.');
    }
  }
}
