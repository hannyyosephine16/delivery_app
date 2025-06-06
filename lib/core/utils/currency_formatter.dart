// lib/core/utils/currency_formatter.dart
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static const String defaultCurrency = 'IDR';
  static const String defaultSymbol = 'Rp';
  static const String defaultLocale = 'id_ID';

  // Format currency
  static String formatCurrency(
    num amount, {
    String? symbol,
    String? locale,
    int decimalDigits = 0,
  }) {
    return NumberFormat.currency(
      locale: locale ?? defaultLocale,
      symbol: symbol ?? '$defaultSymbol ',
      decimalDigits: decimalDigits,
    ).format(amount);
  }

  // Format currency compact
  static String formatCurrencyCompact(num amount) {
    if (amount >= 1000000000) {
      return '$defaultSymbol ${(amount / 1000000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000000) {
      return '$defaultSymbol ${(amount / 1000000).toStringAsFixed(1)}Jt';
    } else if (amount >= 1000) {
      return '$defaultSymbol ${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return formatCurrency(amount);
    }
  }

  // Parse currency string
  static double parseCurrency(String currencyString) {
    final cleaned = currencyString
        .replaceAll(RegExp(r'[^\d,.]'), '')
        .replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  // Format number with thousand separator
  static String formatNumber(num number) {
    return NumberFormat('#,###', defaultLocale).format(number);
  }

  // Calculate percentage
  static String formatPercentage(double value, double total) {
    if (total == 0) return '0%';
    final percentage = (value / total) * 100;
    return '${percentage.toStringAsFixed(1)}%';
  }

  // Format discount
  static String formatDiscount(double discount) {
    return '-${formatCurrency(discount)}';
  }

  // Calculate service charge
  static double calculateServiceCharge(double subtotal, double rate) {
    return subtotal * rate;
  }

  // Calculate total with service charge
  static double calculateTotal(double subtotal, double serviceCharge) {
    return subtotal + serviceCharge;
  }

  // Format price range
  static String formatPriceRange(double minPrice, double maxPrice) {
    return '${formatCurrency(minPrice)} - ${formatCurrency(maxPrice)}';
  }
}
