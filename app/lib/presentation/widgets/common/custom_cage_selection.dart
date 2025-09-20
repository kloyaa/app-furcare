import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/data/models/pet_service.models.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';

class CageSelection extends StatefulWidget {
  final List<PetCage>? cages;
  final PetCage? selectedCage;

  final bool isLoading;
  final VoidCallback? onRefresh;
  final Function(PetCage) onCageSelected;

  const CageSelection({
    super.key,
    this.cages,
    required this.isLoading,
    this.selectedCage,
    this.onRefresh,
    required this.onCageSelected,
  });

  @override
  State<CageSelection> createState() => _CageSelectionState();
}

class _CageSelectionState extends State<CageSelection>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    if (widget.cages == null || widget.cages!.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4, // Adjust this to control card height
      ),
      itemCount: widget.cages!.length,
      itemBuilder: (context, index) {
        return _buildRoomCard(widget.cages![index], widget.selectedCage, index);
      },
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Match actual grid (was 3, now 2)
        crossAxisSpacing: 5, // Match actual spacing
        mainAxisSpacing: 12, // Match actual spacing
        childAspectRatio: 1.4, // Match actual aspect ratio
      ),
      itemCount: 3, // Show 6 skeleton cards
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skeletonColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return Card(
      elevation: 0,
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withAlpha(77),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Size badge skeleton (top right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 18,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 10),

            // Price skeleton
            Container(
              width: 80,
              height: 20,
              decoration: BoxDecoration(
                color: skeletonColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 10),

            // Occupancy info skeleton
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 30,
                  height: 14,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Occupancy bar skeleton
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: skeletonColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard(PetCage cage, PetCage? selectedCage, int index) {
    final isFullyOccupied = cage.occupant >= cage.max;
    final occupancyPercentage = cage.max > 0
        ? (cage.occupant / cage.max).clamp(0.0, 1.0)
        : 0.0;
    final colorScheme = Theme.of(context).colorScheme;

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 200 + (index * 50)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: isFullyOccupied ? 0.3 : 1.0,
            child: Card(
              elevation: 0,
              color: isFullyOccupied
                  ? colorScheme.errorContainer
                  : selectedCage != null && selectedCage.id == cage.id
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest.withAlpha(77),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: isFullyOccupied
                    ? null
                    : () => widget.onCageSelected(cage),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Size badge and full indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getSizeColor(cage.size).withAlpha(26),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              cage.size.toUpperCase(),
                              style: TextStyle(
                                color: _getSizeColor(cage.size),
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomText.title(
                        CurrencyUtils.toPHP(cage.price),
                        size: AppTextSize.md,
                        fontWeight:
                            selectedCage != null && selectedCage.id == cage.id
                            ? AppFontWeight.black.value
                            : AppFontWeight.normal.value,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.pets_outlined,
                            size: 16,
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: CustomText.body(
                              '${cage.occupant}/${cage.max}',
                              fontWeight:
                                  selectedCage != null &&
                                      selectedCage.id == cage.id
                                  ? AppFontWeight.black.value
                                  : AppFontWeight.thin.value,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Occupancy bar
                      Stack(
                        children: [
                          _buildOccupancyBarBackground(),
                          _buildOccupancyBar(occupancyPercentage),
                        ],
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

  Widget _buildOccupancyBarBackground() {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(26),
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: 1,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 250, 250, 250).withAlpha(26),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildOccupancyBar(double percentage) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(26),
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percentage, // always between 0.0 and 1.0 now
        child: Container(
          decoration: BoxDecoration(
            color: _getOccupancyColor(percentage),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Color _getSizeColor(String size) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (size.toLowerCase()) {
      case 'small':
        return colorScheme.primary;
      case 'medium':
        return colorScheme.secondary;
      case 'large':
        return colorScheme.tertiary;
      default:
        return colorScheme.primary;
    }
  }

  Color _getOccupancyColor(double percentage) {
    if (percentage < 0.5) {
      return Colors.green;
    } else if (percentage < 0.8) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.hotel_outlined,
              size: 48,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No rooms available',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later or try refreshing',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withAlpha(153),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (widget.onRefresh != null)
            ElevatedButton.icon(
              onPressed: widget.onRefresh,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
