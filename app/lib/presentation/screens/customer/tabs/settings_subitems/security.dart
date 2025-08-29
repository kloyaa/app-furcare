import 'package:flutter/material.dart';
import 'package:furcare_app/core/constants/padding_constant.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/data/models/settings_item.model.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_header.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen>
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

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    _headerAnimationController.dispose();

    super.dispose();
  }

  /// Initialize animation controllers with proper durations
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  /// Initialize the settings items list
  void _initializeSettingsItems() {
    _settingsItems = [
      SettingsItem(
        icon: Icons.lock_outline,
        title: 'Change Password',
        subtitle: 'Update your account password',
        onTap: () => _handleChangePassword(),
        iconColor: Colors.pink,
      ),
    ];
  }

  /// Start animations with proper error handling
  void _startAnimations() {
    try {
      if (!_isDisposed) {
        _headerAnimationController.forward();
        // Add slight delay before starting list animation
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!_isDisposed) {
            _animationController.forward();
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handleChangePassword() {
    context.push('/settings/privacy/change-password');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        showThemeToggle: false,
      ),
      body: SafeArea(
        child: Container(
          padding: kDefaultBodyPadding,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Animated header section
              SliverToBoxAdapter(child: _buildAnimatedHeader(theme)),
              SliverToBoxAdapter(child: SizedBox(height: 20.0)),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeader(
                  title: 'Security',
                  subtitle: 'Control your security settings',
                ),
              ],
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
            child: Container(child: _buildSettingsCard(context, item)),
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
      color: colorScheme.surfaceContainerHighest.withAlpha(77),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        // ignore: deprecated_member_use
        side: BorderSide(color: colorScheme.outline.withAlpha(26), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.isEnabled ? item.onTap : null,
          borderRadius: BorderRadius.circular(16),
          // ignore: deprecated_member_use
          splashColor: colorScheme.primary.withAlpha(26),
          // ignore: deprecated_member_use
          highlightColor: colorScheme.primary.withAlpha(13),
          child: Container(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                // Icon with background circle and proper theming
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (item.iconColor ?? colorScheme.primary).withAlpha(
                      26,
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
                      CustomText.body(item.title, size: AppTextSize.md),
                      const SizedBox(height: 4),
                      CustomText.subtitle(item.subtitle, size: AppTextSize.xs),
                    ],
                  ),
                ),

                // Trailing arrow with proper theming
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: item.isEnabled
                      ? colorScheme.onSurface.withAlpha(128)
                      : colorScheme.onSurface.withAlpha(77),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
