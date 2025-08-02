import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';

class ConfirmationDialog {
  static Future<bool?> show({
    required BuildContext context,
    String? title,
    String? message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    Color? cancelColor,
    IconData? icon,

    // callback
    void Function()? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsetsGeometry.all(30),
          title: title != null
              ? Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 24),
                      const SizedBox(width: 12),
                    ],
                    CustomText.body(title, size: AppTextSize.md),
                  ],
                )
              : null,
          content: message != null ? CustomText.body(message) : null,
          actions: [
            if (cancelText != "")
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: CustomText.caption(cancelText),
              ),

            TextButton(
              onPressed: () => onConfirm != null
                  ? onConfirm()
                  : Navigator.of(context).pop(true),
              child: CustomText.caption(
                confirmText,
                color: confirmColor,
                fontWeight: AppFontWeight.bold.value,
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showWithAction({
    required BuildContext context,
    required VoidCallback onConfirm,
    String? title,
    String? message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    Color? cancelColor,
    IconData? icon,
  }) async {
    final result = await show(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      confirmColor: confirmColor,
      cancelColor: cancelColor,
      icon: icon,
    );

    if (result == true) {
      onConfirm();
    }
  }
}
