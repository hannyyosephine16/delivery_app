import 'package:get/get.dart';
import 'package:delivery_app/data/repositories/store_repository.dart';
import 'package:delivery_app/data/repositories/menu_repository.dart';
import 'package:delivery_app/data/repositories/order_repository.dart';
import 'package:delivery_app/data/providers/store_provider.dart';
import 'package:delivery_app/data/providers/menu_provider.dart';
import 'package:delivery_app/data/providers/order_provider.dart';
import 'package:delivery_app/data/datasources/remote/store_remote_datasource.dart';
import 'package:delivery_app/data/datasources/remote/menu_remote_datasource.dart';
import 'package:delivery_app/data/datasources/remote/order_remote_datasource.dart';

// Import the controller files once they're created
// import 'package:delivery_app/features/store/controllers/store_dashboard_controller.dart';
// import 'package:delivery_app/features/store/controllers/menu_management_controller.dart';
// import 'package:delivery_app/features/store/controllers/add_menu_item_controller.dart';
// import 'package:delivery_app/features/store/controllers/store_orders_controller.dart';
// import 'package:delivery_app/features/store/controllers/store_analytics_controller.dart';
// import 'package:delivery_app/features/store/controllers/store_settings_controller.dart';
// import 'package:delivery_app/features/store/controllers/store_profile_controller.dart';

class StoreBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut<StoreRemoteDataSource>(() => StoreRemoteDataSource(Get.find()));
    Get.lazyPut<MenuRemoteDataSource>(() => MenuRemoteDataSource(Get.find()));
    Get.lazyPut<OrderRemoteDataSource>(() => OrderRemoteDataSource(Get.find()));

    // Providers
    Get.lazyPut<StoreProvider>(() => StoreProvider());
    Get.lazyPut<MenuProvider>(() => MenuProvider());
    Get.lazyPut<OrderProvider>(() => OrderProvider());

    // Repositories
    Get.lazyPut<StoreRepository>(() => StoreRepository(Get.find()));
    Get.lazyPut<MenuRepository>(() => MenuRepository(Get.find()));
    Get.lazyPut<OrderRepository>(() => OrderRepository(Get.find()));

    // Controllers - uncomment when the controller files are created
    /*
    Get.lazyPut<StoreDashboardController>(
      () => StoreDashboardController(
        storeRepository: Get.find(),
        orderRepository: Get.find(),
        menuRepository: Get.find(),
      ),
    );
    Get.lazyPut<MenuManagementController>(
      () => MenuManagementController(Get.find()),
    );
    Get.lazyPut<AddMenuItemController>(() => AddMenuItemController(Get.find()));
    Get.lazyPut<StoreOrdersController>(() => StoreOrdersController(Get.find()));
    Get.lazyPut<StoreAnalyticsController>(
      () => StoreAnalyticsController(
        storeRepository: Get.find(),
        orderRepository: Get.find(),
      ),
    );
    Get.lazyPut<StoreSettingsController>(
      () => StoreSettingsController(Get.find()),
    );
    Get.lazyPut<StoreProfileController>(
      () => StoreProfileController(Get.find()),
    );
    */
  }
}
