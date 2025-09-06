import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/presentation/providers/auth_provider.dart';
import 'package:furcare_app/presentation/routes/admin_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late AnimationController _logoAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _logoAnimation;
  late Animation<double> _backgroundAnimation;

  bool _isPasswordVisible = false;
  bool _showValidationErrors = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _usernameFocusNode.addListener(_onFocusChanged);
    _passwordFocusNode.addListener(_onFocusChanged);
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _backgroundAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _backgroundAnimationController,
        curve: Curves.linear,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _backgroundAnimationController.repeat();
      _logoAnimationController.forward();
      Future.delayed(const Duration(milliseconds: 300), () {
        _animationController.forward();
      });
    });

    _usernameController.text = 'teststaff1';
    _passwordController.text = 'Test@Password1';
  }

  @override
  void dispose() {
    _animationController.dispose();
    _logoAnimationController.dispose();
    _backgroundAnimationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {});
  }

  String? _validateUsername(String? value) {
    if (!_showValidationErrors) return null;
    if (value?.trim().isEmpty ?? true) {
      return 'Username or email is required';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (!_showValidationErrors) return null;
    if (value?.trim().isEmpty ?? true) {
      return 'Password is required';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    setState(() {
      _showValidationErrors = true;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    authProvider.clearError();

    await authProvider.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    if (mounted) {
      if (authProvider.isAuthenticated) {
        context.go(AdminRoute.home);
      } else if (authProvider.errorMessage != null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Login Failed'),
              content: Text(authProvider.errorMessage!),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;
    final isTablet = size.width > 768 && size.width <= 1024;
    final isMobile = size.width <= 768;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade50,
                  Colors.blue.shade100.withAlpha(220),
                  Colors.purple.shade50.withAlpha(160),
                ],
                stops: const [0.0, 0.5, 1.0],
                transform: GradientRotation(_backgroundAnimation.value * 0.1),
              ),
            ),
            child: SafeArea(
              child: _buildResponsiveLayout(
                isDesktop,
                isTablet,
                isMobile,
                theme,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResponsiveLayout(
    bool isDesktop,
    bool isTablet,
    bool isMobile,
    ThemeData theme,
  ) {
    if (isDesktop) {
      return _buildDesktopLayout(theme);
    } else if (isTablet) {
      return _buildTabletLayout(theme);
    } else {
      return _buildMobileLayout(theme);
    }
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    return Row(
      children: [
        Expanded(flex: 6, child: _buildLeftPanel(theme)),
        Expanded(flex: 4, child: _buildLoginPanel(theme, maxWidth: 480)),
      ],
    );
  }

  Widget _buildTabletLayout(ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Row(
          children: [
            Expanded(flex: 5, child: _buildLeftPanel(theme)),
            const SizedBox(width: 32),
            Expanded(flex: 5, child: _buildLoginPanel(theme, maxWidth: 400)),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildMobileHeader(theme),
          const SizedBox(height: 40),
          _buildLoginPanel(theme, maxWidth: double.infinity),
        ],
      ),
    );
  }

  Widget _buildLeftPanel(ThemeData theme) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.title(
                  'Welcome to FurCare',
                  size: AppTextSize.xl,
                  fontWeight: AppFontWeight.black.value,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                CustomText.title(
                  'Admin Portal',
                  size: AppTextSize.lg,
                  fontWeight: AppFontWeight.bold.value,
                  color: theme.colorScheme.onSurface.withAlpha(220),
                ),
                const SizedBox(height: 24),
                CustomText.body(
                  'Manage appointments, track payments, and oversee your pet care business with our comprehensive admin dashboard.',
                  size: AppTextSize.md,
                  color: theme.colorScheme.onSurface.withAlpha(200),
                ),
                const SizedBox(height: 32),
                _buildFeaturesList(theme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrandLogo(ThemeData theme) {
    return AnimatedBuilder(
      animation: _logoAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoAnimation.value,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.surface.withAlpha(125), Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withAlpha(70),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Image.asset('assets/furcare_logo.png'),
          ),
        );
      },
    );
  }

  Widget _buildFeaturesList(ThemeData theme) {
    final features = [
      ('Dashboard Analytics', Icons.analytics_outlined),
      ('Appointment Management', Icons.calendar_today_outlined),
      ('Payment Processing', Icons.payment_outlined),
      ('Customer Management', Icons.people_outline),
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  feature.$2,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              CustomText.body(
                feature.$1,
                fontWeight: AppFontWeight.semibold.value,
                color: theme.colorScheme.onSurface.withAlpha(220),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMobileHeader(ThemeData theme) {
    return AnimatedBuilder(
      animation: _logoAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoAnimation.value,
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, Colors.blue.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(70),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.pets, color: Colors.white, size: 50),
              ),
              const SizedBox(height: 24),
              CustomText.title(
                'FurCare Admin',
                size: AppTextSize.xl,
                fontWeight: AppFontWeight.black.value,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              CustomText.body(
                'Secure access for authorized staff',
                size: AppTextSize.sm,
                color: theme.colorScheme.onSurface.withAlpha(200),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoginPanel(ThemeData theme, {required double maxWidth}) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.surface,
                      border: Border.all(
                        color: theme.colorScheme.outline.withAlpha(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLoginHeader(theme),
                            const SizedBox(height: 32),
                            _buildLoginForm(theme),
                            const SizedBox(height: 32),
                            _buildLoginButton(),
                            const SizedBox(height: 24),
                            _buildSecurityNote(theme),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginHeader(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBrandLogo(theme),
        const SizedBox(width: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText.title(
              'Sign In',
              size: AppTextSize.lg,
              fontWeight: AppFontWeight.black.value,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 8),
            CustomText.body(
              'Access your admin dashboard',
              size: AppTextSize.sm,
              color: theme.colorScheme.onSurface.withAlpha(200),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginForm(ThemeData theme) {
    return Column(
      children: [
        _buildUsernameField(theme),
        const SizedBox(height: 20),
        _buildPasswordField(theme),
      ],
    );
  }

  Widget _buildUsernameField(ThemeData theme) {
    final hasError = _validateUsername(_usernameController.text) != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(
          'Username or Email',
          fontWeight: AppFontWeight.semibold.value,
          color: theme.colorScheme.onSurface.withAlpha(220),
          size: AppTextSize.sm,
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? theme.colorScheme.error
                  : _usernameFocusNode.hasFocus
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withAlpha(70),
              width: hasError || _usernameFocusNode.hasFocus ? 2 : 1,
            ),
            color: _usernameFocusNode.hasFocus
                ? theme.colorScheme.surface
                : theme.colorScheme.surfaceContainerHighest.withAlpha(70),
          ),
          child: TextFormField(
            controller: _usernameController,
            focusNode: _usernameFocusNode,
            validator: _validateUsername,
            decoration: InputDecoration(
              hintText: 'Enter your username or email',
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(125),
                fontSize: 16,
              ),
              prefixIcon: Icon(
                Icons.person_outline,
                color: hasError
                    ? theme.colorScheme.error
                    : _usernameFocusNode.hasFocus
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withAlpha(125),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              errorStyle: const TextStyle(height: 0),
            ),
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            onChanged: (value) {
              if (_showValidationErrors) {
                setState(() {});
              }
            },
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 16,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 4),
              CustomText.body(
                _validateUsername(_usernameController.text)!,
                size: AppTextSize.xs,
                color: theme.colorScheme.error,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordField(ThemeData theme) {
    final hasError = _validatePassword(_passwordController.text) != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(
          'Password',
          fontWeight: AppFontWeight.semibold.value,
          color: theme.colorScheme.onSurface.withAlpha(220),
          size: AppTextSize.sm,
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? theme.colorScheme.error
                  : _passwordFocusNode.hasFocus
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withAlpha(70),
              width: hasError || _passwordFocusNode.hasFocus ? 2 : 1,
            ),
            color: _passwordFocusNode.hasFocus
                ? theme.colorScheme.surface
                : theme.colorScheme.surfaceContainerHighest.withAlpha(70),
          ),
          child: TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            validator: _validatePassword,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(125),
                fontSize: 16,
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: hasError
                    ? theme.colorScheme.error
                    : _passwordFocusNode.hasFocus
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withAlpha(125),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: theme.colorScheme.onSurface.withAlpha(125),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              errorStyle: const TextStyle(height: 0),
            ),
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            onChanged: (value) {
              if (_showValidationErrors) {
                setState(() {});
              }
            },
            onFieldSubmitted: (_) => _handleLogin(),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 16,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 4),
              CustomText.body(
                _validatePassword(_passwordController.text)!,
                size: AppTextSize.xs,
                color: theme.colorScheme.error,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLoginButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Sign In to Dashboard',
            onPressed: authProvider.isLoading ? null : _handleLogin,
            isLoading: authProvider.isLoading,
            icon: Icons.dashboard_outlined,
          ),
        );
      },
    );
  }

  Widget _buildSecurityNote(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(70),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security_outlined,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.body(
                  'Secure Access',
                  fontWeight: AppFontWeight.semibold.value,
                  size: AppTextSize.sm,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 2),
                CustomText.body(
                  'This portal is restricted to authorized FurCare staff only',
                  size: AppTextSize.xs,
                  color: theme.colorScheme.onSurface.withAlpha(200),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
