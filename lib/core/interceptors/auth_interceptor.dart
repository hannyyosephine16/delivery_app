// lib/core/interceptors/auth_interceptor.dart

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:del_pick/core/services/local/storage_service.dart';
import 'package:del_pick/core/constants/storage_constants.dart';
import 'package:del_pick/app/routes/app_routes.dart';

class AuthInterceptor extends Interceptor {
  final StorageService _storageService;

  AuthInterceptor(this._storageService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add authentication token to requests
    final String? token = _storageService.readString(
      StorageConstants.authToken,
    );

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add common headers
    options.headers['User-Agent'] = 'DelPick Mobile App';
    options.headers['X-Requested-With'] = 'XMLHttpRequest';

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle successful responses
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Check if response contains a new token
      final dynamic data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final dynamic responseData = data['data'];
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('token')) {
          final String newToken = responseData['token'];
          _storageService.writeString(StorageConstants.authToken, newToken);
        }
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle authentication errors
    if (err.response?.statusCode == 401) {
      _handleUnauthorized(err);
    } else if (err.response?.statusCode == 403) {
      _handleForbidden(err);
    }

    handler.next(err);
  }

  void _handleUnauthorized(DioException err) {
    // Check if it's a token expiration error
    final data = err.response?.data;
    bool isTokenExpired = false;

    if (data is Map<String, dynamic> && data.containsKey('message')) {
      final message = data['message'].toString().toLowerCase();
      isTokenExpired = message.contains('token') &&
          (message.contains('expired') || message.contains('invalid'));
    }

    if (isTokenExpired) {
      // Clear stored authentication data
      _clearAuthData();

      // Check if we're not already on the login screen
      final String currentRoute = getx.Get.currentRoute;
      if (currentRoute != Routes.LOGIN &&
          currentRoute != Routes.REGISTER &&
          currentRoute != Routes.SPLASH &&
          currentRoute != Routes.ONBOARDING) {
        // Navigate to login screen
        getx.Get.offAllNamed(Routes.LOGIN);

        // Show message
        getx.Get.snackbar(
          'Session Expired',
          'Please login again to continue',
          snackPosition: getx.SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  void _handleForbidden(DioException err) {
    // Handle forbidden access
    getx.Get.snackbar(
      'Access Denied',
      'You don\'t have permission to perform this action',
      snackPosition: getx.SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  void _clearAuthData() {
    // Clear all authentication related data
    _storageService.remove(StorageConstants.authToken);
    _storageService.remove(StorageConstants.refreshToken);
    _storageService.remove(StorageConstants.userId);
    _storageService.remove(StorageConstants.userRole);
    _storageService.remove(StorageConstants.userEmail);
    _storageService.remove(StorageConstants.userName);
    _storageService.remove(StorageConstants.userPhone);
    _storageService.remove(StorageConstants.userAvatar);
    _storageService.writeBool(StorageConstants.isLoggedIn, false);
  }
}
