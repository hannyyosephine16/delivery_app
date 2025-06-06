import 'package:delivery_app/core/constants/app_constants.dart';
import 'package:get/get.dart';

import '../../core/services/api/api_service.dart';
import '../../core/services/external/connectivity_service.dart';
import '../../core/services/external/location_service.dart';
import '../../core/services/external/notification_service.dart';
import '../../core/services/external/permission_service.dart';
import '../../core/services/local/storage_service.dart';

class AppConfig {
  // App Information
  static const String appName = AppConstants.appName;
  static const String appVersion = AppConstants.appVersion;
  static const String appBuildNumber = AppConstants.appBuildNumber;
  static const String appPackageName = 'frontend_delpick';

  // App settings
  static const int splashDuration = 3; // seconds
  static const int requestTimeout = AppConstants.apiTimeout;
  static const int connectionTimeout = AppConstants.connectionTimeout;
  static const int maxRetryAttempts = 3;

  // Location Settings
  static const double defaultLatitude = AppConstants.defaultLatitude;
  static const double defaultLongitude = AppConstants.defaultLongitude;
  static const double maxDeliveryRadius = AppConstants.maxDeliveryRadius;
  static const int locationUpdateInterval = AppConstants.locationUpdateInterval;

  // Image Settings
  static const int maxImageSize =
      AppConstants.maxImageSizeMB * 1024 * 1024; // Convert to bytes
  static const List<String> allowedImageTypes =
      AppConstants.allowedImageFormats;

  // Pagination
  static const int defaultPageSize = AppConstants.defaultPageSize;
  static const int maxPageSize = AppConstants.maxPageSize;

  // Order settings
  static const int orderCancelTimeout = AppConstants.orderCancelTimeout;
  static const int driverRequestTimeout = AppConstants.driverRequestTimeout;
  static const double serviceChargeRate = AppConstants.serviceChargeRate;

  // Rating settings
  static const int minRating = AppConstants.minRating;
  static const int maxRating = AppConstants.maxRating;

  // Currency
  static const String currency = AppConstants.currency;
  static const String currencySymbol = AppConstants.currencySymbol;

  // Date formats
  static const String dateFormat = AppConstants.dateFormat;
  static const String timeFormat = AppConstants.timeFormat;
  static const String dateTimeFormat = AppConstants.dateTimeFormat;
  static const String apiDateFormat = AppConstants.apiDateFormat;
  static const String apiDateTimeFormat = AppConstants.apiDateTimeFormat;

  // Validation rules
  static const int minPasswordLength = AppConstants.minPasswordLength;
  static const int maxPasswordLength = AppConstants.maxPasswordLength;
  static const int minNameLength = AppConstants.minNameLength;
  static const int maxNameLength = AppConstants.maxNameLength;
  static const int maxDescriptionLength = AppConstants.maxDescriptionLength;
  static const int maxAddressLength = AppConstants.maxAddressLength;
  static const int maxNotesLength = AppConstants.maxNotesLength;

  // Regular expressions
  static const String emailRegex = AppConstants.emailRegex;
  static const String phoneRegex = AppConstants.phoneRegex;
  static const String passwordRegex = AppConstants.passwordRegex;

  // Cache Duration (in seconds)
  static const int shortCacheDuration = AppConstants.shortCacheDuration;
  static const int mediumCacheDuration = AppConstants.mediumCacheDuration;
  static const int longCacheDuration = AppConstants.longCacheDuration;
  static const int verylongCacheDuration = AppConstants.verylongCacheDuration;

  // Animation Durations
  static const int shortAnimationDuration = AppConstants.shortAnimationDuration;
  static const int mediumAnimationDuration =
      AppConstants.mediumAnimationDuration;
  static const int longAnimationDuration = AppConstants.longAnimationDuration;

  // Languages
  static const String defaultLanguage = AppConstants.defaultLanguage;
  static const List<String> supportedLanguages =
      AppConstants.supportedLanguages;

  // Maps
  static const double defaultZoom = AppConstants.defaultZoom;
  static const double minZoom = AppConstants.minZoom;
  static const double maxZoom = AppConstants.maxZoom;

  // Social media links
  static const String websiteUrl = AppConstants.websiteUrl;
  static const String supportEmail = AppConstants.supportEmail;
  static const String privacyPolicyUrl = AppConstants.privacyPolicyUrl;
  static const String termsOfServiceUrl = AppConstants.termsOfServiceUrl;
  static const String facebookUrl = AppConstants.facebookUrl;
  static const String instagramUrl = AppConstants.instagramUrl;
  static const String twitterUrl = AppConstants.twitterUrl;

  // Default placeholders
  static const String defaultAvatarUrl = AppConstants.defaultAvatarUrl;
  static const String defaultStoreImageUrl = AppConstants.defaultStoreImageUrl;
  static const String defaultFoodImageUrl = AppConstants.defaultFoodImageUrl;

  // File paths
  static const String documentsPath = AppConstants.documentsPath;
  static const String imagesPath = AppConstants.imagesPath;
  static const String cachePath = AppConstants.cachePath;
  static const String logsPath = AppConstants.logsPath;

  // Feature Flags (can be controlled remotely)
  static bool get enableBiometric => true;
  static bool get enablePushNotifications => true;
  static bool get enableLocationTracking => true;
  static bool get enableOfflineMode => true;
  static bool get enableAnalytics => true;
  static bool get enableCrashReporting => true;

  // Development Settings
  static bool get isDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  static bool get isReleaseMode => !isDebugMode;
  static bool get enableLogging => isDebugMode;

  // static Future<void> initialize() async {
  //   // Initialize core services
  //   Get.put<StorageService>(StorageService(), permanent: true);
  //   Get.put<ApiService>(ApiService(), permanent: true);
  //   Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
  //   Get.put<LocationService>(LocationService(), permanent: true);
  //   Get.put<NotificationService>(NotificationService(), permanent: true);
  //   Get.put<PermissionService>(PermissionService(), permanent: true);
  //
  //   // Initialize services
  //   await Get.find<StorageService>().onInit();
  //   Get.find<ApiService>().onInit();
  //   await Get.find<ConnectivityService>().onInit();
  //   await Get.find<LocationService>().onInit();
  //   await Get.find<NotificationService>().onInit();
  //   Get.find<PermissionService>().onInit();
  //   await Future.delayed(Duration.zero);
  // }
  static Future<void> initialize() async {
    try {
      // Initialize core services
      Get.put<StorageService>(StorageService(), permanent: true);
      Get.put<ApiService>(ApiService(), permanent: true);
      Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
      Get.put<LocationService>(LocationService(), permanent: true);

      // Initialize services
      await Get.find<StorageService>().onInit();
      Get.find<ApiService>().onInit();
      await Get.find<ConnectivityService>().onInit();
      await Get.find<LocationService>().onInit();

      await Future.delayed(Duration.zero);
    } catch (e) {
      print('Error initializing app: $e');
    }
  }
}

// class AppConfig {
//   static const String appName = 'DelPick';
//   static const String appVersion = '1.0.0';
//   // static const String appPackageName = 'com.delpick.fooddelivery';
//   static const String appPackageName = 'frontend_delpick';
//
//
//   // App settings
//   static const int splashDuration = 3; // seconds
//   static const int requestTimeout = 30; // seconds
//   static const int maxRetryAttempts = 3;
//
//   // Pagination
//   static const int defaultPageSize = 10;
//   static const int maxPageSize = 50;
//
//   // Location settings
//   static const double defaultLatitude = 2.38349390603264; // IT Del coordinates
//   static const double defaultLongitude = 99.14866498216043;
//   static const double maxDeliveryRadius = 5.0; // kilometers
//
//   // File upload settings
//   static const int maxImageSize = 5 * 1024 * 1024; // 5MB
//   static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
//
//   // Driver location update interval
//   static const int locationUpdateInterval = 15; // seconds
//
//   // Order settings
//   static const int orderCancelTimeout = 15 * 60; // 15 minutes in seconds
//   static const double serviceChargeRate = 0.1; // 10%
//
//   // Rating settings
//   static const int minRating = 1;
//   static const int maxRating = 5;
//
//   // Currency
//   static const String currency = 'IDR';
//   static const String currencySymbol = 'Rp';
//
//   // Date formats
//   static const String dateFormat = 'dd/MM/yyyy';
//   static const String timeFormat = 'HH:mm';
//   static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
//
//   // Validation rules
//   static const int minPasswordLength = 6;
//   static const int maxPasswordLength = 100;
//   static const int minNameLength = 3;
//   static const int maxNameLength = 50;
//
//   // Social media links
//   static const String websiteUrl = 'https://delpick.com';
//   static const String supportEmail = 'support@delpick.com';
//   static const String privacyPolicyUrl = 'https://delpick.com/privacy';
//   static const String termsOfServiceUrl = 'https://delpick.com/terms';
// }
