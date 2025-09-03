import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/presentation/widgets/common/theme_toggle_button.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool showThemeToggle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;
  final TextStyle? titleTextStyle;
  final PreferredSizeWidget? bottom;
  final double toolbarHeight;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.showThemeToggle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = true,
    this.titleTextStyle,
    this.bottom,
    this.toolbarHeight = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Combine custom actions with theme toggle if needed
    List<Widget> finalActions = [];

    if (actions != null) {
      finalActions.addAll(actions!);
    }

    if (showThemeToggle) {
      finalActions.add(const ThemeToggleButton());
    }

    return AppBar(
      title: Text(title ?? ''),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: finalActions.isNotEmpty ? finalActions : null,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      foregroundColor:
          foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
      elevation: elevation,
      centerTitle: centerTitle,
      titleTextStyle: titleTextStyle ?? const TextStyle(fontSize: 12),
      bottom: bottom,
      toolbarHeight: toolbarHeight,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}

class CustomListAppBar extends CustomAppBar {
  const CustomListAppBar({super.key, required String title})
    : super(title: title, showThemeToggle: false);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(Icons.close, color: colorScheme.primary),
      ),
      title: Text(
        title ?? '',
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 14,
          fontWeight: AppFontWeight.semibold.value,
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: colorScheme.surface,
      centerTitle: true,
      toolbarHeight: toolbarHeight,
    );
  }
}
