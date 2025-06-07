import 'package:get/get.dart';
import 'package:del_pick/data/repositories/tracking_repository.dart';
import 'package:del_pick/data/repositories/driver_repository.dart';
import 'package:del_pick/data/repositories/order_repository.dart';
import 'package:del_pick/data/providers/tracking_provider.dart';
import 'package:del_pick/data/providers/driver_provider.dart';
import 'package:del_pick/data/providers/order_provider.dart';
import 'package:del_pick/data/datasources/remote/driver_remote_datasource.dart';
import 'package:del_pick/data/datasources/remote/order_remote_datasource.dart';
import 'package:del_pick/data/datasources/remote/tracking_remote_datasource.dart';

// Import the controller file once it's created
// import 'package:del_pick/features/driver/controllers/driver_home_controller.dart';
// import 'package:del_pick/features/driver/controllers/driver_request_controller.dart';
// import 'package:del_pick/features/driver/controllers/delivery_controller.dart';
// import 'package:del_pick/features/driver/controllers/driver_location_controller.dart';
// import 'package:del_pick/features/driver/controllers/driver_orders_controller.dart';
// import 'package:del_pick/features/driver/controllers/driver_earnings_controller.dart';
// import 'package:del_pick/features/driver/controllers/driver_profile_controller.dart';

class DriverBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut<DriverRemoteDataSource>(
      () => DriverRemoteDataSource(Get.find()),
    );
    Get.lazyPut<OrderRemoteDataSource>(() => OrderRemoteDataSource(Get.find()));
    Get.lazyPut<TrackingRemoteDataSource>(
      () => TrackingRemoteDataSource(Get.find()),
    );

    // Providers
    Get.lazyPut<DriverProvider>(
      () => DriverProvider(remoteDataSource: Get.find()),
    );
    Get.lazyPut<OrderProvider>(
      () => OrderProvider(),
    );
    Get.lazyPut<TrackingProvider>(
      () => TrackingProvider(),
    );

    // Repositories
    Get.lazyPut<DriverRepository>(() => DriverRepository(Get.find()));
    Get.lazyPut<OrderRepository>(() => OrderRepository(Get.find()));
    Get.lazyPut<TrackingRepository>(() => TrackingRepository(Get.find()));

    // Controllers - uncomment when the controller files are created
    /*
    Get.lazyPut<DriverHomeController>(
      () => DriverHomeController(
        driverRepository: Get.find(),
        orderRepository: Get.find(),
        locationService: Get.find(),
      ),
    );
    Get.lazyPut<DriverRequestController>(
      () => DriverRequestController(
        driverRepository: Get.find(),
        orderRepository: Get.find(),
      ),
    );
    Get.lazyPut<DeliveryController>(
      () => DeliveryController(
        trackingRepository: Get.find(),
        orderRepository: Get.find(),
        locationService: Get.find(),
      ),
    );
    Get.lazyPut<DriverLocationController>(
      () => DriverLocationController(
        driverRepository: Get.find(),
        locationService: Get.find(),
      ),
    );
    Get.lazyPut<DriverOrdersController>(
      () => DriverOrdersController(Get.find()),
    );
    Get.lazyPut<DriverEarningsController>(
      () => DriverEarningsController(Get.find()),
    );
    Get.lazyPut<DriverProfileController>(
      () => DriverProfileController(Get.find()),
     */
  }
}
