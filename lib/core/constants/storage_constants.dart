class StorageConstants {
  // Authentication keys
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userRole = 'user_role';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String userPhone = 'user_phone';
  static const String userAvatar = 'user_avatar';
  static const String isLoggedIn = 'is_logged_in';
  static const String lastLoginTime = 'last_login_time';

  // User preferences
  static const String language = 'language';
  static const String theme = 'theme';
  static const String isDarkMode = 'is_dark_mode';
  static const String isFirstTime = 'is_first_time';
  static const String hasSeenOnboarding = 'has_seen_onboarding';

  // Notification settings
  static const String notificationsEnabled = 'notifications_enabled';
  static const String orderNotifications = 'order_notifications';
  static const String promotionNotifications = 'promotion_notifications';
  static const String deliveryNotifications = 'delivery_notifications';
  static const String soundEnabled = 'sound_enabled';
  static const String vibrationEnabled = 'vibration_enabled';

  // Location settings
  static const String locationPermissionGranted = 'location_permission_granted';
  static const String lastKnownLatitude = 'last_known_latitude';
  static const String lastKnownLongitude = 'last_known_longitude';
  static const String defaultDeliveryAddress = 'default_delivery_address';
  static const String savedAddresses = 'saved_addresses';

  // App settings
  static const String autoLocationUpdate = 'auto_location_update';
  static const String offlineMode = 'offline_mode';
  static const String dataUsageOptimization = 'data_usage_optimization';
  static const String cacheSize = 'cache_size';
  static const String maxCacheSize = 'max_cache_size';

  // Driver specific settings
  static const String driverStatus = 'driver_status';
  static const String driverVehicleNumber = 'driver_vehicle_number';
  static const String driverLocationUpdateInterval =
      'driver_location_update_interval';
  static const String acceptOrdersAutomatically = 'accept_orders_automatically';
  static const String workingHoursStart = 'working_hours_start';
  static const String workingHoursEnd = 'working_hours_end';

  // Store specific settings
  static const String storeId = 'store_id';
  static const String storeName = 'store_name';
  static const String storeStatus = 'store_status';
  static const String storeOpenTime = 'store_open_time';
  static const String storeCloseTime = 'store_close_time';
  static const String autoAcceptOrders = 'auto_accept_orders';
  static const String preparationTime = 'preparation_time';

  // Customer specific settings
  static const String favoriteStores = 'favorite_stores';
  static const String favoriteMenuItems = 'favorite_menu_items';
  static const String orderHistory = 'order_history';
  static const String recentSearches = 'recent_searches';
  static const String paymentMethods = 'payment_methods';
  static const String defaultPaymentMethod = 'default_payment_method';

  // Cart data
  static const String cartItems = 'cart_items';
  static const String cartStoreId = 'cart_store_id';
  static const String cartTotal = 'cart_total';
  static const String cartUpdatedAt = 'cart_updated_at';

  // Offline data
  static const String offlineOrders = 'offline_orders';
  static const String pendingSyncData = 'pending_sync_data';
  static const String lastSyncTime = 'last_sync_time';
  static const String cachedStores = 'cached_stores';
  static const String cachedMenuItems = 'cached_menu_items';

  // Analytics and tracking
  static const String analyticsEnabled = 'analytics_enabled';
  static const String crashReportingEnabled = 'crash_reporting_enabled';
  static const String usageStatistics = 'usage_statistics';
  static const String sessionCount = 'session_count';
  static const String totalAppUsageTime = 'total_app_usage_time';

  // Security settings
  static const String biometricEnabled = 'biometric_enabled';
  static const String pinEnabled = 'pin_enabled';
  static const String autoLockEnabled = 'auto_lock_enabled';
  static const String autoLockDuration = 'auto_lock_duration';
  static const String lastSecurityCheck = 'last_security_check';

  // Feature flags
  static const String betaFeaturesEnabled = 'beta_features_enabled';
  static const String debugModeEnabled = 'debug_mode_enabled';
  static const String developerOptionsEnabled = 'developer_options_enabled';

  // App version tracking
  static const String currentAppVersion = 'current_app_version';
  static const String lastAppVersion = 'last_app_version';
  static const String installDate = 'install_date';
  static const String lastUpdateDate = 'last_update_date';

  // Network settings
  static const String preferredNetworkType = 'preferred_network_type';
  static const String cacheNetworkRequests = 'cache_network_requests';
  static const String retryFailedRequests = 'retry_failed_requests';
  static const String maxRetryAttempts = 'max_retry_attempts';

  // UI preferences
  static const String fontSize = 'font_size';
  static const String animationsEnabled = 'animations_enabled';
  static const String hapticFeedbackEnabled = 'haptic_feedback_enabled';
  static const String showTutorials = 'show_tutorials';
  static const String compactMode = 'compact_mode';

  // Temporary data
  static const String tempImagePath = 'temp_image_path';
  static const String tempOrderData = 'temp_order_data';
  static const String tempFilterSettings = 'temp_filter_settings';
  static const String tempSearchQuery = 'temp_search_query';

  // Error handling
  static const String lastErrorMessage = 'last_error_message';
  static const String lastErrorTime = 'last_error_time';
  static const String errorReportingEnabled = 'error_reporting_enabled';
  static const String automaticErrorReporting = 'automatic_error_reporting';
}
