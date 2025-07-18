import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/tabs/widgets/appointments/shimmer.dart';

class CompanionSelectionSkeleton extends StatelessWidget {
  const CompanionSelectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ShimmerEffect(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header skeleton
              Row(
                children: [
                  // Pet icon skeleton
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title skeleton
                        Container(
                          width: 95,
                          height: 24,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Subtitle skeleton
                        Container(
                          width: 100,
                          height: 14,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrow button skeleton
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroomingScheduleSkeleton extends StatelessWidget {
  const GroomingScheduleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(5, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 100 * index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Schedule time skeleton
                  Container(
                    width: 118, // Varying widths for realism
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.onSurface.withOpacity(0.1),
                          theme.colorScheme.onSurface.withOpacity(0.05),
                          theme.colorScheme.onSurface.withOpacity(0.1),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Price skeleton
                  Container(
                    width: 35, // Varying widths for realism
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.onSurface.withOpacity(0.08),
                          theme.colorScheme.onSurface.withOpacity(0.04),
                          theme.colorScheme.onSurface.withOpacity(0.08),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class GroomingOptionsSkeleton extends StatelessWidget {
  const GroomingOptionsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      child: Column(
        children: List.generate(5, (index) {
          // Add slight delays to create a wave effect
          return AnimatedContainer(
            duration: Duration(milliseconds: 100 * index),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
              child: Row(
                children: [
                  // Content section
                  Expanded(
                    flex: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title skeleton
                        Container(
                          width:
                              120 +
                              (index % 3) * 20, // Varying widths for realism
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.onSurface.withOpacity(0.1),
                                theme.colorScheme.onSurface.withOpacity(0.05),
                                theme.colorScheme.onSurface.withOpacity(0.1),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Subtitle (price) skeleton
                        Container(
                          width:
                              70 +
                              (index % 2) * 10, // Varying widths for realism
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.onSurface.withOpacity(0.08),
                                theme.colorScheme.onSurface.withOpacity(0.04),
                                theme.colorScheme.onSurface.withOpacity(0.08),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Spacer(),
                  Container(
                    width: 21,
                    height: 21,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.onSurface.withOpacity(0.08),
                          theme.colorScheme.onSurface.withOpacity(0.04),
                          theme.colorScheme.onSurface.withOpacity(0.08),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class GroomingPreferencesSkeleton extends GroomingOptionsSkeleton {
  const GroomingPreferencesSkeleton({super.key});
}
