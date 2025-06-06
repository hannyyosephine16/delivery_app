import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:delivery_app/core/services/local/storage_service.dart';
import 'package:delivery_app/core/constants/storage_constants.dart';
import 'package:delivery_app/app/routes/app_routes.dart';

class AuthMiddleware {
  static final StorageService _storageService = getx.Get.find<StorageService>();

  /// Middleware untuk menambahkan token ke setiap request
  static InterceptorsWrapper getAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Tambahkan auth token ke header
        final token = _storageService.readString(StorageConstants.authToken);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        // Tambahkan common headers
        options.headers['Accept'] = 'application/json';
        options.headers['Content-Type'] = 'application/json';

        handler.next(options);
      },

      onResponse: (response, handler) {
        // Handle successful responses
        handler.next(response);
      },

      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await _handleUnauthorized();
        } else if (error.response?.statusCode == 403) {
          _handleForbidden();
        }
        handler.next(error);
      },
    );
  }

  /// Handle unauthorized access (401)
  static Future<void> _handleUnauthorized() async {
    // Clear auth data
    await _clearAuthData();

    // Navigate to login if not already there
    final currentRoute = getx.Get.currentRoute;
    if (currentRoute != Routes.LOGIN &&
        currentRoute != Routes.REGISTER &&
        currentRoute != Routes.SPLASH) {
      getx.Get.offAllNamed(Routes.LOGIN);

      getx.Get.snackbar(
        'Session Expired',
        'Please login again to continue',
        snackPosition: getx.SnackPosition.TOP,
      );
    }
  }

  /// Handle forbidden access (403)
  static void _handleForbidden() {
    getx.Get.snackbar(
      'Access Denied',
      'You don\'t have permission to perform this action',
      snackPosition: getx.SnackPosition.TOP,
    );
  }

  /// Clear all authentication data
  static Future<void> _clearAuthData() async {
    final keys = [
      StorageConstants.authToken,
      StorageConstants.refreshToken,
      StorageConstants.userId,
      StorageConstants.userRole,
      StorageConstants.userEmail,
      StorageConstants.userName,
      StorageConstants.userPhone,
      StorageConstants.userAvatar,
      StorageConstants.lastLoginTime,
    ];

    for (final key in keys) {
      await _storageService.remove(key);
    }

    await _storageService.writeBool(StorageConstants.isLoggedIn, false);
  }

  /// Check if user is authenticated
  static bool isAuthenticated() {
    final token = _storageService.readString(StorageConstants.authToken);
    return token != null && token.isNotEmpty;
  }

  /// Get current user role
  static String? getCurrentUserRole() {
    return _storageService.readString(StorageConstants.userRole);
  }

  /// Check if user has specific role
  static bool hasRole(String role) {
    final userRole = getCurrentUserRole();
    return userRole == role;
  }

  /// Check if user is customer
  static bool isCustomer() {
    return hasRole('customer');
  }

  /// Check if user is driver
  static bool isDriver() {
    return hasRole('driver');
  }

  /// Check if user is store owner
  static bool isStore() {
    return hasRole('store');
  }

  /// Check if user is admin
  static bool isAdmin() {
    return hasRole('admin');
  }
}
