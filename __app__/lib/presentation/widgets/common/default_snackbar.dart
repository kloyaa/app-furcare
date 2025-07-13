import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_text.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final theme = Theme.of(context).colorScheme;
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? theme.errorContainer : theme.surface,
        content: CustomText.body(
          message,
          color: isError ? theme.error : theme.surfaceBright,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  } catch (e) {
    debugPrint('Failed to show snackbar: $e');
  }
}
