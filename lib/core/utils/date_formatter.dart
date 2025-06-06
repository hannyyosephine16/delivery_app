// lib/core/utils/date_formatter.dart
import 'package:intl/intl.dart';

class DateFormatter {
  static const String defaultDateFormat = 'dd/MM/yyyy';
  static const String defaultTimeFormat = 'HH:mm';
  static const String defaultDateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Format date
  static String formatDate(DateTime date, {String? pattern}) {
    return DateFormat(pattern ?? defaultDateFormat).format(date);
  }

  // Format time
  static String formatTime(DateTime date, {String? pattern}) {
    return DateFormat(pattern ?? defaultTimeFormat).format(date);
  }

  // Format date and time
  static String formatDateTime(DateTime date, {String? pattern}) {
    return DateFormat(pattern ?? defaultDateTimeFormat).format(date);
  }

  // Format relative time
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

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

  // Parse date string
  static DateTime? parseDate(String dateString, {String? pattern}) {
    try {
      return DateFormat(pattern ?? defaultDateFormat).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Get day name
  static String getDayName(DateTime date) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[date.weekday - 1];
  }

  // Get month name
  static String getMonthName(DateTime date) {
    const months = [
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
    return months[date.month - 1];
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  // Format order date
  static String formatOrderDate(DateTime date) {
    if (isToday(date)) {
      return 'Hari ini, ${formatTime(date)}';
    } else if (isYesterday(date)) {
      return 'Kemarin, ${formatTime(date)}';
    } else {
      return formatDateTime(date);
    }
  }

  // Format delivery time
  static String formatDeliveryTime(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      return 'Terlambat ${formatRelativeTime(date)}';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lagi';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lagi';
    } else {
      return formatDateTime(date);
    }
  }

  // Get time of day greeting
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }
}
