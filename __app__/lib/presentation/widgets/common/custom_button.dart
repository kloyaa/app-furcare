import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/enums/text_enum.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final IconData? icon;
  final bool isOutlined;
  final EdgeInsetsGeometry? padding;
  final AppTextSize textSize;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 52,
    this.borderRadius = 12,
    this.icon,
    this.isOutlined = false,
    this.padding,
    this.textSize = AppTextSize.sm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBgColor = isOutlined
        ? Colors.transparent
        : theme.colorScheme.primary;
    final defaultTextColor = isOutlined
        ? theme.colorScheme.primary
        : theme.colorScheme.onPrimary;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: (isEnabled && !isLoading) ? onPressed : null,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: backgroundColor ?? theme.colorScheme.primary,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: _buildButtonContent(context, defaultTextColor),
            )
          : ElevatedButton(
              onPressed: (isEnabled && !isLoading) ? onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? defaultBgColor,
                foregroundColor: textColor ?? defaultTextColor,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
                disabledBackgroundColor: theme.colorScheme.onSurface
                    // ignore: deprecated_member_use
                    .withOpacity(0.12),
                disabledForegroundColor: theme.colorScheme.onSurface
                    // ignore: deprecated_member_use
                    .withOpacity(0.38),
              ),
              child: _buildButtonContent(
                context,
                textColor ?? defaultTextColor,
              ),
            ),
    );
  }

  Widget _buildButtonContent(BuildContext context, Color textColor) {
    final theme = Theme.of(context);

    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: isOutlined
              ? theme.colorScheme.primary
              : theme.colorScheme.onPrimary,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: textColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: textSize.size,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: textSize.size,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }
}
