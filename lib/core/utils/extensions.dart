// lib/core/utils/extensions.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String {
  // Capitalize first letter
  String get capitalizeFirst {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  // Capitalize each word
  String get capitalizeWords {
    return split(' ').map((word) => word.capitalizeFirst).join(' ');
  }

  // Check if string is email
  bool get isEmail {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(this);
  }

  // Check if string is phone number
  bool get isPhoneNumber {
    return RegExp(r'^[0-9]{10,15}$').hasMatch(replaceAll(RegExp(r'[^\d]'), ''));
  }

  // Check if string is numeric
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  // Remove special characters
  String get removeSpecialCharacters {
    return replaceAll(RegExp(r'[^\w\s]'), '');
  }

  // Get initials
  String get initials {
    List<String> names = trim().split(' ');
    if (names.length == 1) {
      return names[0].substring(0, 1).toUpperCase();
    }
    return '${names[0].substring(0, 1)}${names[1].substring(0, 1)}'
        .toUpperCase();
  }

  // Truncate text
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  // Parse to double
  double get toDouble {
    return double.tryParse(this) ?? 0.0;
  }

  // Parse to int
  int get toInt {
    return int.tryParse(this) ?? 0;
  }

  // Format as currency
  String get formatCurrency {
    final number = double.tryParse(this) ?? 0.0;
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(number);
  }
}

extension DateTimeExtensions on DateTime {
  // Format as relative time
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} tahun yang lalu';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} bulan yang lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  // Format date
  String get formatDate {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  // Format time
  String get formatTime {
    return DateFormat('HH:mm').format(this);
  }

  // Format date and time
  String get formatDateTime {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }

  // Check if today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Check if yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  // Get day name
  String get dayName {
    final days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[weekday - 1];
  }

  // Get month name
  String get monthName {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }
}

extension ColorExtensions on Color {
  // Get hex string
  String get toHex {
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  // Check if dark
  bool get isDark {
    return computeLuminance() < 0.5;
  }

  // Get contrast color
  Color get contrastColor {
    return isDark ? Colors.white : Colors.black;
  }

  // Lighten color
  Color lighten([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  // Darken color
  Color darken([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}

extension ListExtensions<T> on List<T> {
  // Get random element
  T get random {
    return this[(length * math.Random().nextDouble()).floor()];
  }

  // Check if not empty
  bool get isNotEmpty {
    return length > 0;
  }

  // Get first or null
  T? get firstOrNull {
    return isEmpty ? null : first;
  }

  // Get last or null
  T? get lastOrNull {
    return isEmpty ? null : last;
  }

  // Safe get element at index
  T? elementAtOrNull(int index) {
    return index >= 0 && index < length ? this[index] : null;
  }
}

extension NumExtensions on num {
  // Format as currency
  String get formatCurrency {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(this);
  }

  // Format with thousand separator
  String get formatNumber {
    return NumberFormat('#,###', 'id_ID').format(this);
  }

  // Check if between values
  bool isBetween(num from, num to) {
    return this >= from && this <= to;
  }
}
