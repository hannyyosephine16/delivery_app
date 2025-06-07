import 'package:flutter/material.dart';
import 'package:del_pick/app/themes/app_colors.dart';

class StoreStatusConstants {
  // Store status values
  static const String active = 'active';
  static const String inactive = 'inactive';
  static const String closed = 'closed';
  static const String maintenance = 'maintenance';
  static const String suspended = 'suspended';

  // Menu item availability status
  static const String available = 'available';
  static const String unavailable = 'unavailable';
  static const String outOfStock = 'out_of_stock';

  // Store operational status
  static const String open = 'open';
  static const String closedTemporarily = 'closed_temporarily';
  static const String busy = 'busy';

  // Status lists
  static const List<String> allStoreStatuses = [
    active,
    inactive,
    closed,
    maintenance,
    suspended,
  ];

  static const List<String> allMenuItemStatuses = [
    available,
    unavailable,
    outOfStock,
  ];

  static const List<String> allOperationalStatuses = [
    open,
    closedTemporarily,
    busy,
  ];

  static const List<String> operationalStatuses = [active, open, busy];

  static const List<String> nonOperationalStatuses = [
    inactive,
    closed,
    maintenance,
    suspended,
    closedTemporarily,
  ];

  static const List<String> availableMenuStatuses = [available];

  static const List<String> unavailableMenuStatuses = [unavailable, outOfStock];

  // Status display names
  static const Map<String, String> storeStatusNames = {
    active: 'Aktif',
    inactive: 'Tidak Aktif',
    closed: 'Tutup',
    maintenance: 'Maintenance',
    suspended: 'Ditangguhkan',
  };

  static const Map<String, String> menuItemStatusNames = {
    available: 'Tersedia',
    unavailable: 'Tidak Tersedia',
    outOfStock: 'Habis',
  };

  static const Map<String, String> operationalStatusNames = {
    open: 'Buka',
    closedTemporarily: 'Tutup Sementara',
    busy: 'Sibuk',
  };

  // Status descriptions
  static const Map<String, String> storeStatusDescriptions = {
    active: 'Toko aktif dan dapat menerima pesanan',
    inactive: 'Toko sedang tidak aktif',
    closed: 'Toko tutup dan tidak menerima pesanan',
    maintenance: 'Toko sedang dalam maintenance',
    suspended: 'Toko ditangguhkan oleh admin',
  };

  static const Map<String, String> menuItemStatusDescriptions = {
    available: 'Menu tersedia untuk dipesan',
    unavailable: 'Menu sedang tidak tersedia',
    outOfStock: 'Menu habis, tidak bisa dipesan',
  };

  static const Map<String, String> operationalStatusDescriptions = {
    open: 'Toko sedang buka dan menerima pesanan',
    closedTemporarily: 'Toko tutup sementara',
    busy: 'Toko sedang sibuk, pesanan mungkin tertunda',
  };

  // Status colors
  static const Map<String, Color> storeStatusColors = {
    active: AppColors.storeOpen,
    inactive: AppColors.storeClosed,
    closed: AppColors.storeClosed,
    maintenance: AppColors.storeBusy,
    suspended: AppColors.error,
  };

  static const Map<String, Color> menuItemStatusColors = {
    available: AppColors.success,
    unavailable: AppColors.warning,
    outOfStock: AppColors.error,
  };

  static const Map<String, Color> operationalStatusColors = {
    open: AppColors.storeOpen,
    closedTemporarily: AppColors.storeClosed,
    busy: AppColors.storeBusy,
  };

  // Status icons
  static const Map<String, IconData> storeStatusIcons = {
    active: Icons.store,
    inactive: Icons.store_mall_directory_outlined,
    closed: Icons.lock,
    maintenance: Icons.build,
    suspended: Icons.block,
  };

  static const Map<String, IconData> menuItemStatusIcons = {
    available: Icons.check_circle,
    unavailable: Icons.remove_circle,
    outOfStock: Icons.cancel,
  };

  static const Map<String, IconData> operationalStatusIcons = {
    open: Icons.lock_open,
    closedTemporarily: Icons.lock_clock,
    busy: Icons.hourglass_top,
  };

  // Status priority (for sorting)
  static const Map<String, int> storeStatusPriority = {
    active: 1,
    busy: 2,
    inactive: 3,
    maintenance: 4,
    closed: 5,
    suspended: 6,
  };

  static const Map<String, int> menuItemStatusPriority = {
    available: 1,
    unavailable: 2,
    outOfStock: 3,
  };

  // Business hours helpers
  static bool isStoreOpenByTime(String openTime, String closeTime) {
    final now = DateTime.now();
    final currentTime = TimeOfDay.now();

    // Parse open and close times
    final openTimeParts = openTime.split(':');
    final closeTimeParts = closeTime.split(':');

    final openTimeOfDay = TimeOfDay(
      hour: int.parse(openTimeParts[0]),
      minute: int.parse(openTimeParts[1]),
    );

    final closeTimeOfDay = TimeOfDay(
      hour: int.parse(closeTimeParts[0]),
      minute: int.parse(closeTimeParts[1]),
    );

    // Convert to minutes for easier comparison
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final openMinutes = openTimeOfDay.hour * 60 + openTimeOfDay.minute;
    final closeMinutes = closeTimeOfDay.hour * 60 + closeTimeOfDay.minute;

    // Handle cases where store closes after midnight
    if (closeMinutes < openMinutes) {
      return currentMinutes >= openMinutes || currentMinutes <= closeMinutes;
    } else {
      return currentMinutes >= openMinutes && currentMinutes <= closeMinutes;
    }
  }

  // Utility methods
  static String getStoreStatusName(String status) {
    return storeStatusNames[status] ?? status;
  }

  static String getMenuItemStatusName(String status) {
    return menuItemStatusNames[status] ?? status;
  }

  static String getOperationalStatusName(String status) {
    return operationalStatusNames[status] ?? status;
  }

  static String getStoreStatusDescription(String status) {
    return storeStatusDescriptions[status] ?? '';
  }

  static String getMenuItemStatusDescription(String status) {
    return menuItemStatusDescriptions[status] ?? '';
  }

  static String getOperationalStatusDescription(String status) {
    return operationalStatusDescriptions[status] ?? '';
  }

  static Color getStoreStatusColor(String status) {
    return storeStatusColors[status] ?? AppColors.textSecondary;
  }

  static Color getMenuItemStatusColor(String status) {
    return menuItemStatusColors[status] ?? AppColors.textSecondary;
  }

  static Color getOperationalStatusColor(String status) {
    return operationalStatusColors[status] ?? AppColors.textSecondary;
  }

  static IconData getStoreStatusIcon(String status) {
    return storeStatusIcons[status] ?? Icons.help_outline;
  }

  static IconData getMenuItemStatusIcon(String status) {
    return menuItemStatusIcons[status] ?? Icons.help_outline;
  }

  static IconData getOperationalStatusIcon(String status) {
    return operationalStatusIcons[status] ?? Icons.help_outline;
  }

  static bool isStoreOperational(String status) {
    return operationalStatuses.contains(status);
  }

  static bool isStoreNonOperational(String status) {
    return nonOperationalStatuses.contains(status);
  }

  static bool canAcceptOrders(String status) {
    return [active, open].contains(status);
  }

  static bool isMenuItemAvailable(String status) {
    return availableMenuStatuses.contains(status);
  }

  static bool isMenuItemUnavailable(String status) {
    return unavailableMenuStatuses.contains(status);
  }

  static bool canOrderMenuItem(String status) {
    return status == available;
  }

  static int getStoreStatusPriority(String status) {
    return storeStatusPriority[status] ?? 999;
  }

  static int getMenuItemStatusPriority(String status) {
    return menuItemStatusPriority[status] ?? 999;
  }

  static String getDefaultStoreStatus() {
    return inactive;
  }

  static String getDefaultMenuItemStatus() {
    return available;
  }

  static String getDefaultOperationalStatus() {
    return open;
  }

  // Status-based behavior helpers
  static bool shouldShowInSearch(String status) {
    return [active, open, busy].contains(status);
  }

  static bool shouldAcceptNewOrders(String status) {
    return status == active || status == open;
  }

  static bool shouldShowClosedMessage(String status) {
    return [inactive, closed, closedTemporarily].contains(status);
  }

  static bool shouldShowMaintenanceMessage(String status) {
    return status == maintenance;
  }

  static bool shouldShowSuspendedMessage(String status) {
    return status == suspended;
  }

  static Duration getStatusUpdateInterval(String status) {
    switch (status) {
      case active:
      case open:
        return const Duration(minutes: 1);
      case busy:
        return const Duration(seconds: 30);
      default:
        return const Duration(minutes: 5);
    }
  }

  static String getStoreStatusBasedOnTime(String openTime, String closeTime) {
    if (isStoreOpenByTime(openTime, closeTime)) {
      return open;
    } else {
      return closedTemporarily;
    }
  }
}
