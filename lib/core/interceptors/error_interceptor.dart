import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = 'An error occurred';

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout';
        break;
      case DioExceptionType.badResponse:
        message = _handleStatusError(err.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;
      default:
        message = err.message ?? 'Unknown error';
    }

    getx.Get.snackbar('Error', message, snackPosition: getx.SnackPosition.TOP);

    handler.next(err);
  }

  String _handleStatusError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Server error';
    }
  }
}
