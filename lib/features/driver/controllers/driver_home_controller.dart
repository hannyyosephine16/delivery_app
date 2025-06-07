// Driver Home Controller
import 'package:get/get.dart';
import 'package:del_pick/data/repositories/driver_repository.dart';
import 'package:del_pick/data/repositories/order_repository.dart';
import 'package:del_pick/core/services/external/location_service.dart';

import '../../../data/repositories/tracking_repository.dart';

class DriverHomeController extends GetxController {
  final DriverRepository driverRepository;
  final OrderRepository orderRepository;
  final LocationService locationService;

  DriverHomeController({
    required this.driverRepository,
    required this.orderRepository,
    required this.locationService,
  });

  final RxBool _isOnline = false.obs;
  bool get isOnline => _isOnline.value;

  void toggleOnlineStatus() {
    _isOnline.value = !_isOnline.value;
    // Update driver status in backend
  }
}

// Driver Request Controller
class DriverRequestController extends GetxController {
  final DriverRepository driverRepository;
  final OrderRepository orderRepository;

  DriverRequestController({
    required this.driverRepository,
    required this.orderRepository,
  });

  final RxList _requests = [].obs;
  List get requests => _requests;

  @override
  void onInit() {
    super.onInit();
    loadRequests();
  }

  void loadRequests() {
    // Load driver requests
  }
}

// Delivery Controller
class DeliveryController extends GetxController {
  final TrackingRepository trackingRepository;
  final OrderRepository orderRepository;
  final LocationService locationService;

  DeliveryController({
    required this.trackingRepository,
    required this.orderRepository,
    required this.locationService,
  });

  final RxString _currentOrderId = ''.obs;
  String get currentOrderId => _currentOrderId.value;
}

// Driver Location Controller
class DriverLocationController extends GetxController {
  final DriverRepository driverRepository;
  final LocationService locationService;

  DriverLocationController({
    required this.driverRepository,
    required this.locationService,
  });

  void updateLocation() {
    // Update driver location
  }
}

// Driver Orders Controller
class DriverOrdersController extends GetxController {
  final OrderRepository orderRepository;

  DriverOrdersController(this.orderRepository);

  final RxList _orders = [].obs;
  List get orders => _orders;
}

// Driver Earnings Controller
class DriverEarningsController extends GetxController {
  final DriverRepository driverRepository;

  DriverEarningsController(this.driverRepository);

  final RxDouble _totalEarnings = 0.0.obs;
  double get totalEarnings => _totalEarnings.value;
}

// Driver Profile Controller
class DriverProfileController extends GetxController {
  final DriverRepository driverRepository;

  DriverProfileController(this.driverRepository);

  final RxMap _profile = {}.obs;
  Map get profile => _profile;
}
