import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furcare_app/core/constants/padding_constant.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/widget.dart';
import 'package:furcare_app/core/services/location_service.dart';
import 'package:furcare_app/data/models/pet_service.models.dart';
import 'package:furcare_app/presentation/providers/pet_service_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/dialog/custom_location_dialog.dart';
import 'package:furcare_app/presentation/widgets/dialog/custom_my_appointments_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late AnimationController _glowController;
  late AnimationController _backgroundController;
  late AnimationController _cardAnimationController;
  late PageController _backgroundPageController;

  // Background images list
  final List<String> backgroundImages = [
    'assets/image_1.jpg',
    'assets/image_2.jpg',
    'assets/image_3.jpg',
  ];

  int _currentBackgroundIndex = 0;

  Future<void> _handleNavigateToPetServices(String code) async {
    if (code == "PET_GROOMING") {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Service Consent Required'),
            content: const SingleChildScrollView(
              child: Text(
                '''By agreeing to this consent, I consent to the grooming services provided by Furcare Vet Clinic. I understand that grooming involves handling my pet, and I authorize the staff to proceed with the requested services in case of an emergency, I consent to necessary veterinary care, at my expense.

At Furcare Vet Clinic, we prioritize your pet's well-being. While we take great care to ensure a pleasant grooming experience, grooming can sometimes uncover hidden health issues or worsen existing conditions. If needed, I authorize the Furcare immediate, veterinary treatment at my expense.

If I am not present, I give permission for Furcare Vet Clinic to use photos of my pet for promotional purposes. I confirm that my pet is up to date on Rabies, Distemper, and any required vaccinations.

I also acknowledge that I have informed the clinic of any pre-existing medical conditions my pet may have.''',
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('I Agree & Continue'),
              ),
            ],
          );
        },
      );

      // Only proceed if user confirmed
      if (confirmed != true) return;

      // Add haptic feedback for better UX (only after confirmation)
      HapticFeedback.selectionClick();
      _handleNavigate(code);

      return;
    }

    _handleNavigate(code);
  }

  _handleNavigate(String code) {
    if (code == "PET_GROOMING") {
      context.push('/appointments/grooming');
    }
    if (code == "PET_BOARDING") {
      context.push('/appointments/boarding');
    }
    if (code == "HOME_SERVICE") {
      context.push('/appointments/home-service');
    }
    if (code == "PET_TRAINING") {
      context.push('/appointments/training');
    }
  }

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _glowController.repeat(reverse: true);

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _backgroundPageController = PageController();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticInOut,
        reverseCurve: Curves.elasticInOut,
      ),
    );

    // Start animations
    _startBouncing();
    _startBackgroundRotation();
    _animateCards();

    Future.microtask(() {
      if (mounted) {
        context.read<PetServiceProvider>().getPetServices();
      }
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _backgroundController.dispose();
    _backgroundPageController.dispose();
    _cardAnimationController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _startBouncing() {
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        _bounceController.forward().then((_) {
          _bounceController.reverse();
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _startBackgroundRotation() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentBackgroundIndex =
              (_currentBackgroundIndex + 1) % backgroundImages.length;
        });
        _backgroundController.forward().then((_) {
          _backgroundController.reverse();
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _animateCards() {
    _cardAnimationController.forward();
  }

  void _handleLaunchMap() async {
    try {
      HapticFeedback.mediumImpact();

      // Show loading indicator
      LocationDialogUtils.showLoadingDialog(
        context,
        message: 'Getting your location...',
      );

      // Get current location
      final locationService = LocationService();
      final Position? currentPosition = await locationService
          .getCurrentLocation();

      if (!mounted) return;

      // Dismiss loading dialog
      LocationDialogUtils.dismissDialog(context);

      if (currentPosition == null) {
        // Handle location error
        LocationDialogUtils.showLocationErrorDialog(context);
        return;
      }

      // Launch map with current location as origin
      final availableMaps = await MapLauncher.installedMaps;

      if (availableMaps.isEmpty) {
        if (!mounted) return;
        LocationDialogUtils.showNoMapsDialog(context);
        return;
      }

      await availableMaps.first.showDirections(
        destinationTitle: "FurCare Veterinary Clinic",
        directionsMode: DirectionsMode.driving,
        origin: Coords(8.433167620783577, 124.62233674985006),
        destination: Coords(8.475588, 124.660488),
      );
    } catch (e) {
      if (!mounted) return;
      LocationDialogUtils.dismissDialog(context);
      LocationDialogUtils.showGenericErrorDialog(
        context,
        'Failed to open directions. Please try again.',
      );
    }
  }

  Widget _buildBackgroundImage() {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 1200),
          child: Container(
            key: ValueKey(_currentBackgroundIndex),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImages[_currentBackgroundIndex]),
                fit: BoxFit.cover,
                opacity: 0.25 + (_backgroundController.value * 0.15),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primaryContainer.withAlpha(240),
                    theme.colorScheme.primaryContainer.withAlpha(220),
                    theme.colorScheme.primaryContainer.withAlpha(180),
                    theme.colorScheme.primaryContainer.withAlpha(120),
                    theme.colorScheme.primaryContainer.withAlpha(60),
                    theme.colorScheme.primaryContainer.withAlpha(20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceCard(
    PetService service,
    ColorScheme colorScheme,
    int index,
  ) {
    final cardImageIndex =
        service.code.hashCode.abs() % backgroundImages.length;

    return AnimatedBuilder(
      animation: _cardAnimationController,
      builder: (context, child) {
        final slideAnimation =
            Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _cardAnimationController,
                curve: Interval(
                  index * 0.15,
                  0.6 + (index * 0.15),
                  curve: Curves.easeOutCubic,
                ),
              ),
            );

        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _cardAnimationController,
            curve: Interval(
              index * 0.1,
              0.8 + (index * 0.1),
              curve: Curves.easeOut,
            ),
          ),
        );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: GestureDetector(
              onTap: service.available
                  ? () => _handleNavigateToPetServices(service.code)
                  : null,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(
                        service.available ? 25 : 10,
                      ),
                      blurRadius: service.available ? 12 : 6,
                      offset: const Offset(0, 4),
                      spreadRadius: service.available ? 1 : 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Card background image
                      Positioned.fill(
                        child: Image.asset(
                          backgroundImages[cardImageIndex],
                          fit: BoxFit.cover,
                          opacity: AlwaysStoppedAnimation(
                            service.available ? 0.12 : 0.05,
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: service.available
                                  ? [
                                      colorScheme.primaryContainer.withAlpha(
                                        220,
                                      ),
                                      colorScheme.primaryContainer.withAlpha(
                                        180,
                                      ),
                                    ]
                                  : [
                                      colorScheme.surfaceContainerHighest
                                          .withAlpha(200),
                                      colorScheme.surfaceContainerHighest
                                          .withAlpha(150),
                                    ],
                            ),
                          ),
                        ),
                      ),
                      // Unavailable overlay
                      if (!service.available)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withAlpha(100),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.lock_outline,
                                size: 32,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Icon container with enhanced styling
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withAlpha(50),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                getServiceIcon(service.code),
                                size: 72,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Service information
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText.title(
                                    service.name,
                                    size: AppTextSize.mlg,
                                    fontWeight: AppFontWeight.semibold.value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    color: colorScheme.primary,
                                    style: GoogleFonts.pacifico(),
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText.subtitle(
                                    service.description,
                                    size: AppTextSize.sm,
                                    fontWeight: AppFontWeight.normal.value,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ],
                              ),
                            ),
                            // Arrow indicator
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: service.available
                                    ? colorScheme.onSurfaceVariant
                                    : Colors.grey.withAlpha(100),
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationSection(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
      child: InkWell(
        onTap: () => _handleLaunchMap(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: colorScheme.surface.withAlpha(200),
            border: Border.all(
              color: colorScheme.outline.withAlpha(80),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(80),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 24,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.body(
                      "Branch Location",
                      size: AppTextSize.md,
                      fontWeight: AppFontWeight.bold.value,
                      color: colorScheme.onSurface,
                    ),
                    const SizedBox(height: 2),
                    CustomText.subtitle(
                      "Get directions to our clinic",
                      size: AppTextSize.xs,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(28),
              shadowColor: colorScheme.primary.withAlpha(100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary.withAlpha(240),
                          colorScheme.primary.withAlpha(200),
                        ],
                      ),
                      border: Border.all(
                        color: colorScheme.onPrimary.withAlpha(50),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withAlpha(80),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () {
                        final petServices = context
                            .read<PetServiceProvider>()
                            .petServices;

                        HapticFeedback.lightImpact();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              MyAppointmentsDialog(petServices: petServices),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimary.withAlpha(40),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.bookmark_border_rounded,
                                size: 18,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            CustomText.body(
                              'My Appointments',
                              size: AppTextSize.sm,
                              fontWeight: AppFontWeight.bold.value,
                              color: colorScheme.onPrimary,
                            ),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          Positioned.fill(child: _buildBackgroundImage()),
          // Main content
          SafeArea(
            child: Container(
              padding: kDefaultBodyPadding,
              child: CustomScrollView(
                slivers: [
                  // App bar space
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  // Services grid
                  SliverToBoxAdapter(
                    child: Consumer<PetServiceProvider>(
                      builder: (context, petServiceProvider, child) {
                        List<PetService> petServices =
                            petServiceProvider.petServices;

                        return Column(
                          children: [
                            // Services list
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: petServices.length,
                              itemBuilder: (context, index) {
                                return _buildServiceCard(
                                  petServices[index],
                                  colorScheme,
                                  index,
                                );
                              },
                            ),
                            // Location section
                            _buildLocationSection(colorScheme),
                            // Bottom spacing for FAB
                            const SizedBox(height: 80),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(colorScheme),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
