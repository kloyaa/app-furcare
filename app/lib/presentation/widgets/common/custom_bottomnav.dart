import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/theme.dart';

// Bottom Navigation Item Model
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final Widget screen;

  BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.screen,
  });
}

// Custom Bottom Navigation Bar Widget
class CustomBottomNavBar extends StatelessWidget {
  final List<BottomNavItem> items;
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ThemeHelper.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
        color:
            theme.bottomNavigationBarTheme.backgroundColor ??
            (isDark ? Colors.grey[900] : Colors.white),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: isDark ? Colors.black26 : Colors.grey.withAlpha(51),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return GestureDetector(
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        // ignore: deprecated_member_use
                        ? theme.primaryColor.withAlpha(26)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isSelected
                              ? (item.activeIcon ?? item.icon)
                              : item.icon,
                          key: ValueKey(isSelected),
                          color: isSelected
                              // ignore: deprecated_member_use
                              ? theme.colorScheme.primary.withAlpha(255)
                              // ignore: deprecated_member_use
                              : theme.colorScheme.primary.withAlpha(128),
                          size: 24,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isSelected ? 1.0 : 0.0,
                          child: Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected
                                  // ignore: deprecated_member_use
                                  ? theme.colorScheme.primary.withAlpha(255)
                                  // ignore: deprecated_member_use
                                  : theme.colorScheme.primary.withAlpha(128),
                              fontWeight: AppFontWeight.bold.value,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
