import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/theme.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';

class CustomSelectField<T> extends StatefulWidget {
  final String label;
  final String hintText;
  final List<T> options;
  final T? selectedValue;
  final Function(T?) onChanged;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String Function(T)?
  displayText; // Custom display text for complex objects
  final String? Function(T?)? validator;
  final bool enabled;
  final bool error;
  final String? errorText;
  final bool? isRequired;
  final double? maxHeight; // Maximum height for dropdown
  final EdgeInsets? margin; // Margin around the field
  final double? width; // Custom width (if null, uses responsive width)
  final int?
  screenColumns; // Number of columns for responsive design (optional)

  const CustomSelectField({
    super.key,
    required this.label,
    required this.hintText,
    required this.options,
    required this.onChanged,
    this.selectedValue,
    this.prefixIcon,
    this.suffixIcon,
    this.displayText,
    this.validator,
    this.enabled = true,
    this.error = false,
    this.errorText,
    this.isRequired,
    this.maxHeight = 500,
    this.margin,
    this.width,
    this.screenColumns,
  });

  @override
  State<CustomSelectField<T>> createState() => _CustomSelectFieldState<T>();
}

class _CustomSelectFieldState<T> extends State<CustomSelectField<T>> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ThemeHelper.isDarkMode(context);
    final hasError = widget.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with optional asterisk
        Row(
          children: [
            CustomText.subtitle(
              widget.label,
              size: AppTextSize.xs,
              fontWeight: AppFontWeight.normal.value,
              color: hasError
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface,
            ),
            if (widget.isRequired == true) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: AppTextSize.xs.size,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        // Dropdown Field
        DropdownButtonFormField<T>(
          value: widget.selectedValue,
          onChanged: widget.enabled ? widget.onChanged : null,
          validator: widget.validator,
          items: widget.options.map((T option) {
            return DropdownMenuItem<T>(
              value: option,
              child: Text(
                widget.displayText != null
                    ? widget.displayText!(option)
                    : option.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            );
          }).toList(),
          style: TextStyle(
            fontSize: 16,
            color: hasError
                ? theme.colorScheme.error
                : theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: hasError
                  ? theme.colorScheme.error.withAlpha(179)
                  : theme.colorScheme.onSurface.withAlpha(128),
              fontSize: AppTextSize.sm.size,
            ),
            errorText: hasError ? widget.errorText : null,
            errorMaxLines: 3,
            filled: true,
            fillColor: hasError
                ? theme.colorScheme.errorContainer.withAlpha(26)
                : (isDark
                      ? theme.colorScheme.surface
                      : theme.colorScheme.surfaceContainerHighest.withAlpha(
                          77,
                        )),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.outline,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.outline,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          dropdownColor: theme.colorScheme.primaryContainer,
          menuMaxHeight: widget.maxHeight,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  }
}
