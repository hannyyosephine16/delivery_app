// Base Failure Class
class Failure {
  final String message;
  final String? code;
  final dynamic data;

  const Failure(this.message, {this.code, this.data});

  @override
  List<Object?> get props => [message, code, data];
}

// Network Failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code, super.data});
}

class ConnectionFailure extends NetworkFailure {
  const ConnectionFailure()
    : super('Connection failed. Please check your internet connection.');
}

class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure() : super('Request timeout. Please try again.');
}

class ServerFailure extends NetworkFailure {
  final int statusCode;

  const ServerFailure(this.statusCode, String message, {String? code})
    : super(message, code: code);

  @override
  List<Object?> get props => [statusCode, message, code];
}

// Authentication Failures
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code, super.data});
}

class UnauthorizedFailure extends AuthFailure {
  const UnauthorizedFailure()
    : super('Unauthorized access. Please login again.');
}

class ForbiddenFailure extends AuthFailure {
  const ForbiddenFailure()
    : super(
        'Access denied. You don\'t have permission to perform this action.',
      );
}

class TokenExpiredFailure extends AuthFailure {
  const TokenExpiredFailure() : super('Session expired. Please login again.');
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('Invalid email or password.');
}

class AccountNotVerifiedFailure extends AuthFailure {
  const AccountNotVerifiedFailure()
    : super('Account not verified. Please check your email.');
}

// Validation Failures
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure(super.message, {this.errors, super.code})
    : super(data: errors);

  @override
  List<Object?> get props => [message, errors, code];
}

class RequiredFieldFailure extends ValidationFailure {
  const RequiredFieldFailure(String fieldName)
    : super('$fieldName is required');
}

class InvalidFormatFailure extends ValidationFailure {
  const InvalidFormatFailure(String fieldName)
    : super('Invalid format for $fieldName');
}

class InvalidEmailFailure extends ValidationFailure {
  const InvalidEmailFailure() : super('Please enter a valid email address');
}

class WeakPasswordFailure extends ValidationFailure {
  const WeakPasswordFailure()
    : super('Password must be at least 6 characters long');
}

// Data Failures
class DataFailure extends Failure {
  const DataFailure(super.message, {super.code, super.data});
}

class NotFoundFailure extends DataFailure {
  const NotFoundFailure(String resource) : super('$resource not found');
}

class AlreadyExistsFailure extends DataFailure {
  const AlreadyExistsFailure(String resource)
    : super('$resource already exists');
}

class DataParsingFailure extends DataFailure {
  const DataParsingFailure() : super('Failed to parse data');
}

class EmptyDataFailure extends DataFailure {
  const EmptyDataFailure() : super('No data available');
}

// Cache Failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class CacheNotFoundFailure extends CacheFailure {
  const CacheNotFoundFailure() : super('Data not found in cache');
}

class CacheExpiredFailure extends CacheFailure {
  const CacheExpiredFailure() : super('Cached data has expired');
}

// Location Failures
class LocationFailure extends Failure {
  const LocationFailure(super.message, {super.code});
}

class LocationPermissionDeniedFailure extends LocationFailure {
  const LocationPermissionDeniedFailure()
    : super('Location permission denied. Please enable location access.');
}

class LocationServiceDisabledFailure extends LocationFailure {
  const LocationServiceDisabledFailure()
    : super('Location service is disabled. Please enable GPS.');
}

class LocationTimeoutFailure extends LocationFailure {
  const LocationTimeoutFailure()
    : super('Failed to get location. Please try again.');
}

// Storage Failures
class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

class DatabaseFailure extends StorageFailure {
  const DatabaseFailure() : super('Database operation failed');
}

class StorageFullFailure extends StorageFailure {
  const StorageFullFailure()
    : super('Storage is full. Please free up some space.');
}

// File Failures
class FileFailure extends Failure {
  const FileFailure(super.message);
}

class FileNotFoundFailure extends FileFailure {
  const FileNotFoundFailure(String fileName)
    : super('File not found: $fileName');
}

class FileSizeExceededFailure extends FileFailure {
  const FileSizeExceededFailure(int maxSize)
    : super('File size exceeds maximum limit of ${maxSize}MB');
}

class UnsupportedFileTypeFailure extends FileFailure {
  const UnsupportedFileTypeFailure(String fileType)
    : super('Unsupported file type: $fileType');
}

// Permission Failures
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

class CameraPermissionDeniedFailure extends PermissionFailure {
  const CameraPermissionDeniedFailure()
    : super('Camera permission denied. Please enable camera access.');
}

class StoragePermissionDeniedFailure extends PermissionFailure {
  const StoragePermissionDeniedFailure()
    : super('Storage permission denied. Please enable storage access.');
}

class NotificationPermissionDeniedFailure extends PermissionFailure {
  const NotificationPermissionDeniedFailure()
    : super('Notification permission denied. Please enable notifications.');
}

// Business Logic Failures
class BusinessLogicFailure extends Failure {
  const BusinessLogicFailure(super.message, {super.code});
}

class OrderFailure extends BusinessLogicFailure {
  const OrderFailure(super.message, {super.code});
}

class OrderNotFoundFailure extends OrderFailure {
  const OrderNotFoundFailure() : super('Order not found');
}

class OrderCancellationFailure extends OrderFailure {
  const OrderCancellationFailure()
    : super('Order cannot be cancelled at this stage');
}

class PaymentFailure extends BusinessLogicFailure {
  const PaymentFailure(super.message, {super.code});
}

class PaymentDeclinedFailure extends PaymentFailure {
  const PaymentDeclinedFailure()
    : super('Payment was declined. Please try a different payment method.');
}

class InsufficientFundsFailure extends PaymentFailure {
  const InsufficientFundsFailure()
    : super('Insufficient funds. Please check your account balance.');
}

// Cart Failures
class CartFailure extends BusinessLogicFailure {
  const CartFailure(super.message);
}

class EmptyCartFailure extends CartFailure {
  const EmptyCartFailure()
    : super('Cart is empty. Please add items to proceed.');
}

class CartItemNotFoundFailure extends CartFailure {
  const CartItemNotFoundFailure() : super('Item not found in cart.');
}

class StoreConflictFailure extends CartFailure {
  const StoreConflictFailure()
    : super('Cannot add items from different stores. Please clear cart first.');
}

class ItemOutOfStockFailure extends CartFailure {
  const ItemOutOfStockFailure(String itemName)
    : super('$itemName is out of stock.');
}

// Delivery Failures
class DeliveryFailure extends BusinessLogicFailure {
  const DeliveryFailure(super.message, {super.code});
}

class DriverNotFoundFailure extends DeliveryFailure {
  const DriverNotFoundFailure()
    : super('No driver available in your area. Please try again later.');
}

class DeliveryAreaNotSupportedFailure extends DeliveryFailure {
  const DeliveryAreaNotSupportedFailure()
    : super('Delivery is not available in your area.');
}

class DeliveryTimeExceededFailure extends DeliveryFailure {
  const DeliveryTimeExceededFailure()
    : super('Delivery time has exceeded the estimated time.');
}

// Store Failures
class StoreFailure extends BusinessLogicFailure {
  const StoreFailure(super.message);
}

class StoreClosedFailure extends StoreFailure {
  const StoreClosedFailure(String storeName)
    : super('$storeName is currently closed.');
}

class StoreNotFoundFailure extends StoreFailure {
  const StoreNotFoundFailure() : super('Store not found.');
}

class MenuItemNotAvailableFailure extends StoreFailure {
  const MenuItemNotAvailableFailure(String itemName)
    : super('$itemName is currently not available.');
}

// Driver Failures
class DriverFailure extends BusinessLogicFailure {
  const DriverFailure(super.message);
}

class DriverNotActiveFailure extends DriverFailure {
  const DriverNotActiveFailure() : super('Driver is not currently active.');
}

class DriverBusyFailure extends DriverFailure {
  const DriverBusyFailure()
    : super('Driver is currently busy with another delivery.');
}

// Unknown Failure
class UnknownFailure extends Failure {
  const UnknownFailure()
    : super('An unknown error occurred. Please try again.');
}
