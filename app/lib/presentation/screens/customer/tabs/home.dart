import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furcare_app/core/constants/padding_constant.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/helpers/widget_helpers.dart';
import 'package:furcare_app/core/services/location_service.dart';
import 'package:furcare_app/data/models/pet_service.models.dart';
import 'package:furcare_app/presentation/providers/pet_service_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/dialog/custom_location_dialog.dart';
import 'package:furcare_app/presentation/widgets/dialog/custom_my_appointments_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
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
  late CarouselController _carouselController;
  late PageController _backgroundPageController;

  // Background images list
  final List<String> backgroundImages = [
    'assets/image_1.jpg',
    'assets/image_2.jpg',
    'assets/image_3.jpg',
  ];

  int _currentBackgroundIndex = 0;

  void _handleNavigateToPetServices(String code) {
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

    _backgroundPageController = PageController();
    _carouselController = CarouselController();
    _bounceController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: -5.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticInOut,
        reverseCurve: Curves.elasticInOut,
      ),
    );

    // Start bouncing every 3 seconds
    _startBouncing();
    // Start background rotation
    _startBackgroundRotation();

    _carouselController = CarouselController();
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
    _carouselController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _startBouncing() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
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
    Timer.periodic(const Duration(seconds: 4), (timer) {
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

  void _handleLaunchMap() async {
    try {
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
          duration: const Duration(milliseconds: 1000),
          child: Container(
            key: ValueKey(_currentBackgroundIndex),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImages[_currentBackgroundIndex]),
                fit: BoxFit.cover,
                opacity: 0.3 + (_backgroundController.value * 0.1),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primaryContainer.withAlpha(255),
                    theme.colorScheme.primaryContainer.withAlpha(255),
                    theme.colorScheme.primaryContainer.withAlpha(150),
                    theme.colorScheme.primaryContainer.withAlpha(50),
                    theme.colorScheme.primaryContainer.withAlpha(5),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceCard(PetService service, ColorScheme colorScheme) {
    final cardImageIndex =
        service.code.hashCode.abs() % backgroundImages.length;

    return GestureDetector(
      onTap: () => _handleNavigateToPetServices(service.code),
      child: Opacity(
        opacity: service.available ? 1.0 : 0.3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 8,
                offset: const Offset(0, 2),
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
                    opacity: const AlwaysStoppedAnimation(0.1),
                  ),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primaryContainer.withAlpha(200),
                          colorScheme.primaryContainer.withAlpha(100),
                        ],
                      ),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withAlpha(80),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          getServiceIcon(service.code),
                          size: 60,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText.body(
                            service.name,
                            size: AppTextSize.md,
                            fontWeight: AppFontWeight.bold.value,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            color: colorScheme.primary,
                          ),
                          SizedBox(
                            width: 200,
                            child: CustomText.subtitle(
                              service.description,
                              size: AppTextSize.xs,
                              fontWeight: AppFontWeight.bold.value,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              color: colorScheme.primary.withAlpha(100),
                            ),
                          ),
                        ],
                      ),
                      Spacer(flex: 1),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
          Container(
            padding: kDefaultBodyPadding,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Consumer<PetServiceProvider>(
                    builder: (context, petServiceProvider, child) {
                      List<PetService> petServices =
                          petServiceProvider.petServices;
                      return GridView.count(
                        crossAxisCount: 1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3.2,
                        children: petServices.map((service) {
                          return _buildServiceCard(service, colorScheme);
                        }).toList(),
                      );
                    },
                  ),
                ),
                // Add some bottom padding to avoid FAB overlap
              ],
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () => _handleLaunchMap(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(51),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.primary.withAlpha(100),
                      width: 0,
                    ),
                  ),
                  child: Icon(
                    Icons.map_outlined,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                CustomText.body(
                  "Branch Location",
                  size: AppTextSize.md,
                  fontWeight: AppFontWeight.bold.value,
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
      floatingActionButton: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounceAnimation.value),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: FloatingActionButton.extended(
                  onPressed: () {
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
                  icon: const Icon(Icons.bookmark_border_rounded),
                  label: const Text('My Appointments'),
                  backgroundColor: colorScheme.primary.withAlpha(200),
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 8,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
