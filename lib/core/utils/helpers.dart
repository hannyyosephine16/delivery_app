// lib/core/utils/helpers.dart - Fixed Timer import
import 'dart:async'; // Added missing import
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  // Generate random string
  static String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  // Generate order code
  static String generateOrderCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = Random().nextInt(999).toString().padLeft(3, '0');
    return 'ORD-$timestamp-$random';
  }

  // Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Calculate percentage
  static double calculatePercentage(double value, double total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  // Get initials from name
  static String getInitials(String name) {
    List<String> names = name.trim().split(' ');
    if (names.length == 1) {
      return names[0].substring(0, 1).toUpperCase();
    }
    return '${names[0].substring(0, 1)}${names[1].substring(0, 1)}'
        .toUpperCase();
  }

  // Capitalize first letter
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Capitalize each word
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalizeFirst(word)).join(' ');
  }

  // Truncate text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Remove special characters
  static String removeSpecialCharacters(String text) {
    return text.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  // Get color from string
  static Color getColorFromString(String text) {
    final hash = text.hashCode;
    return Color((hash & 0xFFFFFF) | 0xFF000000);
  }

  // Check if dark color
  static bool isDarkColor(Color color) {
    return color.computeLuminance() < 0.5;
  }

  // Get contrast color
  static Color getContrastColor(Color color) {
    return isDarkColor(color) ? Colors.white : Colors.black;
  }

  // Generate QR code data
  static String generateQRCodeData(String orderId) {
    return 'ORDER:$orderId';
  }

  // Parse QR code data
  static String? parseQRCodeData(String data) {
    if (data.startsWith('ORDER:')) {
      return data.substring(6);
    }
    return null;
  }

  // Check if string is numeric
  static bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  // Get age from date of birth
  static int getAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Generate unique ID
  static String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(999999).toString();
  }

  // Check if email is valid (simple check)
  static bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // Check if phone number is valid
  static bool isValidPhone(String phone) {
    return RegExp(
      r'^[0-9]{10,15}$',
    ).hasMatch(phone.replaceAll(RegExp(r'[^\d]'), ''));
  }

  // Format phone number
  static String formatPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length >= 10) {
      return '+${cleaned.substring(0, 2)} ${cleaned.substring(2, 6)} ${cleaned.substring(6)}';
    }
    return phone;
  }

  // Get file extension
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  // Check if file is image
  static bool isImageFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  // Generate color palette
  static List<Color> generateColorPalette(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);
    return [
      hsl.withLightness(0.9).toColor(),
      hsl.withLightness(0.7).toColor(),
      hsl.withLightness(0.5).toColor(),
      hsl.withLightness(0.3).toColor(),
      hsl.withLightness(0.1).toColor(),
    ];
  }

  // Debounce function
  static Timer? _debounceTimer;
  static void debounce(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }
}
