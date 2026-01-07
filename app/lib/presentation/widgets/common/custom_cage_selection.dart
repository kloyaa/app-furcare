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
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width < 360
            ? 1
            : width < 600
            ? 2
            : 3;
        final aspectRatio = width < 360 ? 1.1 : 1.35;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 8,
            childAspectRatio: aspectRatio,
          ),
          itemCount: widget.cages!.length,
          itemBuilder: (context, index) {
            return _buildRoomCard(
              widget.cages![index],
              widget.selectedCage,
              index,
            );
          },
        );
      },
    );
  }

  Widget _buildRoomCard(PetCage cage, PetCage? selectedCage, int index) {
    final isSelected = selectedCage?.id == cage.id;

    final isFullyOccupied = cage.occupant >= cage.max;
    final percentage = cage.max > 0
        ? (cage.occupant / cage.max).clamp(0.0, 1.0)
        : 0.0;

    final fillColor = _getOccupancyColor(percentage);
    final scheme = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 250 + index * 40),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: isFullyOccupied ? 0.1 : 1,
            child: Card(
              elevation: 0,
              color: isSelected ? scheme.primaryContainer.withAlpha(255) : null,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: percentage,
                        widthFactor: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: fillColor.withAlpha(45),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Content
                  InkWell(
                    onTap: () {
                      if (isFullyOccupied) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('This cage is full.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      widget.onCageSelected(cage);
                    },

                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSizeBadge(cage),
                          const SizedBox(height: 8),
                          Flexible(
                            child: CustomText.title(
                              CurrencyUtils.toPHP(cage.price),
                              size: AppTextSize.md,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: selectedCage?.id == cage.id
                                  ? AppFontWeight.black.value
                                  : AppFontWeight.normal.value,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Flexible(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pets_outlined,
                                  size: 14,
                                  color: scheme.onSurface.withAlpha(153),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: CustomText.body(
                                    '${cage.occupant}/${cage.max}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isFullyOccupied) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withAlpha(20),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Full',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSizeBadge(PetCage cage) {
    final color = _getSizeColor(cage.size);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        cage.size.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getSizeColor(String size) {
    final scheme = Theme.of(context).colorScheme;
    switch (size.toLowerCase()) {
      case 'small':
        return scheme.primary;
      case 'medium':
        return scheme.secondary;
      case 'large':
        return scheme.tertiary;
      default:
        return scheme.primary;
    }
  }

  Color _getOccupancyColor(double percentage) {
    if (percentage < 0.5) return Colors.green;
    if (percentage < 0.8) return Colors.orange;
    return Colors.red;
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }
}
