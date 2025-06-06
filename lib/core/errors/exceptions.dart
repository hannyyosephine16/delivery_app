// lib/core/utils/exceptions.dart

class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message (Code: $code)';
}

// Network exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

class ConnectionException extends NetworkException {
  const ConnectionException() : super('No internet connection');
}

class TimeoutException extends NetworkException {
  const TimeoutException() : super('Request timed out');
}

// Authentication exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

class UnauthorizedException extends AuthException {
  const UnauthorizedException() : super('Unauthorized access');
}

class TokenExpiredException extends AuthException {
  const TokenExpiredException() : super('Session expired');
}

class ForbiddenException extends AuthException {
  const ForbiddenException() : super('Access denied');
}

// Data exceptions
class DataException extends AppException {
  const DataException(super.message, {super.code});
}

class ValidationException extends DataException {
  final Map<String, List<String>>? errors;

  const ValidationException(super.message, {this.errors, super.code});
}

class NotFoundException extends DataException {
  const NotFoundException(super.message);
}

class AlreadyExistsException extends DataException {
  const AlreadyExistsException(super.message);
}

class DataParsingException extends DataException {
  const DataParsingException() : super('Failed to parse data');
}

// Location exceptions
class LocationException extends AppException {
  const LocationException(super.message, {super.code});
}

class LocationPermissionDeniedException extends LocationException {
  const LocationPermissionDeniedException()
    : super('Location permission denied');
}

class LocationServiceDisabledException extends LocationException {
  const LocationServiceDisabledException()
    : super('Location service is disabled');
}

class LocationTimeoutException extends LocationException {
  const LocationTimeoutException() : super('Location request timed out');
}

// Storage exceptions
class StorageException extends AppException {
  const StorageException(super.message);
}

class CacheException extends StorageException {
  const CacheException(super.message);
}

class DatabaseException extends StorageException {
  const DatabaseException(super.message);
}

// File exceptions
class FileException extends AppException {
  const FileException(super.message);
}

class FileNotFoundException extends FileException {
  const FileNotFoundException(String path) : super('File not found: $path');
}

class FileSizeExceededException extends FileException {
  final int maxSizeMB;

  const FileSizeExceededException(this.maxSizeMB)
    : super('File size exceeds the maximum limit of $maxSizeMB MB');
}

class UnsupportedFileTypeException extends FileException {
  const UnsupportedFileTypeException(super.message);
}

// Permission exceptions
class PermissionException extends AppException {
  const PermissionException(super.message);
}

class CameraPermissionDeniedException extends PermissionException {
  const CameraPermissionDeniedException() : super('Camera permission denied');
}

class StoragePermissionDeniedException extends PermissionException {
  const StoragePermissionDeniedException() : super('Storage permission denied');
}

class NotificationPermissionDeniedException extends PermissionException {
  const NotificationPermissionDeniedException()
    : super('Notification permission denied');
}

// Business logic exceptions
class BusinessLogicException extends AppException {
  const BusinessLogicException(super.message, {super.code});
}

class OrderException extends BusinessLogicException {
  const OrderException(super.message, {super.code});
}

class PaymentException extends BusinessLogicException {
  const PaymentException(super.message, {super.code});
}

class DeliveryException extends BusinessLogicException {
  const DeliveryException(super.message, {super.code});
}

// Cart exceptions
class CartException extends BusinessLogicException {
  const CartException(super.message);
}

class EmptyCartException extends CartException {
  const EmptyCartException() : super('Your cart is empty');
}

class CartItemNotFoundException extends CartException {
  const CartItemNotFoundException() : super('Item not found in cart');
}

class StoreConflictException extends CartException {
  const StoreConflictException()
    : super('Cannot add items from different stores to cart');
}
