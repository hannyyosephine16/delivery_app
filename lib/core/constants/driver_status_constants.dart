import 'package:flutter/material.dart';
import 'package:delivery_app/app/themes/app_colors.dart';

class DriverStatusConstants {
  // Driver status values
  static const String active = 'active';
  static const String inactive = 'inactive';
  static const String busy = 'busy';
  static const String offline = 'offline';

  // Driver request status values
  static const String requestPending = 'pending';
  static const String requestAccepted = 'accepted';
  static const String requestRejected = 'rejected';
  static const String requestExpired = 'expired';
  static const String requestCompleted = 'completed';

  // Status lists
  static const List<String> allDriverStatuses = [
    active,
    inactive,
    busy,
    offline,
  ];

  static const List<String> allRequestStatuses = [
    requestPending,
    requestAccepted,
    requestRejected,
    requestExpired,
    requestCompleted,
  ];

  static const List<String> availableStatuses = [active];

  static const List<String> unavailableStatuses = [inactive, busy, offline];

  static const List<String> activeRequestStatuses = [
    requestPending,
    requestAccepted,
  ];

  static const List<String> completedRequestStatuses = [
    requestRejected,
    requestExpired,
    requestCompleted,
  ];

  // Status display names
  static const Map<String, String> driverStatusNames = {
    active: 'Aktif',
    inactive: 'Tidak Aktif',
    busy: 'Sibuk',
    offline: 'Offline',
  };

  static const Map<String, String> requestStatusNames = {
    requestPending: 'Menunggu Respons',
    requestAccepted: 'Diterima',
    requestRejected: 'Ditolak',
    requestExpired: 'Kedaluwarsa',
    requestCompleted: 'Selesai',
  };

  // Status descriptions
  static const Map<String, String> driverStatusDescriptions = {
    active: 'Driver siap menerima pesanan',
    inactive: 'Driver sedang tidak tersedia',
    busy: 'Driver sedang mengantarkan pesanan',
    offline: 'Driver sedang offline',
  };

  static const Map<String, String> requestStatusDescriptions = {
    requestPending: 'Permintaan pengantaran sedang menunggu respons driver',
    requestAccepted: 'Driver telah menerima permintaan pengantaran',
    requestRejected: 'Driver menolak permintaan pengantaran',
    requestExpired: 'Permintaan pengantaran telah kedaluwarsa',
    requestCompleted: 'Pengantaran telah selesai',
  };

  // Status colors
  static const Map<String, Color> driverStatusColors = {
    active: AppColors.driverActive,
    inactive: AppColors.driverInactive,
    busy: AppColors.driverBusy,
    offline: AppColors.textSecondary,
  };

  static const Map<String, Color> requestStatusColors = {
    requestPending: AppColors.orderPending,
    requestAccepted: AppColors.success,
    requestRejected: AppColors.error,
    requestExpired: AppColors.textSecondary,
    requestCompleted: AppColors.orderDelivered,
  };

  // Status icons
  static const Map<String, IconData> driverStatusIcons = {
    active: Icons.check_circle,
    inactive: Icons.cancel,
    busy: Icons.delivery_dining,
    offline: Icons.wifi_off,
  };

  static const Map<String, IconData> requestStatusIcons = {
    requestPending: Icons.access_time,
    requestAccepted: Icons.check_circle,
    requestRejected: Icons.cancel,
    requestExpired: Icons.schedule,
    requestCompleted: Icons.done_all,
  };

  // Status priority (for sorting)
  static const Map<String, int> driverStatusPriority = {
    active: 1,
    busy: 2,
    inactive: 3,
    offline: 4,
  };

  static const Map<String, int> requestStatusPriority = {
    requestPending: 1,
    requestAccepted: 2,
    requestCompleted: 3,
    requestRejected: 4,
    requestExpired: 5,
  };

  // Status transitions
  static const Map<String, List<String>> allowedDriverStatusTransitions = {
    inactive: [active],
    active: [inactive, busy],
    busy: [active, inactive],
    offline: [inactive],
  };

  static const Map<String, List<String>> allowedRequestStatusTransitions = {
    requestPending: [requestAccepted, requestRejected, requestExpired],
    requestAccepted: [requestCompleted],
    requestRejected: [],
    requestExpired: [],
    requestCompleted: [],
  };

  // Utility methods
  static String getDriverStatusName(String status) {
    return driverStatusNames[status] ?? status;
  }

  static String getRequestStatusName(String status) {
    return requestStatusNames[status] ?? status;
  }

  static String getDriverStatusDescription(String status) {
    return driverStatusDescriptions[status] ?? '';
  }

  static String getRequestStatusDescription(String status) {
    return requestStatusDescriptions[status] ?? '';
  }

  static Color getDriverStatusColor(String status) {
    return driverStatusColors[status] ?? AppColors.textSecondary;
  }

  static Color getRequestStatusColor(String status) {
    return requestStatusColors[status] ?? AppColors.textSecondary;
  }

  static IconData getDriverStatusIcon(String status) {
    return driverStatusIcons[status] ?? Icons.help_outline;
  }

  static IconData getRequestStatusIcon(String status) {
    return requestStatusIcons[status] ?? Icons.help_outline;
  }

  static bool isDriverAvailable(String status) {
    return availableStatuses.contains(status);
  }

  static bool isDriverUnavailable(String status) {
    return unavailableStatuses.contains(status);
  }

  static bool isRequestActive(String status) {
    return activeRequestStatuses.contains(status);
  }

  static bool isRequestCompleted(String status) {
    return completedRequestStatuses.contains(status);
  }

  static bool canAcceptOrders(String status) {
    return status == active;
  }

  static bool canRejectRequest(String status) {
    return status == requestPending;
  }

  static bool canAcceptRequest(String status) {
    return status == requestPending;
  }

  static bool canCompleteRequest(String status) {
    return status == requestAccepted;
  }

  static int getDriverStatusPriority(String status) {
    return driverStatusPriority[status] ?? 999;
  }

  static int getRequestStatusPriority(String status) {
    return requestStatusPriority[status] ?? 999;
  }

  static bool canTransitionDriverStatus(String from, String to) {
    return allowedDriverStatusTransitions[from]?.contains(to) ?? false;
  }

  static bool canTransitionRequestStatus(String from, String to) {
    return allowedRequestStatusTransitions[from]?.contains(to) ?? false;
  }

  static List<String> getAvailableDriverStatusTransitions(
    String currentStatus,
  ) {
    return allowedDriverStatusTransitions[currentStatus] ?? [];
  }

  static List<String> getAvailableRequestStatusTransitions(
    String currentStatus,
  ) {
    return allowedRequestStatusTransitions[currentStatus] ?? [];
  }

  static String getDefaultDriverStatus() {
    return inactive;
  }

  static String getDefaultRequestStatus() {
    return requestPending;
  }

  // Status-based behavior helpers
  static bool shouldShowLocationUpdate(String status) {
    return [active, busy].contains(status);
  }

  static bool shouldReceiveOrderRequests(String status) {
    return status == active;
  }

  static bool shouldShowDeliveryUI(String status) {
    return status == busy;
  }

  static Duration getStatusUpdateInterval(String status) {
    switch (status) {
      case active:
        return const Duration(seconds: 30);
      case busy:
        return const Duration(seconds: 15);
      default:
        return const Duration(minutes: 5);
    }
  }

  static Duration getRequestTimeout(String status) {
    switch (status) {
      case requestPending:
        return const Duration(minutes: 2);
      default:
        return const Duration(minutes: 5);
    }
  }
}
