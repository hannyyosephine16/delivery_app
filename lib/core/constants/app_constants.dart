// lib/core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'DelPick';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // User roles
  static const String roleCustomer = 'customer';
  static const String roleDriver = 'driver';
  static const String roleStore = 'store';
  static const String roleAdmin = 'admin';

  // Order statuses
  static const String orderPending = 'pending';
  static const String orderApproved = 'approved';
  static const String orderPreparing = 'preparing';
  static const String orderOnDelivery = 'on_delivery';
  static const String orderDelivered = 'delivered';
  static const String orderCancelled = 'cancelled';

  // Delivery statuses
  static const String deliveryWaiting = 'waiting';
  static const String deliveryPickingUp = 'picking_up';
  static const String deliveryOnDelivery = 'on_delivery';
  static const String deliveryDelivered = 'delivered';

  // Driver statuses
  static const String driverActive = 'active';
  static const String driverInactive = 'inactive';
  static const String driverBusy = 'busy';

  // Store statuses
  static const String storeOpen = 'active';
  static const String storeClosed = 'inactive';

  // Request statuses
  static const String requestPending = 'pending';
  static const String requestAccepted = 'accepted';
  static const String requestRejected = 'rejected';
  static const String requestExpired = 'expired';
  static const String requestCompleted = 'completed';

  // Payment statuses
  static const String paymentPending = 'pending';
  static const String paymentPaid = 'paid';
  static const String paymentFailed = 'failed';
  static const String paymentRefunded = 'refunded';

  // Image upload
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png'];

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // Location
  static const double defaultLatitude = 2.38349390603264; // IT Del
  static const double defaultLongitude = 99.14866498216043;
  static const double maxDeliveryRadius = 5.0; // km
  static const int locationUpdateInterval = 15; // seconds

  // Rating
  static const int minRating = 1;
  static const int maxRating = 5;

  // Currency
  static const String currency = 'IDR';
  static const String currencySymbol = 'Rp';

  // Time formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss.SSSZ';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 100;
  static const int minNameLength = 3;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  static const int maxAddressLength = 200;
  static const int maxNotesLength = 500;

  // Regular expressions - Fixed string literals
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phoneRegex = r'^[0-9]{10,15}$';
  static const String passwordRegex =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{6,}$';

  // Animation durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;

  // Timeouts
  static const int apiTimeout = 30; // seconds
  static const int connectionTimeout = 10; // seconds
  static const int orderCancelTimeout = 15 * 60; // 15 minutes
  static const int driverRequestTimeout = 2 * 60; // 2 minutes

  // Cache durations
  static const int shortCacheDuration = 5 * 60; // 5 minutes
  static const int mediumCacheDuration = 30 * 60; // 30 minutes
  static const int longCacheDuration = 60 * 60; // 1 hour
  static const int verylongCacheDuration = 24 * 60 * 60; // 24 hours

  // Notification types
  static const String notificationOrderUpdate = 'order_update';
  static const String notificationDeliveryUpdate = 'delivery_update';
  static const String notificationPromotion = 'promotion';
  static const String notificationGeneral = 'general';
  static const String notificationDriverRequest = 'driver_request';

  // Languages
  static const String defaultLanguage = 'en';
  static const List<String> supportedLanguages = ['en', 'id'];

  // Maps
  static const double defaultZoom = 15.0;
  static const double minZoom = 5.0;
  static const double maxZoom = 20.0;

  // Service charge
  static const double serviceChargeRate = 0.1; // 10%

  // Error messages
  static const String errorGeneral = 'Something went wrong. Please try again.';
  static const String errorNetwork =
      'Network error. Please check your connection.';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorUnauthorized =
      'You are not authorized to perform this action.';
  static const String errorNotFound = 'Requested resource not found.';
  static const String errorValidation =
      'Please check your input and try again.';
  static const String errorServer = 'Server error. Please try again later.';

  // Success messages
  static const String successLogin = 'Login successful';
  static const String successRegister = 'Registration successful';
  static const String successUpdate = 'Update successful';
  static const String successDelete = 'Delete successful';
  static const String successOrderPlaced = 'Order placed successfully';
  static const String successOrderCancelled = 'Order cancelled successfully';

  // Default values
  // lib/core/constants/app_constants.dart - Update the image constants

// Replace the asset paths with placeholder URLs or remove them temporarily
  static const String defaultAvatarUrl = 'https://via.placeholder.com/150x150/CCCCCC/FFFFFF?text=User';
  static const String defaultStoreImageUrl = 'https://via.placeholder.com/300x200/CCCCCC/FFFFFF?text=Store';
  static const String defaultFoodImageUrl = 'https://via.placeholder.com/200x150/CCCCCC/FFFFFF?text=Food';
  // static const String defaultAvatarUrl =
  //     'assets/images/placeholders/placeholder_user.png';
  // static const String defaultStoreImageUrl =
  //     'assets/images/placeholders/placeholder_store.png';
  // static const String defaultFoodImageUrl =
  //     'assets/images/placeholders/placeholder_food.png';

  // Social media
  static const String websiteUrl = 'https://delpick.com';
  static const String supportEmail = 'support@delpick.com';
  static const String privacyPolicyUrl = 'https://delpick.com/privacy';
  static const String termsOfServiceUrl = 'https://delpick.com/terms';
  static const String facebookUrl = 'https://facebook.com/delpick';
  static const String instagramUrl = 'https://instagram.com/delpick';
  static const String twitterUrl = 'https://twitter.com/delpick';

  // File paths
  static const String documentsPath = '/Documents/DelPick';
  static const String imagesPath = '/Images';
  static const String cachePath = '/Cache';
  static const String logsPath = '/Logs';
}
