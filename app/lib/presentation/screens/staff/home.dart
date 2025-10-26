import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/application.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/data/models/__staff/appointment_request.dart';
import 'package:furcare_app/data/models/__staff/appointments_model.dart';
import 'package:furcare_app/presentation/providers/auth_provider.dart';
import 'package:furcare_app/presentation/providers/client_provider.dart';
import 'package:furcare_app/presentation/providers/staff/appointment_provider.dart';
import 'package:furcare_app/presentation/routes/staff_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/common/default_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Map<String, bool> _paymentsExpanded = {};

  void _initializeAnimations() {
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeOut),
    );

    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeAnimationController.forward();
    });
  }

  void _loadAppointments() {
    Future.microtask(() {
      if (mounted) {
        context.read<StaffAppointmentProvider>().getCustomerAppointments();
      }
    });
  }

  // Action Handlers
  void _handleCall(String mobileNumber) {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: mobileNumber);
      launchUrl(phoneUri);
      showCustomSnackBar(context, 'Opening phone app...');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handleAccept(CustomerAppointment appointment) async {
    final payload = AppointmentStatusUpdateRequest(
      application: appointment.id,
      applicationType: ApplicationModel.fromStringToModel(
        appointment.applicationType,
      ).value,
      status: ApplicationStatus.approved.value,
    );
    final appointmentProvider = context.read<StaffAppointmentProvider>();

    await appointmentProvider.updateAppointmentStatus(payload);

    if (!mounted) return;

    if (appointmentProvider.errorMessageUpdate != null) {
      Navigator.of(context)
        ..pop()
        ..pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.close_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(appointmentProvider.errorMessageUpdate!),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.of(context)
      ..pop()
      ..pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text('Application accepted successfully'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleReject(CustomerAppointment appointment) async {
    final payload = AppointmentStatusUpdateRequest(
      application: appointment.id,
      applicationType: ApplicationModel.fromStringToModel(
        appointment.applicationType,
      ).value,
      status: ApplicationStatus.rejected.value,
    );
    final appointmentProvider = context.read<StaffAppointmentProvider>();

    await appointmentProvider.updateAppointmentStatus(payload);

    if (!mounted) return;

    if (appointmentProvider.errorMessageUpdate != null) {
      Navigator.of(context)
        ..pop()
        ..pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.close_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(appointmentProvider.errorMessageUpdate!),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.of(context)
      ..pop()
      ..pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text('Application rejected successfully'),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleComplete(CustomerAppointment appointment) async {
    final payload = AppointmentStatusUpdateRequest(
      application: appointment.id,
      applicationType: ApplicationModel.fromStringToModel(
        appointment.applicationType,
      ).value,
      status: ApplicationStatus.completed.value,
    );
    final appointmentProvider = context.read<StaffAppointmentProvider>();

    await appointmentProvider.updateAppointmentStatus(payload);

    if (!mounted) return;

    if (appointmentProvider.errorMessageUpdate != null) {
      Navigator.of(context)
        ..pop()
        ..pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.close_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(appointmentProvider.errorMessageUpdate!),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.of(context)
      ..pop()
      ..pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text('Application completed successfully'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleLogout() async {
    await context.read<AuthProvider>().logout();
    if (mounted) {
      Navigator.of(context)
        ..pop()
        ..pop();

      context.go('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ClientProvider>().getProfile();
      }
    });
    _initializeAnimations();
    _loadAppointments();
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      drawer: _buildDrawer(theme, colorScheme),
      appBar: AppBar(
        iconTheme: IconThemeData(color: colorScheme.primary),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        actions: [_buildRefreshButton(colorScheme)],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildStatusFilter(theme, colorScheme),
            _buildStatsCard(theme, colorScheme),
            _buildSearchSection(theme, colorScheme),
            _buildTabBar(theme, colorScheme),
            Expanded(
              child: Consumer<StaffAppointmentProvider>(
                builder: (context, provider, child) {
                  if (provider.customerAppointments == null &&
                      !provider.isFetchingAppointments) {
                    return _buildLoadingState();
                  }

                  if (provider.customerAppointments == null) {
                    return _buildLoadingState();
                  }

                  return _buildTabContent(
                    theme,
                    provider.customerAppointments!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: CustomText.title('Logout'),
        content: CustomText.body('Are you sure you want to logout?'),
        actions: [
          CustomButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            isOutlined: true,
          ),
          const SizedBox(height: 8),
          CustomButton(
            text: 'Logout',
            onPressed: () => _handleLogout(),
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(ThemeData theme, ColorScheme colorScheme) {
    final clientProvider = context.watch<ClientProvider>();
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.maxFinite,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset('assets/furcare_logo.png', height: 100),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText.title(
                        clientProvider.client.fullName,
                        size: AppTextSize.md,
                      ),
                      CustomText.body(
                        clientProvider.client.contact.phoneNumber,
                        size: AppTextSize.sm,
                        color: colorScheme.onSurface.withAlpha(160),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDrawerTile(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () => context.push(StaffRoute.profile.profile),
                ),
                const SizedBox(height: 8),
                _buildDrawerTile(
                  icon: Icons.settings_outlined,
                  title: 'Account Settings',
                  onTap: () => context.push(StaffRoute.user.changePassword),
                ),
                const SizedBox(height: 8),
                _buildDrawerTile(
                  icon: Icons.list_outlined,
                  title: 'Activities',
                  onTap: () => context.push(StaffRoute.activities),
                ),
              ],
            ),
          ),

          // Logout Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildDrawerTile(
              icon: Icons.logout_outlined,
              title: 'Logout',
              onTap: () => _showLogoutDialog(),
              isDestructive: true,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final color = isDestructive ? Colors.red : theme.colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: color),
      title: CustomText.body(
        title,
        color: color,
        fontWeight: AppFontWeight.semibold.value,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildStatusFilter(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Consumer<StaffAppointmentProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: ApplicationStatus.values.map((status) {
                final isSelected = provider.currentStatus == status;
                final isLoading =
                    isSelected && provider.isFetchingNewAppointments;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildStatusChip(
                    status,
                    isSelected,
                    isLoading,
                    colorScheme,
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(
    ApplicationStatus status,
    bool isSelected,
    bool isLoading,
    ColorScheme colorScheme,
  ) {
    return InkWell(
      onTap: isLoading
          ? null
          : () => context
                .read<StaffAppointmentProvider>()
                .fetchNewAppointmentsByStatus(status),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest.withAlpha(64),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withAlpha(64),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 8),
            ],
            CustomText.body(
              status.displayName,
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface.withAlpha(180),
              fontWeight: isSelected
                  ? AppFontWeight.bold.value
                  : FontWeight.normal,
              size: AppTextSize.sm,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(ThemeData theme, ColorScheme colorScheme) {
    return Consumer<StaffAppointmentProvider>(
      builder: (context, provider, child) {
        final customerAppointments = provider.customerAppointments;

        if (customerAppointments == null) {
          return _buildStatsLoadingCard(colorScheme);
        }

        final stats = customerAppointments.statistics;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline.withAlpha(64)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomText.body(
                      'Appointments Overview - ${provider.currentStatus.displayName}',
                      fontWeight: AppFontWeight.bold.value,
                      size: AppTextSize.sm,
                      color: colorScheme.onSurface.withAlpha(160),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(32),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomText.body(
                      provider.currentStatus.displayName.toUpperCase(),
                      size: AppTextSize.xs,
                      fontWeight: AppFontWeight.bold.value,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'ALL',
                    stats.total.toString(),
                    Icons.dashboard_outlined,
                    colorScheme.primary,
                  ),
                  _buildStatItem(
                    'Grooming',
                    stats.grooming.toString(),
                    Icons.pets_outlined,
                    Colors.blue,
                  ),
                  _buildStatItem(
                    'Boarding',
                    stats.boarding.toString(),
                    Icons.hotel_outlined,
                    Colors.green,
                  ),
                  _buildStatItem(
                    'Home Service',
                    stats.homeService.toString(),
                    Icons.home_outlined,
                    Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsLoadingCard(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(64),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          4,
          (index) => Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: colorScheme.outline.withAlpha(32),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(32),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        CustomText.title(
          value,
          size: AppTextSize.mlg,
          color: color,
          fontWeight: AppFontWeight.black.value,
        ),
        CustomText.body(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 9,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withAlpha(160),
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSearchSection(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _buildSearchBar(theme, colorScheme),
    );
  }

  Widget _buildSearchBar(ThemeData theme, ColorScheme colorScheme) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: 'Search appointments...',
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withAlpha(160),
          fontSize: AppTextSize.sm.size,
        ),
        prefixIcon: Icon(
          Icons.search_outlined,
          color: colorScheme.onSurface.withAlpha(160),
        ),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: colorScheme.onSurface.withAlpha(160),
                ),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
            : null,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withAlpha(64),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _buildRefreshButton(ColorScheme colorScheme) {
    return Consumer<StaffAppointmentProvider>(
      builder: (context, provider, child) {
        if (provider.isRefetching) {
          return Container(
            margin: const EdgeInsets.all(12),
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: colorScheme.primary,
            ),
          );
        }

        return IconButton(
          onPressed: () =>
              context.read<StaffAppointmentProvider>().refreshAppointments(),
          icon: Icon(
            Icons.refresh_outlined,
            color: colorScheme.primary,
            size: 32,
          ),
          tooltip: 'Refresh',
        );
      },
    );
  }

  Widget _buildTabBar(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(64),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        tabs: [
          Tab(icon: Icon(Icons.dashboard_outlined)),
          Tab(icon: Icon(Icons.pets_outlined)),
          Tab(icon: Icon(Icons.hotel_outlined)),
          Tab(icon: Icon(Icons.home_outlined)),
        ],
        labelStyle: TextStyle(
          fontSize: AppTextSize.xs.size,
          fontWeight: AppFontWeight.black.value,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppTextSize.xs.size,
          fontWeight: FontWeight.normal,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorScheme.primary,
        ),
        labelColor: colorScheme.onPrimary,
        unselectedLabelColor: colorScheme.onSurface.withAlpha(160),
        dividerColor: Colors.transparent,
        isScrollable: true,
        tabAlignment: TabAlignment.center,
      ),
    );
  }

  Widget _buildTabContent(
    ThemeData theme,
    CustomerAppointments customerAppointments,
  ) {
    final appointments = customerAppointments.appointments;
    final filteredAppointments = _getFilteredAppointments(appointments);

    return Container(
      margin: const EdgeInsets.all(16),
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentList(theme, filteredAppointments),
          _buildAppointmentList(
            theme,
            _filterByType(filteredAppointments, 'grooming'),
          ),
          _buildAppointmentList(
            theme,
            _filterByType(filteredAppointments, 'boarding'),
          ),
          _buildAppointmentList(
            theme,
            _filterByType(filteredAppointments, 'homeservice'),
          ),
        ],
      ),
    );
  }

  List<CustomerAppointment> _getFilteredAppointments(
    List<CustomerAppointment> appointments,
  ) {
    if (_searchQuery.isEmpty) return appointments;

    final query = _searchQuery.toLowerCase();
    return appointments.where((appointment) {
      return appointment.userInfo.fullName.toLowerCase().contains(query) ||
          appointment.userInfo.username.toLowerCase().contains(query) ||
          appointment.userInfo.phoneNumber.contains(query) ||
          appointment.petInfo.name.toLowerCase().contains(query) ||
          appointment.applicationType.toLowerCase().contains(query) ||
          appointment.id.toLowerCase().contains(query);
    }).toList();
  }

  List<CustomerAppointment> _filterByType(
    List<CustomerAppointment> appointments,
    String type,
  ) {
    return appointments
        .where((a) => a.applicationType.toLowerCase() == type)
        .toList();
  }

  Widget _buildAppointmentList(
    ThemeData theme,
    List<CustomerAppointment> appointments,
  ) {
    if (appointments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) =>
          _buildAppointmentCard(theme, appointments[index]),
    );
  }

  Widget _buildAppointmentCard(
    ThemeData theme,
    CustomerAppointment appointment,
  ) {
    final serviceColor = _getServiceColor(appointment.applicationType);
    final serviceIcon = _getServiceIcon(appointment.applicationType);
    final serviceName = _getServiceDisplayName(appointment.applicationType);
    final isFullyPaid = appointment.paymentStatus.toLowerCase() == 'fully_paid';
    double balance =
        appointment.totalPrice.toDouble() - appointment.paidAmount.toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outline.withAlpha(32),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clean header section
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: serviceColor.withAlpha(16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(serviceIcon, color: serviceColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.title(
                          serviceName,
                          size: AppTextSize.md,
                          fontWeight: AppFontWeight.bold.value,
                        ),
                        const SizedBox(height: 2),
                        CustomText.body(
                          '#${appointment.id.substring(0, 8).toUpperCase()}',
                          size: AppTextSize.sm,
                          color: theme.colorScheme.onSurface.withAlpha(160),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildMinimalStatusChip(appointment.status, serviceColor),
                      const SizedBox(height: 4),
                      CustomText.body(
                        appointment.submittedAt.split('T')[0],
                        size: AppTextSize.xs,
                        color: theme.colorScheme.onSurface.withAlpha(120),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Clean divider
              Container(
                height: 1,
                color: theme.colorScheme.outline.withAlpha(32),
              ),

              const SizedBox(height: 20),

              // Customer and Pet info in clean grid
              Row(
                children: [
                  Expanded(
                    child: _buildMinimalInfoSection(
                      'Customer',
                      appointment.userInfo.fullName,
                      appointment.userInfo.phoneNumber,
                      theme,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildMinimalInfoSection(
                      'Pet',
                      appointment.petInfo.name,
                      appointment.petInfo.breed,
                      theme,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Payment information with progress indicator
              if (appointment.paymentUploads.isNotEmpty) ...[
                const SizedBox(height: 16),
                CustomText.body(
                  'Payment Proofs',
                  size: AppTextSize.sm,
                  fontWeight: AppFontWeight.bold.value,
                  color: theme.colorScheme.onSurface.withAlpha(160),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: appointment.paymentUploads.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final proof = appointment.paymentUploads[index];
                      return GestureDetector(
                        onTap: () async {
                          final url = proof.url;
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: GestureDetector(
                            onTap: () => _showImagePreview(proof.url),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                proof.url,
                                width: 120,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80,
                                  height: 120,
                                  color: Colors.grey.withAlpha(32),
                                  child: const Icon(
                                    Icons.broken_image_outlined,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              // Add after payment proof section in _buildAppointmentCard
              if (appointment.payments.isNotEmpty) ...[
                const SizedBox(height: 16),
                CustomText.body(
                  'Payment Records',
                  size: AppTextSize.sm,
                  fontWeight: AppFontWeight.bold.value,
                  color: theme.colorScheme.onSurface.withAlpha(160),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(
                      64,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withAlpha(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      ..._buildPaymentList(appointment, theme),
                      if (appointment.payments.length > 3)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _paymentsExpanded[appointment.id] =
                                  !(_paymentsExpanded[appointment.id] ?? false);
                            });
                          },
                          child: CustomText.body(
                            _paymentsExpanded[appointment.id] == true
                                ? 'Show Less'
                                : 'Show All',
                            size: AppTextSize.xs,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              _buildMinimalPaymentSection(
                appointment,
                serviceColor,
                theme,
                balance,
                isFullyPaid,
              ),
              // Clean action button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () => _showActionsDialog(
                    appointment,
                    serviceColor,
                    serviceName,
                  ),
                  icon: Icon(Icons.more_horiz, size: 18, color: serviceColor),
                  label: CustomText.body(
                    'Manage',
                    color: serviceColor,
                    fontWeight: AppFontWeight.semibold.value,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: serviceColor.withAlpha(64)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: serviceColor.withAlpha(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPaymentList(
    CustomerAppointment appointment,
    ThemeData theme,
  ) {
    final isExpanded = _paymentsExpanded[appointment.id] ?? false;
    final paymentsToShow = isExpanded
        ? appointment.payments
        : appointment.payments.take(3).toList();

    return paymentsToShow.map((payment) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline.withAlpha(32),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.body(
                    payment.transactionReference,
                    size: AppTextSize.xs,
                    fontWeight: AppFontWeight.bold.value,
                  ),
                  const SizedBox(height: 2),
                  CustomText.body(
                    payment.accountNumber,
                    size: AppTextSize.xs,
                    color: theme.colorScheme.onSurface.withAlpha(160),
                  ),
                  const SizedBox(height: 2),
                  CustomText.body(
                    CurrencyUtils.toPHP(payment.amount.toDouble()),
                    size: AppTextSize.sm,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText.body(
                  payment.paymentMethod.toUpperCase(),
                  size: AppTextSize.xs,
                  fontWeight: AppFontWeight.semibold.value,
                ),
                const SizedBox(height: 2),
                CustomText.body(
                  payment.createdAt.split('T')[0],
                  size: AppTextSize.xs,
                  color: theme.colorScheme.onSurface.withAlpha(160),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: [
              Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                  height: double.maxFinite,
                  errorBuilder: (_, __, ___) => Container(
                    color: Theme.of(context).colorScheme.outline.withAlpha(32),
                    child: const Icon(Icons.broken_image_outlined, size: 48),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close_outlined, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalStatusChip(String status, Color serviceColor) {
    Color chipColor;

    switch (status.toLowerCase()) {
      case 'approved':
        chipColor = Colors.green;
        break;
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'completed':
        chipColor = Colors.blue;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        break;
      default:
        chipColor = serviceColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withAlpha(16),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipColor.withAlpha(64), width: 1),
      ),
      child: CustomText.body(
        status.toLowerCase() == 'approved'
            ? 'Approved'
            : status.toLowerCase() == 'pending'
            ? 'Pending'
            : status.toLowerCase() == 'completed'
            ? 'Completed'
            : status.toLowerCase() == 'cancelled'
            ? 'Cancelled'
            : status,
        size: AppTextSize.xs,
        fontWeight: AppFontWeight.semibold.value,
        color: chipColor,
      ),
    );
  }

  Widget _buildMinimalInfoSection(
    String title,
    String primaryText,
    String secondaryText,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(
          title,
          size: AppTextSize.xs,
          color: theme.colorScheme.onSurface.withAlpha(120),
          fontWeight: AppFontWeight.semibold.value,
        ),
        const SizedBox(height: 6),
        CustomText.body(
          primaryText,
          size: AppTextSize.sm,
          fontWeight: AppFontWeight.semibold.value,
        ),
        const SizedBox(height: 2),
        CustomText.body(
          secondaryText,
          size: AppTextSize.xs,
          color: theme.colorScheme.onSurface.withAlpha(160),
        ),
      ],
    );
  }

  Widget _buildMinimalPaymentSection(
    CustomerAppointment appointment,
    Color serviceColor,
    ThemeData theme,
    double balance,
    bool isFullyPaid,
  ) {
    final paymentProgress = appointment.paidAmount / appointment.totalPrice;

    return Column(
      children: [
        // Payment progress bar
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(64),
            borderRadius: BorderRadius.circular(2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: paymentProgress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                isFullyPaid ? Colors.green : serviceColor,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Payment amounts in clean row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPaymentItem(
              'Total',
              CurrencyUtils.toPHP(appointment.totalPrice.toDouble()),
              theme.colorScheme.onSurface,
              theme,
            ),
            _buildPaymentItem(
              balance < 0 ? 'Overpaid by' : 'Balance',
              balance < 0
                  ? CurrencyUtils.toPHP(balance.abs())
                  : CurrencyUtils.toPHP(balance),
              isFullyPaid ? Colors.green : serviceColor,
              theme,
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (isFullyPaid) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.check_circle_outline, size: 24, color: Colors.green),
              const SizedBox(width: 4),
              CustomText.body(
                'FULLY PAID',
                size: AppTextSize.md,
                color: Colors.green,
                fontWeight: AppFontWeight.black.value,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildPaymentItem(
    String label,
    String amount,
    Color amountColor,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(
          label,
          size: AppTextSize.xs,
          color: theme.colorScheme.onSurface.withAlpha(120),
          fontWeight: AppFontWeight.semibold.value,
        ),
        const SizedBox(height: 2),
        CustomText.body(
          amount,
          size: AppTextSize.sm,
          fontWeight: AppFontWeight.bold.value,
          color: amountColor,
        ),
      ],
    );
  }

  // Service Helper Methods
  String _getServiceDisplayName(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'grooming':
        return 'Grooming';
      case 'boarding':
        return 'Boarding';
      case 'homeservice':
        return 'Home Service';
      default:
        return serviceType;
    }
  }

  Color _getServiceColor(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'grooming':
        return Colors.blue;
      case 'boarding':
        return Colors.green;
      case 'homeservice':
        return Colors.orange;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _getServiceIcon(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'grooming':
        return Icons.pets_outlined;
      case 'boarding':
        return Icons.hotel_outlined;
      case 'homeservice':
        return Icons.home_outlined;
      default:
        return Icons.star_outlined;
    }
  }

  // Action Dialogs
  void _showActionsDialog(
    CustomerAppointment appointment,
    Color serviceColor,
    String serviceName,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(appointment, serviceColor, serviceName),
              const SizedBox(height: 24),
              _buildActionButtons(appointment, serviceColor, serviceName),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader(
    CustomerAppointment appointment,
    Color serviceColor,
    String serviceName,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: serviceColor.withAlpha(32),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getServiceIcon(appointment.applicationType),
            color: serviceColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText.title('Choose Action', size: AppTextSize.md),
              CustomText.body(
                serviceName,
                size: AppTextSize.sm,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    CustomerAppointment appointment,
    Color serviceColor,
    String serviceName,
  ) {
    final isPending = appointment.status.toLowerCase() == 'pending';
    final isApproved = appointment.status.toLowerCase() == 'approved';

    return Column(
      children: [
        // Preview Button
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Preview Appointment',
            onPressed: () {
              Navigator.pop(context);
              _showPreviewDialog(appointment, serviceColor, serviceName);
            },
            icon: Icons.visibility_outlined,
            isOutlined: true,
          ),
        ),

        const SizedBox(height: 12),

        // Call Button
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Call Customer',
            onPressed: () {
              Navigator.pop(context);
              _handleCall(appointment.userInfo.phoneNumber);
            },
            icon: Icons.phone_outlined,
            backgroundColor: Colors.blue.withAlpha(32),
            textColor: Colors.blue,
          ),
        ),

        const SizedBox(height: 12),

        // Conditional Action Buttons
        if (isPending) ...[
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Reject Application',
              onPressed: () => _showRejectDialog(appointment),
              icon: Icons.close_outlined,
              backgroundColor: Colors.red.withAlpha(32),
              textColor: Colors.red,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Accept Application',
              onPressed: () => _showAcceptDialog(appointment),
              icon: Icons.check_outlined,
              backgroundColor: Colors.green,
            ),
          ),
        ],
        if (isApproved) ...[
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Complete Appointment',
              onPressed: () => _showCompleteDialog(appointment),
              icon: Icons.check_outlined,
              backgroundColor: Colors.green,
            ),
          ),
        ],

        const SizedBox(height: 64),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Mark as Paid',
            onPressed: () {
              Navigator.pop(context);
              _handleCall(appointment.userInfo.phoneNumber);
            },
            icon: Icons.check_outlined,
            backgroundColor: Colors.green.withAlpha(32),
            textColor: Colors.green,
          ),
        ),

        const SizedBox(height: 12),
        // Close Button
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Close',
            onPressed: () => Navigator.pop(context),
            isOutlined: true,
          ),
        ),
      ],
    );
  }

  void _showAcceptDialog(CustomerAppointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: CustomText.title('Accept Application'),
        content: CustomText.body(
          'Are you sure you want to accept this ${_getServiceDisplayName(appointment.applicationType).toLowerCase()} application from ${appointment.userInfo.fullName}?',
        ),
        actions: [
          CustomButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            isOutlined: true,
          ),
          const SizedBox(height: 8),
          Consumer<StaffAppointmentProvider>(
            builder: (context, provider, child) {
              return CustomButton(
                text: 'Accept',
                onPressed: () => _handleAccept(appointment),
                backgroundColor: Colors.green,
                isLoading: provider.isUpdatingAppointmentStatus,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(CustomerAppointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: CustomText.title('Reject Application'),
        content: CustomText.body(
          'Are you sure you want to reject this ${_getServiceDisplayName(appointment.applicationType).toLowerCase()} application from ${appointment.userInfo.fullName}?',
        ),
        actions: [
          CustomButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            isOutlined: true,
          ),
          const SizedBox(height: 8),
          Consumer<StaffAppointmentProvider>(
            builder: (context, provider, child) {
              return CustomButton(
                text: 'Reject',
                onPressed: () => _handleReject(appointment),
                backgroundColor: Colors.green,
                isLoading: provider.isUpdatingAppointmentStatus,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCompleteDialog(CustomerAppointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: CustomText.title('Complete Appointment'),
        content: CustomText.body(
          'Are you sure you want to complete this ${_getServiceDisplayName(appointment.applicationType).toLowerCase()} appointment with ${appointment.userInfo.fullName}?',
        ),
        actions: [
          CustomButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            isOutlined: true,
          ),
          const SizedBox(height: 8),
          Consumer<StaffAppointmentProvider>(
            builder: (context, provider, child) {
              return CustomButton(
                text: 'Complete',
                onPressed: () => _handleComplete(appointment),
                backgroundColor: Colors.green,
                isLoading: provider.isUpdatingAppointmentStatus,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPreviewDialog(
    CustomerAppointment appointment,
    Color serviceColor,
    String serviceName,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: serviceColor.withAlpha(32),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getServiceIcon(appointment.applicationType),
                        color: serviceColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.title(
                            '$serviceName Details',
                            size: AppTextSize.md,
                          ),
                          CustomText.body(
                            'Appointment Preview',
                            size: AppTextSize.sm,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(160),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_outlined),
                    ),
                  ],
                ),

                const Divider(height: 24),

                _buildPreviewSection('Customer Information', [
                  _buildPreviewRow('Name', appointment.userInfo.fullName),
                  _buildPreviewRow('Username', appointment.userInfo.username),
                  _buildPreviewRow('Phone', appointment.userInfo.phoneNumber),
                  _buildPreviewRow('Email', appointment.userInfo.email),
                  _buildPreviewRow('Address', appointment.userInfo.address),
                ]),

                const SizedBox(height: 16),

                _buildPreviewSection('Pet Information', [
                  _buildPreviewRow('Pet Name', appointment.petInfo.name),
                  _buildPreviewRow('Breed', appointment.petInfo.breed),
                  _buildPreviewRow('Gender', appointment.petInfo.gender),
                ]),

                const SizedBox(height: 16),

                _buildPreviewSection('Service Details', [
                  _buildPreviewRow('Branch', appointment.branchName),
                  _buildPreviewRow(
                    'Total Price',
                    CurrencyUtils.toPHP(appointment.totalPrice.toDouble()),
                  ),
                  _buildPreviewRow(
                    'Payment Status',
                    appointment.paymentStatus.toUpperCase(),
                  ),
                  _buildPreviewRow(
                    'Submitted',
                    appointment.submittedAt.split('T')[0],
                  ),
                ]),

                if (appointment.paymentUploads.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildPreviewSection('Payment Proofs', [
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: appointment.paymentUploads.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final proof = appointment.paymentUploads[index];
                          return GestureDetector(
                            onTap: () async {
                              final url = proof.url;
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GestureDetector(
                                onTap: () => _showImagePreview(proof.url),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    proof.url,
                                    width: 120,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey.withAlpha(32),
                                      child: const Icon(
                                        Icons.broken_image_outlined,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
                ],
                if (appointment.payments.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildPreviewSection('Payment Records', [
                    Column(
                      children: [
                        ..._buildPaymentList(appointment, Theme.of(context)),
                        if (appointment.payments.length > 3)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _paymentsExpanded[appointment.id] =
                                    !(_paymentsExpanded[appointment.id] ??
                                        false);
                              });
                            },
                            child: CustomText.body(
                              _paymentsExpanded[appointment.id] == true
                                  ? 'Show Less'
                                  : 'Show All',
                              size: AppTextSize.xs,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ]),
                ],
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Close',
                    onPressed: () => Navigator.pop(context),
                    isOutlined: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(
          title,
          fontWeight: AppFontWeight.bold.value,
          size: AppTextSize.sm,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomText.body(label, size: AppTextSize.sm),
          ),
          Expanded(
            flex: 3,
            child: CustomText.body(
              value,
              fontWeight: AppFontWeight.bold.value,
              size: AppTextSize.sm,
            ),
          ),
        ],
      ),
    );
  }

  // Empty and Error States
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isNotEmpty
                ? Icons.search_off_outlined
                : Icons.inbox_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
          ),
          const SizedBox(height: 16),
          CustomText(
            size: AppTextSize.mlg,
            fontWeight: AppFontWeight.bold.value,
            _searchQuery.isNotEmpty
                ? 'No Search Results'
                : 'No appointments Found',
          ),
          const SizedBox(height: 8),
          CustomText.body(
            _searchQuery.isNotEmpty
                ? 'No appointments match your search criteria'
                : 'There are no appointments in this category.',
            color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 16),
            CustomButton(
              text: 'Clear Search',
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              icon: Icons.clear_outlined,
              isOutlined: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          CustomText.body('Loading appointments...'),
        ],
      ),
    );
  }
}
