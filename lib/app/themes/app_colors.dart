import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryDark = Color(0xFFE55A2B);
  static const Color primaryLight = Color(0xFFFF8A65);

  // Secondary colors
  static const Color secondary = Color(0xFF2E7D32);
  static const Color secondaryDark = Color(0xFF1B5E20);
  static const Color secondaryLight = Color(0xFF4CAF50);

  // Accent colors
  static const Color accent = Color(0xFFFFC107);
  static const Color accentDark = Color(0xFFF57F17);
  static const Color accentLight = Color(0xFFFFD54F);

  // Background colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Order status colors
  static const Color orderPending = Color(0xFFFF9800);
  static const Color orderApproved = Color(0xFF2196F3);
  static const Color orderPreparing = Color(0xFFFF5722);
  static const Color orderOnDelivery = Color(0xFF9C27B0);
  static const Color orderDelivered = Color(0xFF4CAF50);
  static const Color orderCancelled = Color(0xFFF44336);

  // Driver status colors
  static const Color driverActive = Color(0xFF4CAF50);
  static const Color driverInactive = Color(0xFF9E9E9E);
  static const Color driverBusy = Color(0xFFFF9800);

  // Store status colors
  static const Color storeOpen = Color(0xFF4CAF50);
  static const Color storeClosed = Color(0xFFF44336);
  static const Color storeBusy = Color(0xFFFF9800);

  // Rating colors
  static const Color rating = Color(0xFFFFD700);
  static const Color ratingStar = Color(0xFFFFC107);
  static const Color ratingEmpty = Color(0xFFE0E0E0);

  // Border colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);
  static const Color borderLight = Color(0xFFF5F5F5);

  // Shadow colors
  static const Color shadow = Color(0x1F000000);
  static const Color shadowLight = Color(0x0F000000);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Transparency variations
  static Color primaryWithOpacity(double opacity) =>
      primary.withOpacity(opacity);
  static Color secondaryWithOpacity(double opacity) =>
      secondary.withOpacity(opacity);
  static Color accentWithOpacity(double opacity) => accent.withOpacity(opacity);
  static Color textPrimaryWithOpacity(double opacity) =>
      textPrimary.withOpacity(opacity);
  static Color textSecondaryWithOpacity(double opacity) =>
      textSecondary.withOpacity(opacity);

  // Utility method to get order status color
  static Color getOrderStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return orderPending;
      case 'approved':
        return orderApproved;
      case 'preparing':
        return orderPreparing;
      case 'on_delivery':
        return orderOnDelivery;
      case 'delivered':
        return orderDelivered;
      case 'cancelled':
        return orderCancelled;
      default:
        return textSecondary;
    }
  }

  // Utility method to get driver status color
  static Color getDriverStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return driverActive;
      case 'inactive':
        return driverInactive;
      case 'busy':
        return driverBusy;
      default:
        return textSecondary;
    }
  }
}
