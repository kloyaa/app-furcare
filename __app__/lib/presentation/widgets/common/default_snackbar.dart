import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message) {
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  } catch (e) {
    debugPrint('Failed to show snackbar: $e');
  }
}
