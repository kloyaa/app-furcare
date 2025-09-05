import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/presentation/providers/admin/admin_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    // Schedule the data loading after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    final adminProvider = context.read<AdminProvider>();
    await adminProvider.fetchUsers();
  }

  void _handleSearch(String query) {
    final adminProvider = context.read<AdminProvider>();
    adminProvider.searchUsers(query.isEmpty ? null : query);
  }

  void _handleStatusFilter(String? status) {
    setState(() {
      _selectedStatusFilter = status;
    });
    final adminProvider = context.read<AdminProvider>();
    adminProvider.filterUsersByStatus(
      status == null ? null : status == 'active',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: RefreshIndicator(
        onRefresh: _loadUsers,
        child: CustomScrollView(
          slivers: [
            // _buildHeader(theme),
            _buildFilters(theme),
            _buildUsersList(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _searchController,
                        onChanged: _handleSearch,
                        decoration: InputDecoration(
                          hintText:
                              'Search users by name, email, or username...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _handleSearch('');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatusFilter,
                        onChanged: _handleStatusFilter,
                        decoration: InputDecoration(
                          labelText: 'Status Filter',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Users'),
                          ),
                          DropdownMenuItem(
                            value: 'active',
                            child: Text('Active'),
                          ),
                          DropdownMenuItem(
                            value: 'inactive',
                            child: Text('Inactive'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: _loadUsers,
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildStatsRow(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        return Row(
          children: [
            _buildStatChip(
              theme,
              'Total Users',
              adminProvider.totalUsersCount.toString(),
              Colors.blue,
            ),
            const SizedBox(width: 12),
            _buildStatChip(
              theme,
              'Active',
              adminProvider.activeUsersCount.toString(),
              Colors.green,
            ),
            const SizedBox(width: 12),
            _buildStatChip(
              theme,
              'Inactive',
              adminProvider.inactiveUsersCount.toString(),
              Colors.orange,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatChip(
    ThemeData theme,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText.body(label, size: AppTextSize.sm, color: color),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomText.body(
              value,
              size: AppTextSize.xs,
              fontWeight: AppFontWeight.bold.value,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(ThemeData theme) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        if (adminProvider.isLoadingUsers) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (adminProvider.users.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: theme.colorScheme.onSurface.withAlpha(100),
                  ),
                  const SizedBox(height: 16),
                  CustomText.body(
                    'No users found',
                    size: AppTextSize.lg,
                    color: theme.colorScheme.onSurface.withAlpha(160),
                  ),
                  const SizedBox(height: 8),
                  CustomText.body(
                    'Try adjusting your search or filters',
                    color: theme.colorScheme.onSurface.withAlpha(125),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final user = adminProvider.users[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: _buildUserCard(theme, user),
              );
            }, childCount: adminProvider.users.length),
          ),
        );
      },
    );
  }

  Widget _buildUserCard(ThemeData theme, user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: user.isActive
                  ? Colors.green.withAlpha(40)
                  : Colors.grey.withAlpha(40),
              child: Icon(
                Icons.person,
                color: user.isActive ? Colors.green : Colors.grey,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText.body(
                        user.fullName.isNotEmpty
                            ? user.fullName
                            : user.username,
                        fontWeight: AppFontWeight.bold.value,
                        size: AppTextSize.md,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: user.isActive
                              ? Colors.green.withAlpha(20)
                              : Colors.grey.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomText.body(
                          user.isActive ? 'Active' : 'Inactive',
                          size: AppTextSize.xs,
                          color: user.isActive ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  CustomText.body(
                    user.email,
                    color: theme.colorScheme.onSurface.withAlpha(200),
                  ),
                  const SizedBox(height: 2),
                  CustomText.body(
                    '@${user.username}',
                    size: AppTextSize.sm,
                    color: theme.colorScheme.onSurface.withAlpha(125),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.body(
                    'Phone',
                    size: AppTextSize.xs,
                    color: theme.colorScheme.onSurface.withAlpha(125),
                  ),
                  CustomText.body(
                    user.contact.phoneNumber.isNotEmpty
                        ? user.contact.phoneNumber
                        : 'Not provided',
                    size: AppTextSize.sm,
                  ),
                  const SizedBox(height: 8),
                  CustomText.body(
                    'Roles',
                    size: AppTextSize.xs,
                    color: theme.colorScheme.onSurface.withAlpha(125),
                  ),
                  Wrap(
                    spacing: 4,
                    children: user.roles.map<Widget>((role) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withAlpha(
                            70,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomText.body(
                          role,
                          size: AppTextSize.xs,
                          color: theme.colorScheme.primary,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () => _showUserDetails(user),
                  icon: const Icon(Icons.visibility_outlined),
                  tooltip: 'View Details',
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 20),
                          const SizedBox(width: 8),
                          CustomText.body('Edit User'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'toggle_status',
                      child: Row(
                        children: [
                          Icon(
                            user.isActive
                                ? Icons.block_outlined
                                : Icons.check_circle_outline,
                            size: 20,
                            color: user.isActive ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          CustomText.body(
                            user.isActive ? 'Deactivate' : 'Activate',
                            color: user.isActive ? Colors.red : Colors.green,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          CustomText.body('Delete', color: Colors.red),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) => _handleUserAction(value, user),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUserDetails(user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText.title('User Details'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Full Name', user.fullName),
              _buildDetailRow('Username', user.username),
              _buildDetailRow('Email', user.email),
              _buildDetailRow('Phone', user.contact.phoneNumber),
              _buildDetailRow('Address', user.address),
              _buildDetailRow('Status', user.isActive ? 'Active' : 'Inactive'),
              _buildDetailRow('Roles', user.roles.join(', ')),
              _buildDetailRow('Created', _formatDate(user.createdAt)),
              _buildDetailRow('Updated', _formatDate(user.updatedAt)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: CustomText.body(
              '$label:',
              fontWeight: AppFontWeight.semibold.value,
              size: AppTextSize.sm,
            ),
          ),
          Expanded(
            child: CustomText.body(
              value.isNotEmpty ? value : 'Not provided',
              size: AppTextSize.sm,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _handleUserAction(String action, user) {
    switch (action) {
      case 'edit':
        _showEditUserDialog(user);
        break;
      case 'toggle_status':
        _toggleUserStatus(user);
        break;
      case 'delete':
        _showDeleteUserDialog(user);
        break;
    }
  }

  void _showEditUserDialog(user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText.title('Edit User'),
        content: const Text(
          'Edit user functionality would be implemented here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _toggleUserStatus(user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText.title('Confirm Action'),
        content: Text(
          'Are you sure you want to ${user.isActive ? 'deactivate' : 'activate'} this user?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement status toggle
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'User ${user.isActive ? 'deactivated' : 'activated'} successfully',
                  ),
                ),
              );
            },
            child: Text(user.isActive ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteUserDialog(user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText.title('Delete User'),
        content: const Text(
          'Are you sure you want to delete this user? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement user deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User deleted successfully')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // void _showAddUserDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: CustomText.title('Add New User'),
  //       content: const SizedBox(
  //         width: 400,
  //         child: Text('Add new user form would be implemented here.'),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text('Cancel'),
  //         ),
  //         FilledButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text('Add User'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
