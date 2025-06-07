import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:del_pick/core/services/external/connectivity_service.dart';

class ConnectivityMiddleware {
  static final ConnectivityService _connectivityService =
      getx.Get.find<ConnectivityService>();

  /// Middleware untuk mengecek koneksi internet sebelum request
  static InterceptorsWrapper getConnectivityInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        // Check internet connection
        if (!_connectivityService.isConnected) {
          handler.reject(
            DioException(
              requestOptions: options,
              error: 'No internet connection available',
              type: DioExceptionType.connectionError,
            ),
          );
          return;
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (error, handler) {
        // Handle connection errors
        if (error.type == DioExceptionType.connectionError) {
          _showConnectionError();
        }
        handler.next(error);
      },
    );
  }

  /// Show connection error message
  static void _showConnectionError() {
    getx.Get.snackbar(
      'Connection Error',
      'Please check your internet connection and try again',
      snackPosition: getx.SnackPosition.TOP,
      backgroundColor: getx.Get.theme.colorScheme.error,
      colorText: getx.Get.theme.colorScheme.onError,
    );
  }

  /// Check if device has internet connection
  static bool hasConnection() {
    return _connectivityService.isConnected;
  }

  /// Show offline message
  static void showOfflineMessage() {
    getx.Get.snackbar(
      'You\'re Offline',
      'Some features may not be available without internet connection',
      snackPosition: getx.SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show online message
  static void showOnlineMessage() {
    getx.Get.snackbar(
      'Back Online',
      'Internet connection restored',
      snackPosition: getx.SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: getx.Get.theme.colorScheme.primary,
      colorText: getx.Get.theme.colorScheme.onPrimary,
    );
  }
}
