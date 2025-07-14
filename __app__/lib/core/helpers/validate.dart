import 'package:intl/intl.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'Username is required';
  }
  if (value.length < 3) {
    return 'Username must be at least 3 characters long';
  }
  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
    return 'Username can only contain letters, numbers, and underscores';
  }
  return null;
}

String? validateConfirmPassword(String? value, String? password) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  }
  if (value != password) {
    return 'Passwords do not match';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }
  // Philippine phone number validation
  final phoneRegex = RegExp(r'^(09|\+639)\d{9}$');
  if (!phoneRegex.hasMatch(value.replaceAll(' ', '').replaceAll('-', ''))) {
    return 'Please enter a valid Philippine phone number';
  }
  return null;
}

String? validateFullName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Full name is required';
  }
  if (value.trim().length < 2) {
    return 'Full name must be at least 2 characters';
  }
  return null;
}

String? validateAddress(String? value) {
  if (value == null || value.isEmpty) {
    return 'Address is required';
  }
  if (value.trim().length < 10) {
    return 'Please enter a complete address';
  }
  return null;
}

String? validateFacebookUrl(String? value) {
  if (value != null && value.isNotEmpty) {
    final facebookRegex = RegExp(
      r'^https?://(www\.)?facebook\.com/[a-zA-Z0-9.]+$',
    );
    if (!facebookRegex.hasMatch(value)) {
      return 'Please enter a valid Facebook URL';
    }
  }
  return null;
}

String? validateMessengerUrl(String? value) {
  if (value != null && value.isNotEmpty) {
    final messengerRegex = RegExp(r'^https?://m\.me/[a-zA-Z0-9.]+$');
    if (!messengerRegex.hasMatch(value)) {
      return 'Please enter a valid Messenger URL';
    }
  }
  return null;
}

bool isValidDate(String input, {String format = 'yyyy-MM-dd'}) {
  try {
    DateFormat(format).parseStrict(input);
    return true;
  } catch (_) {
    return false;
  }
}
