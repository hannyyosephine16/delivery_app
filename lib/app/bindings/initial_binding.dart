import 'package:get/get.dart';
import 'package:delivery_app/core/services/api/api_service.dart';
import 'package:delivery_app/core/services/local/storage_service.dart';
import 'package:delivery_app/core/services/local/cache_service.dart';
import 'package:delivery_app/core/services/local/database_service.dart';
import 'package:delivery_app/core/services/external/location_service.dart';
import 'package:delivery_app/core/services/external/notification_service.dart';
import 'package:delivery_app/core/services/external/connectivity_service.dart';
import 'package:delivery_app/core/services/external/permission_service.dart';
import 'package:delivery_app/features/shared/controllers/navigation_controller.dart';
import 'package:delivery_app/features/shared/controllers/theme_controller.dart';
import 'package:delivery_app/features/shared/controllers/language_controller.dart';
import 'package:delivery_app/features/shared/controllers/notification_controller.dart';
import 'package:delivery_app/features/shared/controllers/connectivity_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core services - Singleton instances
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<CacheService>(CacheService(), permanent: true);
    Get.put<DatabaseService>(DatabaseService(), permanent: true);
    Get.put<ApiService>(ApiService(), permanent: true);

    // External services - Singleton instances
    Get.put<LocationService>(LocationService(), permanent: true);
    Get.put<NotificationService>(NotificationService(), permanent: true);
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
    Get.put<PermissionService>(PermissionService(), permanent: true);

    // Shared controllers - Singleton instances
    Get.put<NavigationController>(NavigationController(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<LanguageController>(LanguageController(), permanent: true);
    Get.put<NotificationController>(NotificationController(), permanent: true);
    Get.put<ConnectivityController>(ConnectivityController(), permanent: true);
  }
}
