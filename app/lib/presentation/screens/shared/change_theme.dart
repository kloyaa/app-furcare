import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/theme.dart';
import 'package:furcare_app/core/theme/theme_notifier.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';

class ThemeToggleScreen extends StatefulWidget {
  const ThemeToggleScreen({super.key});

  @override
  State<ThemeToggleScreen> createState() => _ThemeToggleScreenState();
}

class _ThemeToggleScreenState extends State<ThemeToggleScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _iconController;
  late AnimationController _textController;
  late AnimationController _cardController;
  late AnimationController _colorPickerController;

  late Animation<double> _backgroundAnimation;
  late Animation<double> _iconRotation;
  late Animation<double> _iconScale;
  late Animation<double> _textFade;
  late Animation<double> _cardSlide;
  late Animation<double> _cardScale;
  late Animation<double> _colorPickerSlide;

  bool _showColorPicker = false;

  // Available theme colors - get from ThemeNotifier
  final List<ThemeColorData> _themeColors = ThemeColorData.allColors;

  late ThemeColorData _currentThemeColor;

  @override
  void initState() {
    super.initState();

    // Get current theme color from ThemeNotifier
    _currentThemeColor = ThemeNotifier.selectedColor.value;

    // Initialize animation controllers
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _colorPickerController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Initialize animations
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _iconRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );

    _iconScale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _cardSlide = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack),
    );

    _cardScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack),
    );

    _colorPickerSlide = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _colorPickerController,
        curve: Curves.easeOutBack,
      ),
    );

    _startInitialAnimations();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _iconController.dispose();
    _textController.dispose();
    _cardController.dispose();
    _colorPickerController.dispose();

    super.dispose();
  }

  void _startInitialAnimations() {
    _cardController.forward();
    _textController.forward();
  }

  void _handleThemeToggle() {
    // Trigger all animations
    _backgroundController.forward().then((_) {
      _backgroundController.reverse();
    });

    _iconController.forward().then((_) {
      _iconController.reverse();
    });

    // Toggle the theme
    ThemeNotifier.toggleTheme();
  }

  void _toggleColorPicker() {
    setState(() {
      _showColorPicker = !_showColorPicker;
    });

    if (_showColorPicker) {
      _colorPickerController.forward();
    } else {
      _colorPickerController.reverse();
    }
  }

  void _selectThemeColor(ThemeColorData colorData) {
    setState(() {
      _currentThemeColor = colorData;
    });

    // Update the global theme
    ThemeNotifier.changeThemeColor(colorData);

    // Add a small animation effect
    _iconController.forward().then((_) {
      _iconController.reverse();
    });
  }

  Color _getBackgroundColor(bool isDarkMode) {
    if (isDarkMode) {
      return Color.lerp(
        _currentThemeColor.darkColor.withAlpha(77),
        _currentThemeColor.darkColor.withAlpha(128),
        _backgroundAnimation.value,
      )!;
    } else {
      return Color.lerp(
        _currentThemeColor.accentColor.withAlpha(77),
        _currentThemeColor.accentColor.withAlpha(128),
        _backgroundAnimation.value,
      )!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeNotifier.isDarkMode,
      builder: (context, isDarkMode, _) {
        return ValueListenableBuilder<ThemeColorData>(
          valueListenable: ThemeNotifier.selectedColor,
          builder: (context, selectedColor, _) {
            // Update local state when global theme changes
            if (_currentThemeColor != selectedColor) {
              _currentThemeColor = selectedColor;
            }

            return Scaffold(
              body: AnimatedBuilder(
                animation: Listenable.merge([
                  _backgroundController,
                  _iconController,
                  _textController,
                  _cardController,
                  _colorPickerController,
                ]),
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDarkMode
                            ? [
                                Color.lerp(
                                  const Color(0xFF1a1a2e),
                                  _getBackgroundColor(isDarkMode),
                                  0.3,
                                )!,
                                Color.lerp(
                                  const Color(0xFF16213e),
                                  _getBackgroundColor(isDarkMode),
                                  0.5,
                                )!,
                              ]
                            : [
                                Color.lerp(
                                  const Color(0xFFf8f9fa),
                                  _getBackgroundColor(isDarkMode),
                                  0.3,
                                )!,
                                Color.lerp(
                                  const Color(0xFFffffff),
                                  _getBackgroundColor(isDarkMode),
                                  0.5,
                                )!,
                              ],
                      ),
                    ),
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Main toggle card
                                Transform.translate(
                                  offset: Offset(
                                    0,
                                    100 * (1 - _cardSlide.value),
                                  ),
                                  child: Transform.scale(
                                    scale: _cardScale.value,
                                    child: Container(
                                      padding: const EdgeInsets.all(40),
                                      decoration: BoxDecoration(
                                        color: isDarkMode
                                            ? Colors.white.withAlpha(26)
                                            : Colors.white.withAlpha(230),
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isDarkMode
                                                ? Colors.black.withAlpha(77)
                                                : _currentThemeColor.lightColor
                                                      .withAlpha(51),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: _currentThemeColor.lightColor
                                              .withAlpha(77),
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Theme status text
                                          FadeTransition(
                                            opacity: _textFade,
                                            child: Text(
                                              isDarkMode
                                                  ? 'Dark Mode'
                                                  : 'Light Mode',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: isDarkMode
                                                    ? Colors.white.withAlpha(
                                                        204,
                                                      )
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          // Current theme color name
                                          FadeTransition(
                                            opacity: _textFade,
                                            child: Text(
                                              _currentThemeColor.name,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: _currentThemeColor
                                                    .lightColor,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 30),

                                          // Animated toggle button
                                          GestureDetector(
                                            onTap: _handleThemeToggle,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: isDarkMode
                                                        ? Colors.amber
                                                              .withAlpha(128)
                                                        : _currentThemeColor
                                                              .lightColor
                                                              .withAlpha(128),
                                                    blurRadius: 50,
                                                    spreadRadius: 10,
                                                  ),
                                                ],
                                              ),
                                              child: Transform.rotate(
                                                angle:
                                                    _iconRotation.value *
                                                    3.14159,
                                                child: Transform.scale(
                                                  scale: _iconScale.value,
                                                  child: Container(
                                                    width: 80,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: isDarkMode
                                                            ? [
                                                                Colors
                                                                    .amber
                                                                    .shade400,
                                                                Colors
                                                                    .orange
                                                                    .shade500,
                                                              ]
                                                            : [
                                                                _currentThemeColor
                                                                    .lightColor,
                                                                _currentThemeColor
                                                                    .darkColor,
                                                              ],
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      isDarkMode
                                                          ? Icons.dark_mode
                                                          : Icons.light_mode,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 30),

                                          // Description text
                                          FadeTransition(
                                            opacity: _textFade,
                                            child: CustomText.body(
                                              'Tap to switch between\nlight and dark themes',
                                              textAlign: TextAlign.center,
                                              size: AppTextSize.sm,
                                              color:
                                                  ThemeHelper.getPrimaryTextColor(
                                                    context,
                                                  ),
                                            ),
                                          ),

                                          const SizedBox(height: 20),

                                          // Color picker toggle button
                                          FadeTransition(
                                            opacity: _textFade,
                                            child: GestureDetector(
                                              onTap: _toggleColorPicker,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: _currentThemeColor
                                                      .lightColor
                                                      .withAlpha(26),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: _currentThemeColor
                                                        .lightColor
                                                        .withAlpha(77),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.palette,
                                                      size: 18,
                                                      color: _currentThemeColor
                                                          .lightColor,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Choose Color',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            _currentThemeColor
                                                                .lightColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 60),

                                // Back button
                                Transform.translate(
                                  offset: Offset(
                                    0,
                                    200 * (1 - _cardSlide.value),
                                  ),
                                  child: FadeTransition(
                                    opacity: _textFade,
                                    child: GestureDetector(
                                      onTap: () => context.pop(),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isDarkMode
                                                ? Colors.white.withAlpha(51)
                                                : _currentThemeColor.lightColor
                                                      .withAlpha(77),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.arrow_back_ios_new_outlined,
                                          size: 24,
                                          color: isDarkMode
                                              ? Colors.white.withAlpha(204)
                                              : _currentThemeColor.lightColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Color picker panel
                          if (_showColorPicker)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Transform.translate(
                                offset: Offset(
                                  0,
                                  300 * (1 - _colorPickerSlide.value),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(20),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.grey.shade900.withAlpha(242)
                                        : Colors.white.withAlpha(242),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(51),
                                        blurRadius: 20,
                                        offset: const Offset(0, -5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Choose Theme Color',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Wrap(
                                        spacing: 15,
                                        runSpacing: 15,
                                        children: _themeColors.map((colorData) {
                                          final isSelected =
                                              _currentThemeColor.name ==
                                              colorData.name;
                                          return GestureDetector(
                                            onTap: () =>
                                                _selectThemeColor(colorData),
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    colorData.lightColor,
                                                    colorData.darkColor,
                                                  ],
                                                ),
                                                border: isSelected
                                                    ? Border.all(
                                                        color: Colors.white,
                                                        width: 3,
                                                      )
                                                    : null,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: colorData.lightColor
                                                        .withAlpha(77),
                                                    blurRadius: 10,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: isSelected
                                                  ? const Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 24,
                                                    )
                                                  : null,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: _toggleColorPicker,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _currentThemeColor.lightColor
                                                .withAlpha(26),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: _currentThemeColor
                                                  .lightColor
                                                  .withAlpha(77),
                                            ),
                                          ),
                                          child: Text(
                                            'Done',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  _currentThemeColor.lightColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
