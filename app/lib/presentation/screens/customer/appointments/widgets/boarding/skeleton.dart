import 'package:flutter/material.dart';

class BoardingApplicationsSkeleton extends StatefulWidget {
  const BoardingApplicationsSkeleton({super.key});

  @override
  State<BoardingApplicationsSkeleton> createState() =>
      _BoardingApplicationsSkeletonState();
}

class _BoardingApplicationsSkeletonState
    extends State<BoardingApplicationsSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.only(
                bottom: 17,
                top: 23,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(77),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline.withAlpha(26)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet info row
                  Row(
                    children: [
                      _shimmerBox(36, 36, 8, colorScheme),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _shimmerBox(120, 18, 4, colorScheme),
                            const SizedBox(height: 4),
                            _shimmerBox(80, 14, 4, colorScheme),
                          ],
                        ),
                      ),
                      _shimmerBox(60, 20, 12, colorScheme),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Boarding specific details (cage size + days)
                  Row(
                    children: [
                      _shimmerBox(16, 16, 2, colorScheme),
                      const SizedBox(width: 4),
                      _shimmerBox(70, 14, 4, colorScheme),
                      const SizedBox(width: 16),
                      _shimmerBox(16, 16, 2, colorScheme),
                      const SizedBox(width: 4),
                      _shimmerBox(50, 14, 4, colorScheme),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Date/time row
                  Row(
                    children: [
                      _shimmerBox(16, 16, 2, colorScheme),
                      const SizedBox(width: 4),
                      _shimmerBox(140, 14, 4, colorScheme),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Branch location row
                  Row(
                    children: [
                      _shimmerBox(16, 16, 2, colorScheme),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _shimmerBox(double.infinity, 14, 4, colorScheme),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Price and arrow row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _shimmerBox(80, 16, 4, colorScheme),
                      _shimmerBox(16, 16, 2, colorScheme),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _shimmerBox(
    double width,
    double height,
    double borderRadius,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [
            (_shimmerAnimation.value - 1).clamp(0.0, 1.0),
            _shimmerAnimation.value.clamp(0.0, 1.0),
            (_shimmerAnimation.value + 1).clamp(0.0, 1.0),
          ],
          colors: [
            colorScheme.onSurface.withAlpha(20),
            colorScheme.onSurface.withAlpha(38),
            colorScheme.onSurface.withAlpha(20),
          ],
        ),
      ),
    );
  }
}
