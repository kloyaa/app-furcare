import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/date.dart';
import 'package:furcare_app/core/utils/formatters.dart';
import 'package:furcare_app/core/utils/validate.dart';
import 'package:furcare_app/data/models/client_models.dart';
import 'package:furcare_app/presentation/providers/client_provider.dart';
import 'package:furcare_app/presentation/routes/staff_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StaffProfileScreen extends StatefulWidget {
  const StaffProfileScreen({super.key});

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientProvider>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        showThemeToggle: false,
        actions: [
          IconButton(
            onPressed: () => context.push(StaffRoute.profile.profileEdit),
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: Consumer<ClientProvider>(
        builder: (context, clientProvider, child) {
          if (clientProvider.isLoading) {
            return _buildSkeletonLoader(context);
          }

          final Client client = clientProvider.client;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: colorScheme.secondaryContainer,
                        child: CustomText.title(
                          getInitials(clientProvider.client.fullName),
                          size: AppTextSize.lg,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomText.subtitle(
                        client.fullName,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.green.withAlpha(51),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CustomText.caption(
                          client.isActive == true ? 'Active' : 'Inactive',
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Information Cards
                _buildInfoCard(
                  context,
                  'Contact Information',
                  Icons.contact_phone,
                  [
                    _buildInfoRow(
                      'Phone',
                      client.contact.phoneNumber,
                      Icons.phone,
                    ),
                    _buildInfoRow(
                      'Facebook Name',
                      client.contact.facebookDisplayName?.isEmpty == true
                          ? "Not provided"
                          : client.contact.facebookDisplayName ??
                                "Not provided",
                      Icons.facebook,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildInfoCard(context, 'Personal Details', Icons.person, [
                  _buildInfoRow('Address', client.address, Icons.location_on),
                  _buildInfoRow(
                    'Member Since',
                    DateTimeUtils.formatDateToLong(
                      DateTime.parse(client.createdAt!),
                    ),
                    Icons.calendar_today,
                  ),
                ]),

                const SizedBox(height: 16),

                _buildInfoCard(context, 'Account Activity', Icons.history, [
                  _buildInfoRow(
                    'Last Login',
                    client.others.lastLogin,
                    Icons.login,
                  ),
                  _buildInfoRow(
                    'Last Password Change',
                    isValidDate(client.others.lastChangePassword)
                        ? DateTimeUtils.formatDateToLong(
                            DateTime.parse(client.others.lastChangePassword),
                          )
                        : "N/A",
                    Icons.lock,
                  ),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header Skeleton
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                // Avatar skeleton
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(77),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 16),
                // Name skeleton
                Container(
                  width: 120,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimaryContainer.withAlpha(77),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                // Status skeleton
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimaryContainer.withAlpha(77),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Information Cards Skeleton
          _buildSkeletonInfoCard(context, 3), // Contact Information
          const SizedBox(height: 16),
          _buildSkeletonInfoCard(context, 2), // Personal Details
          const SizedBox(height: 16),
          _buildSkeletonInfoCard(context, 2), // Account Activity
        ],
      ),
    );
  }

  Widget _buildSkeletonInfoCard(BuildContext context, int itemCount) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: colorScheme.outline.withAlpha(26), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header skeleton
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withAlpha(77),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 150,
                  height: 18,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withAlpha(77),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Info rows skeleton
            ...List.generate(
              itemCount,
              (index) => _buildSkeletonInfoRow(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonInfoRow(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withAlpha(77),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withAlpha(77),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withAlpha(51),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: colorScheme.outline.withAlpha(26), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                CustomText.title(title, size: AppTextSize.md),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: colorScheme.onSurfaceVariant, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.body(label, size: AppTextSize.xs),
                    const SizedBox(height: 2),
                    GestureDetector(
                      onTap: () {
                        if (label == 'Phone' && value != 'Not provided') {
                          Clipboard.setData(ClipboardData(text: value));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Phone number copied'),
                            ),
                          );
                        }
                      },
                      child: CustomText(value, size: AppTextSize.sm),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
