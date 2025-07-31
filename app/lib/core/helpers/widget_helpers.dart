import 'package:flutter/material.dart';

IconData getServiceIcon(String serviceKey) {
  switch (serviceKey) {
    case 'PET_GROOMING':
      return Icons.content_cut;
    case 'PET_BOARDING':
      return Icons.home;
    case 'HOME_SERVICE':
      return Icons.local_shipping;
    case 'BRANCH_LOCATION':
      return Icons.location_on;
    case 'PET_TRAINING':
      return Icons.school;
    default:
      return Icons.pets;
  }
}

Color getStatusColor(String status, ColorScheme colorScheme) {
  switch (status) {
    case 'completed':
      return colorScheme.primary;
    case 'active':
      return const Color(0xFF4CAF50); // Green
    case 'pending':
      return const Color(0xFFFF9800); // Orange
    default:
      return colorScheme.onSurfaceVariant;
  }
}

IconData getSpecieIcon(String specie) {
  switch (specie.toLowerCase()) {
    case 'dog':
      return Icons.pets_rounded;
    case 'cat':
      return Icons.pets_outlined;
    case 'bird':
      return Icons.flutter_dash_outlined;
    case 'fish':
      return Icons.set_meal_outlined;
    case 'rabbit':
      return Icons.cruelty_free_outlined;
    default:
      return Icons.pets_rounded;
  }
}
