import 'package:flutter/cupertino.dart' as getx;
import 'package:get/get.dart' as getx;
import 'package:delivery_app/core/services/local/storage_service.dart';
import 'package:delivery_app/core/constants/storage_constants.dart';
import 'package:delivery_app/app/routes/app_routes.dart';

class RoleMiddleware extends getx.GetMiddleware {
  final List<String> allowedRoles;
  final String? redirectRoute;

  RoleMiddleware({required this.allowedRoles, this.redirectRoute});

  @override
  getx.RouteSettings? redirect(String? route) {
    final storageService = getx.Get.find<StorageService>();
    final userRole = storageService.readString(StorageConstants.userRole);
    final isLoggedIn = storageService.readBoolWithDefault(
      StorageConstants.isLoggedIn,
      false,
    );

    // If not logged in, redirect to login
    if (!isLoggedIn) {
      return const getx.RouteSettings(name: Routes.LOGIN);
    }

    // If user role is not allowed, redirect
    if (userRole == null || !allowedRoles.contains(userRole)) {
      // Show access denied message
      getx.Get.snackbar(
        'Access Denied',
        'You don\'t have permission to access this page',
        snackPosition: getx.SnackPosition.TOP,
      );

      // Redirect based on user role
      final redirectTo = redirectRoute ?? _getDefaultRouteForRole(userRole);
      return getx.RouteSettings(name: redirectTo);
    }

    return null; // Allow access
  }

  /// Get default route based on user role
  String _getDefaultRouteForRole(String? userRole) {
    switch (userRole) {
      case 'customer':
        return Routes.CUSTOMER_HOME;
      case 'driver':
        return Routes.DRIVER_HOME;
      case 'store':
        return Routes.STORE_DASHBOARD;
      case 'admin':
        return Routes.ADMIN_DASHBOARD;
      default:
        return Routes.LOGIN;
    }
  }
}

/// Middleware for customer-only routes
class CustomerOnlyMiddleware extends RoleMiddleware {
  CustomerOnlyMiddleware() : super(allowedRoles: ['customer']);
}

/// Middleware for driver-only routes
class DriverOnlyMiddleware extends RoleMiddleware {
  DriverOnlyMiddleware() : super(allowedRoles: ['driver']);
}

/// Middleware for store-only routes
class StoreOnlyMiddleware extends RoleMiddleware {
  StoreOnlyMiddleware() : super(allowedRoles: ['store']);
}

/// Middleware for admin-only routes
class AdminOnlyMiddleware extends RoleMiddleware {
  AdminOnlyMiddleware() : super(allowedRoles: ['admin']);
}

/// Middleware for authenticated users (any role)
class AuthMiddleware extends getx.GetMiddleware {
  @override
  getx.RouteSettings? redirect(String? route) {
    final storageService = getx.Get.find<StorageService>();
    final isLoggedIn = storageService.readBoolWithDefault(
      StorageConstants.isLoggedIn,
      false,
    );

    if (!isLoggedIn) {
      return const getx.RouteSettings(name: Routes.LOGIN);
    }

    return null;
  }
}

/// Middleware for guest users (not logged in)
class GuestMiddleware extends getx.GetMiddleware {
  @override
  getx.RouteSettings? redirect(String? route) {
    final storageService = getx.Get.find<StorageService>();
    final isLoggedIn = storageService.readBoolWithDefault(
      StorageConstants.isLoggedIn,
      false,
    );
    final userRole = storageService.readString(StorageConstants.userRole);

    if (isLoggedIn && userRole != null) {
      // Redirect to appropriate dashboard based on role
      switch (userRole) {
        case 'customer':
          return const getx.RouteSettings(name: Routes.CUSTOMER_HOME);
        case 'driver':
          return const getx.RouteSettings(name: Routes.DRIVER_HOME);
        case 'store':
          return const getx.RouteSettings(name: Routes.STORE_DASHBOARD);
        case 'admin':
          return const getx.RouteSettings(name: Routes.ADMIN_DASHBOARD);
        default:
          return const getx.RouteSettings(name: Routes.LOGIN);
      }
    }

    return null;
  }
}

/// Helper class for role-based access control
class RoleHelper {
  static final StorageService _storageService = getx.Get.find<StorageService>();

  /// Check if current user has any of the specified roles
  static bool hasAnyRole(List<String> roles) {
    final userRole = _storageService.readString(StorageConstants.userRole);
    return userRole != null && roles.contains(userRole);
  }

  /// Check if current user has specific role
  static bool hasRole(String role) {
    final userRole = _storageService.readString(StorageConstants.userRole);
    return userRole == role;
  }

  /// Get current user role
  static String? getCurrentRole() {
    return _storageService.readString(StorageConstants.userRole);
  }

  /// Check if user is logged in
  static bool isAuthenticated() {
    return _storageService.readBoolWithDefault(
      StorageConstants.isLoggedIn,
      false,
    );
  }

  /// Get appropriate home route for current user
  static String getHomeRoute() {
    final userRole = getCurrentRole();
    switch (userRole) {
      case 'customer':
        return Routes.CUSTOMER_HOME;
      case 'driver':
        return Routes.DRIVER_HOME;
      case 'store':
        return Routes.STORE_DASHBOARD;
      case 'admin':
        return Routes.ADMIN_DASHBOARD;
      default:
        return Routes.LOGIN;
    }
  }
}
