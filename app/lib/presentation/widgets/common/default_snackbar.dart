import 'package:flutter/material.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final theme = Theme.of(context).colorScheme;
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError
            ? theme.errorContainer
            : theme.primaryContainer,
        content: CustomText.body(
          message,
          color: isError ? theme.error : theme.onPrimaryContainer,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}
