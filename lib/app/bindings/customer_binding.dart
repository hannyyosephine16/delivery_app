import 'package:get/get.dart';
import 'package:delivery_app/features/customer/controllers/store_controller.dart';
import 'package:delivery_app/features/customer/controllers/home_controller.dart';
import 'package:delivery_app/features/customer/controllers/cart_controller.dart';
import 'package:delivery_app/data/repositories/tracking_repository.dart';
import 'package:delivery_app/data/repositories/store_repository.dart';
import 'package:delivery_app/data/repositories/menu_repository.dart';
import 'package:delivery_app/data/repositories/order_repository.dart';
import 'package:delivery_app/data/providers/tracking_provider.dart';
import 'package:delivery_app/data/providers/store_provider.dart';
import 'package:delivery_app/data/providers/menu_provider.dart';
import 'package:delivery_app/data/providers/order_provider.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    // Providers
    Get.lazyPut<StoreProvider>(() => StoreProvider());
    Get.lazyPut<MenuProvider>(() => MenuProvider());
    Get.lazyPut<OrderProvider>(() => OrderProvider());
    Get.lazyPut<TrackingProvider>(() => TrackingProvider());

    // Repositories
    Get.lazyPut<StoreRepository>(() => StoreRepository(Get.find()));
    Get.lazyPut<MenuRepository>(() => MenuRepository(Get.find()));
    Get.lazyPut<OrderRepository>(() => OrderRepository(Get.find()));
    Get.lazyPut<TrackingRepository>(() => TrackingRepository(Get.find()));

    // Controllers
    Get.lazyPut<HomeController>(
      () => HomeController(
        storeRepository: Get.find(),
        orderRepository: Get.find(),
        locationService: Get.find(),
      ),
    );
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<StoreController>(
      () => StoreController(
        storeRepository: Get.find(),
        locationService: Get.find(),
      ),
    );
  }
}
