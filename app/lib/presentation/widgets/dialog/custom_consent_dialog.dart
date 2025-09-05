import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ConfirmationDialogButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onConfirm;
  final String? dialogTitle;
  final String? dialogContent;
  final String? confirmText;
  final String? cancelText;
  final ButtonStyle? buttonStyle;
  final VoidCallback? onPressed;

  const ConfirmationDialogButton({
    super.key,
    required this.child,
    required this.onConfirm,
    this.dialogTitle,
    this.dialogContent,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.buttonStyle,
    this.onPressed,
  });

  // Default consent text from the Furcare Vet Clinic form
  static const String defaultConsentText = '''
By signing below, I consent to the grooming services provided by Furcare Vet Clinic. I understand that grooming involves handling my pet, and I authorize the staff to proceed with the requested services in case of an emergency, I consent to necessary veterinary care, at my expense.

At Furcare Vet Clinic, we prioritize your pet's well-being. While we take great care to ensure a pleasant grooming experience, grooming can sometimes uncover hidden health issues or worsen existing conditions. If needed, I authorize the Furcare immediate, veterinary treatment at my expense.

If I am not present, I give permission for Furcare Vet Clinic to use photos of my pet for promotional purposes. I confirm that my pet is up to date on Rabies, Distemper, and any required vaccinations.

I also acknowledge that I have informed the clinic of any pre-existing medical conditions my pet may have.''';

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dialogTitle ?? 'Service Consent Required'),
          content: SingleChildScrollView(
            child: Text(
              dialogContent ?? defaultConsentText,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText!,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(confirmText!),
            ),
          ],
        );
      },
    );

    // Only execute the callback if user confirmed
    if (confirmed == true) {
      onConfirm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showConfirmationDialog(context),
      child: child,
    );
  }
}

// Wrapper for your navigation function
class PetServiceNavigationHelper {
  static void handleNavigateToPetServicesWithConfirmation(
    BuildContext context,
    String code,
  ) {
    // Your original function wrapped with confirmation
    void originalNavigation() {
      // Add haptic feedback for better UX
      HapticFeedback.selectionClick();

      if (code == "PET_GROOMING") {
        context.push('/appointments/grooming');
      }
      if (code == "PET_BOARDING") {
        context.push('/appointments/boarding');
      }
      if (code == "HOME_SERVICE") {
        context.push('/appointments/home-service');
      }
      if (code == "PET_TRAINING") {
        context.push('/appointments/training');
      }
    }

    // Show confirmation dialog before navigation
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Service Consent Required'),
          content: const SingleChildScrollView(
            child: Text(
              ConfirmationDialogButton.defaultConsentText,
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                originalNavigation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('I Agree & Continue'),
            ),
          ],
        );
      },
    );
  }

  // Service-specific variations
  static void navigateToGroomingWithConsent(BuildContext context) {
    handleNavigateToPetServicesWithConfirmation(context, "PET_GROOMING");
  }

  static void navigateToBoardingWithConsent(BuildContext context) {
    handleNavigateToPetServicesWithConfirmation(context, "PET_BOARDING");
  }

  static void navigateToHomeServiceWithConsent(BuildContext context) {
    handleNavigateToPetServicesWithConfirmation(context, "HOME_SERVICE");
  }

  static void navigateToTrainingWithConsent(BuildContext context) {
    handleNavigateToPetServicesWithConfirmation(context, "PET_TRAINING");
  }
}
