import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  // Convert exceptions to failures
  static Failure handleException(Exception exception) {
    if (kDebugMode) {
      debugPrint('ErrorHandler: ${exception.toString()}');
    }

    if (exception is DioException) {
      return _handleDioException(exception);
    } else if (exception is SocketException) {
      return const ConnectionFailure();
    } else if (exception is HttpException) {
      return ServerFailure(500, exception.message);
    } else if (exception is FormatException) {
      return const DataParsingFailure();
    } else if (exception is AppException) {
      return _handleAppException(exception);
    } else {
      return const UnknownFailure();
    }
  }

  // Handle Dio exceptions
  static Failure _handleDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.connectionError:
        return const ConnectionFailure();

      case DioExceptionType.badResponse:
        return _handleResponseError(dioException);

      case DioExceptionType.cancel:
        return const NetworkFailure('Request was cancelled');

      case DioExceptionType.unknown:
      default:
        if (dioException.error is SocketException) {
          return const ConnectionFailure();
        }
        return const UnknownFailure();
    }
  }

  // Handle HTTP response errors
  static Failure _handleResponseError(DioException dioException) {
    final statusCode = dioException.response?.statusCode ?? 0;
    final data = dioException.response?.data;

    String message = 'An error occurred';
    String? code;

    // Extract error message from response
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? message;
      code = data['code']?.toString();

      // Handle validation errors
      if (data['errors'] != null) {
        final errors = data['errors'];
        if (errors is Map<String, dynamic>) {
          // Convert validation errors to proper format
          final validationErrors = <String, List<String>>{};
          errors.forEach((key, value) {
            if (value is List) {
              validationErrors[key] = value.cast<String>();
            } else if (value is String) {
              validationErrors[key] = [value];
            }
          });
          return ValidationFailure(
            message,
            errors: validationErrors,
            code: code,
          );
        }
      }
    }

    switch (statusCode) {
      case 400:
        return ValidationFailure(message, code: code);
      case 401:
        if (message.toLowerCase().contains('token')) {
          return const TokenExpiredFailure();
        }
        return UnauthorizedFailure();
      case 403:
        return const ForbiddenFailure();
      case 404:
        return NotFoundFailure(message);
      case 409:
        return AlreadyExistsFailure(message);
      case 422:
        return ValidationFailure(message, code: code);
      case 429:
        return const NetworkFailure(
          'Too many requests. Please try again later.',
        );
      case 500:
        return ServerFailure(statusCode, 'Internal server error');
      case 502:
        return ServerFailure(statusCode, 'Bad gateway');
      case 503:
        return ServerFailure(statusCode, 'Service unavailable');
      case 504:
        return ServerFailure(statusCode, 'Gateway timeout');
      default:
        return ServerFailure(statusCode, message);
    }
  }

  // Handle app-specific exceptions
  static Failure _handleAppException(AppException exception) {
    if (exception is NetworkException) {
      return NetworkFailure(exception.message, code: exception.code);
    } else if (exception is AuthException) {
      if (exception is UnauthorizedException) {
        return const UnauthorizedFailure();
      } else if (exception is ForbiddenException) {
        return const ForbiddenFailure();
      } else if (exception is TokenExpiredException) {
        return const TokenExpiredFailure();
      }
      return AuthFailure(exception.message, code: exception.code);
    } else if (exception is ValidationException) {
      return ValidationFailure(
        exception.message,
        errors: exception.errors,
        code: exception.code,
      );
    } else if (exception is DataException) {
      if (exception is NotFoundException) {
        return NotFoundFailure(exception.message);
      } else if (exception is AlreadyExistsException) {
        return AlreadyExistsFailure(exception.message);
      } else if (exception is DataParsingException) {
        return const DataParsingFailure();
      }
      return DataFailure(exception.message, code: exception.code);
    } else if (exception is LocationException) {
      if (exception is LocationPermissionDeniedException) {
        return const LocationPermissionDeniedFailure();
      } else if (exception is LocationServiceDisabledException) {
        return const LocationServiceDisabledFailure();
      } else if (exception is LocationTimeoutException) {
        return const LocationTimeoutFailure();
      }
      return LocationFailure(exception.message, code: exception.code);
    } else if (exception is StorageException) {
      if (exception is CacheException) {
        return CacheFailure(exception.message);
      } else if (exception is DatabaseException) {
        return const DatabaseFailure();
      }
      return StorageFailure(exception.message);
    } else if (exception is FileException) {
      if (exception is FileNotFoundException) {
        return FileNotFoundFailure(exception.message);
      } else if (exception is FileSizeExceededException) {
        // Extract size from message or use default
        return const FileSizeExceededFailure(5);
      } else if (exception is UnsupportedFileTypeException) {
        return UnsupportedFileTypeFailure(exception.message);
      }
      return FileFailure(exception.message);
    } else if (exception is PermissionException) {
      if (exception is CameraPermissionDeniedException) {
        return const CameraPermissionDeniedFailure();
      } else if (exception is StoragePermissionDeniedException) {
        return const StoragePermissionDeniedFailure();
      } else if (exception is NotificationPermissionDeniedException) {
        return const NotificationPermissionDeniedFailure();
      }
      return PermissionFailure(exception.message);
    } else if (exception is BusinessLogicException) {
      if (exception is OrderException) {
        return OrderFailure(exception.message, code: exception.code);
      } else if (exception is PaymentException) {
        return PaymentFailure(exception.message, code: exception.code);
      } else if (exception is DeliveryException) {
        return DeliveryFailure(exception.message, code: exception.code);
      } else if (exception is CartException) {
        if (exception is EmptyCartException) {
          return const EmptyCartFailure();
        } else if (exception is CartItemNotFoundException) {
          return const CartItemNotFoundFailure();
        } else if (exception is StoreConflictException) {
          return const StoreConflictFailure();
        }
        return CartFailure(exception.message);
      }
      return BusinessLogicFailure(exception.message, code: exception.code);
    }

    return Failure(exception.message, code: exception.code);
  }

  // Get user-friendly error message
  static String getErrorMessage(Failure failure) {
    // Return user-friendly messages for common failures
    if (failure is ConnectionFailure) {
      return 'No internet connection. Please check your network settings.';
    } else if (failure is TimeoutFailure) {
      return 'Request timed out. Please try again.';
    } else if (failure is UnauthorizedFailure) {
      return 'Your session has expired. Please login again.';
    } else if (failure is ForbiddenFailure) {
      return 'You don\'t have permission to perform this action.';
    } else if (failure is ValidationFailure) {
      // Return the first validation error
      if (failure.errors != null && failure.errors!.isNotEmpty) {
        final firstError = failure.errors!.values.first;
        if (firstError.isNotEmpty) {
          return firstError.first;
        }
      }
      return failure.message;
    } else if (failure is ServerFailure) {
      if (failure.statusCode >= 500) {
        return 'Server error. Please try again later.';
      }
      return failure.message;
    }

    return failure.message;
  }

  // Check if error is recoverable (user can retry)
  static bool isRecoverable(Failure failure) {
    return failure is TimeoutFailure ||
        failure is ConnectionFailure ||
        failure is ServerFailure ||
        failure is NetworkFailure;
  }

  // Check if error requires authentication
  static bool requiresAuth(Failure failure) {
    return failure is UnauthorizedFailure ||
        failure is TokenExpiredFailure ||
        failure is ForbiddenFailure;
  }

  // Log error for debugging
  static void logError(Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('Error: $error');
      debugPrint('StackTrace: $stackTrace');
    }

    // In production, you might want to send errors to a crash reporting service
    // like Firebase Crashlytics or Sentry
  }
}
