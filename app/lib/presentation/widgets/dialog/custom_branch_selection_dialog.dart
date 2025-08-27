import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/data/models/branch_models.dart';
import 'package:furcare_app/presentation/providers/branch_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class BranchSelectionDialog extends StatefulWidget {
  final VoidCallback onBranchSelected;

  const BranchSelectionDialog({super.key, required this.onBranchSelected});

  @override
  State<BranchSelectionDialog> createState() => _BranchSelectionDialogState();
}

class _BranchSelectionDialogState extends State<BranchSelectionDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  Branch? selectedBranch;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Opacity(opacity: _opacityAnimation.value, child: child),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxHeight: 650),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(64),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Theme.of(context).primaryColor.withAlpha(26),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildHeader(),
                  Flexible(child: _buildBranchList()),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withAlpha(204),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(51),
                    border: Border.all(
                      color: Colors.white.withAlpha(77),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 36,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          CustomText.title('Choose Branch', color: colorScheme.onPrimary),
          const SizedBox(height: 8),
          CustomText.body(
            'Select your preferred location to get started',
            color: colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildBranchList() {
    return Consumer<BranchProvider>(
      builder: (context, branchProvider, child) {
        if (branchProvider.isFetchingApplication) {
          return Container(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitWave(color: Theme.of(context).primaryColor, size: 30.0),
                const SizedBox(height: 20),
                Text(
                  'Loading branches...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          );
        }

        if (branchProvider.branches.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).disabledColor.withAlpha(26),
                  ),
                  child: Icon(
                    Icons.store_mall_directory_outlined,
                    size: 48,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'No branches available',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please try again later',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).disabledColor.withAlpha(179),
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          child: ListView.builder(
            shrinkWrap: false,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: branchProvider.branches.length,
            itemBuilder: (context, index) {
              final branch = branchProvider.branches[index];
              final isSelected = selectedBranch?.id == branch.id;

              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 300 + (index * 50)),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: IgnorePointer(
                  ignoring: !branch.open,
                  child: Opacity(
                    opacity: branch.open ? 1 : 0.4,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  selectedBranch = branch;
                                });
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(
                                        context,
                                      ).dividerColor.withAlpha(77),
                                width: isSelected ? 2.5 : 1,
                              ),
                              color: isSelected
                                  ? Theme.of(context).primaryColor.withAlpha(20)
                                  : Theme.of(context).cardColor,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor.withAlpha(38),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: branch.open
                                        ? Colors.green.withAlpha(38)
                                        : Colors.orange.withAlpha(38),
                                    border: Border.all(
                                      color: branch.open
                                          ? Colors.green.withAlpha(77)
                                          : Colors.orange.withAlpha(77),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    branch.open
                                        ? Icons.store_rounded
                                        : Icons.schedule_rounded,
                                    color: branch.open
                                        ? Colors.green[700]
                                        : Colors.orange[700],
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomText.body(
                                              branch.name,
                                              fontWeight:
                                                  AppFontWeight.bold.value,
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: branch.open
                                                  ? Colors.green.withAlpha(38)
                                                  : Colors.orange.withAlpha(38),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 6,
                                                  height: 6,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: branch.open
                                                        ? Colors.green
                                                        : Colors.orange,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                CustomText.body(
                                                  branch.open
                                                      ? 'Open'
                                                      : 'Closed',
                                                  size: AppTextSize.xs,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_rounded,
                                            size: 16,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color
                                                ?.withAlpha(179),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: CustomText.body(
                                              branch.address,
                                              size: AppTextSize.xs,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone_rounded,
                                            size: 16,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor.withAlpha(179),
                                          ),
                                          const SizedBox(width: 4),
                                          CustomText.body(branch.phone),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedScale(
                                  scale: isSelected ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withAlpha(128),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          CustomButton(
            text: selectedBranch != null
                ? selectedBranch!.name
                : 'Please select a branch',
            onPressed: selectedBranch != null
                ? () {
                    // Use post-frame callback to avoid issues with provider updates
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<BranchProvider>().setSelectedBranch(
                        selectedBranch!,
                      );
                      Navigator.of(context).pop();
                      widget.onBranchSelected();
                    });
                  }
                : null,
            isOutlined: true,
            icon: Icons.arrow_forward_ios_outlined,
          ),
        ],
      ),
    );
  }
}
