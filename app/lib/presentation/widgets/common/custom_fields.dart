import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/theme.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool withSuffixIcon;
  final VoidCallback? onSuffixIconTap;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final int maxLines;
  final bool error; // New error parameter
  final String? errorText; // Optional error message
  final Function(String)? onChanged; // Optional onChange callback
  final bool isRequired;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.isRequired,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.withSuffixIcon = false,
    this.onSuffixIconTap,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.error = false, // Default to false
    this.errorText,
    this.onChanged, // Optional onChange parameter
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ThemeHelper.isDarkMode(context);
    final hasError = widget.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          onChanged: widget.onChanged, // Add onChange callback
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
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: hasError
                        ? theme.colorScheme.error.withAlpha(204)
                        : theme.colorScheme.onSurface.withAlpha(153),
                    size: 20,
                  )
                : null,
            suffixIcon: widget.isPassword && widget.withSuffixIcon
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: hasError
                          ? theme.colorScheme.error.withAlpha(204)
                          : theme.colorScheme.onSurface.withAlpha(153),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : (widget.suffixIcon != null
                      ? IconButton(
                          icon: Icon(
                            widget.suffixIcon,
                            color: hasError
                                ? theme.colorScheme.error.withAlpha(204)
                                : theme.colorScheme.onSurface.withAlpha(153),
                            size: 20,
                          ),
                          onPressed: widget.onSuffixIconTap,
                        )
                      : null),
            errorText: hasError ? widget.errorText : null,
            errorMaxLines: 3, // Allow error text to wrap up to 3 lines
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
        ),
      ],
    );
  }
}
