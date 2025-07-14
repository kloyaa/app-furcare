import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/common/theme_toggle_button.dart';
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

  late Animation<double> _backgroundAnimation;
  late Animation<double> _iconRotation;
  late Animation<double> _iconScale;
  late Animation<double> _textFade;
  late Animation<double> _cardSlide;
  late Animation<double> _cardScale;

  @override
  void initState() {
    super.initState();

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

    // Start initial animations
    _startInitialAnimations();
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

  @override
  void dispose() {
    _backgroundController.dispose();
    _iconController.dispose();
    _textController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeNotifier.isDarkMode,
      builder: (context, isDarkMode, _) {
        return Scaffold(
          body: AnimatedBuilder(
            animation: Listenable.merge([
              _backgroundController,
              _iconController,
              _textController,
              _cardController,
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
                              const Color(0xFF16213e),
                              _backgroundAnimation.value,
                            )!,
                            Color.lerp(
                              const Color(0xFF16213e),
                              const Color(0xFF0f3460),
                              _backgroundAnimation.value,
                            )!,
                          ]
                        : [
                            Color.lerp(
                              const Color(0xFFe3f2fd),
                              const Color(0xFFf3e5f5),
                              _backgroundAnimation.value,
                            )!,
                            Color.lerp(
                              const Color(0xFFf3e5f5),
                              const Color(0xFFfff3e0),
                              _backgroundAnimation.value,
                            )!,
                          ],
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Main toggle card
                        Transform.translate(
                          offset: Offset(0, 100 * (1 - _cardSlide.value)),
                          child: Transform.scale(
                            scale: _cardScale.value,
                            child: Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode
                                        ? Colors.black.withOpacity(0.3)
                                        : Colors.grey.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                                border: Border.all(
                                  color: isDarkMode
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.1),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Theme status text
                                  FadeTransition(
                                    opacity: _textFade,
                                    child: Text(
                                      isDarkMode ? 'Dark Mode' : 'Light Mode',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: isDarkMode
                                            ? Colors.white.withOpacity(0.8)
                                            : Colors.black87,
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
                                                ? Colors.amber.withOpacity(0.3)
                                                : Colors.blue.withOpacity(0.3),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: Transform.rotate(
                                        angle: _iconRotation.value * 3.14159,
                                        child: Transform.scale(
                                          scale: _iconScale.value,
                                          child: Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: isDarkMode
                                                    ? [
                                                        Colors.amber.shade400,
                                                        Colors.orange.shade500,
                                                      ]
                                                    : [
                                                        Colors.blue.shade400,
                                                        Colors.indigo.shade500,
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
                                    child: Text(
                                      'Tap to switch between\nlight and dark themes',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isDarkMode
                                            ? Colors.white.withOpacity(0.6)
                                            : Colors.black54,
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
                          offset: Offset(0, 200 * (1 - _cardSlide.value)),
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
                                        // ignore: deprecated_member_use
                                        ? Colors.white.withOpacity(0.1)
                                        // ignore: deprecated_member_use
                                        : Colors.black.withOpacity(0.1),
                                  ),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  size: 24,
                                  color: isDarkMode
                                      // ignore: deprecated_member_use
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
