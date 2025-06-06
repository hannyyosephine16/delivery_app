import 'package:get/get.dart';
import 'package:delivery_app/data/repositories/store_repository.dart';
import 'package:delivery_app/data/repositories/order_repository.dart';
import 'package:delivery_app/data/repositories/menu_repository.dart';

class StoreDashboardController extends GetxController {
  final StoreRepository storeRepository;
  final OrderRepository orderRepository;
  final MenuRepository menuRepository;

  StoreDashboardController({
    required this.storeRepository,
    required this.orderRepository,
    required this.menuRepository,
  });

  final RxBool _isLoading = false.obs;
  final RxInt _todayOrders = 0.obs;
  final RxDouble _todayRevenue = 0.0.obs;
  final RxInt _totalMenuItems = 0.obs;

  bool get isLoading => _isLoading.value;
  int get todayOrders => _todayOrders.value;
  double get todayRevenue => _todayRevenue.value;
  int get totalMenuItems => _totalMenuItems.value;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    _isLoading.value = true;
    try {
      // Load dashboard statistics
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      _todayOrders.value = 15;
      _todayRevenue.value = 750000;
      _totalMenuItems.value = 25;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data');
    } finally {
      _isLoading.value = false;
    }
  }
}

// lib/features/store/controllers/menu_management_controller.dart
class MenuManagementController extends GetxController {
  final MenuRepository menuRepository;

  MenuManagementController(this.menuRepository);

  final RxBool _isLoading = false.obs;
  final RxList _menuItems = [].obs;

  bool get isLoading => _isLoading.value;
  List get menuItems => _menuItems;

  @override
  void onInit() {
    super.onInit();
    loadMenuItems();
  }

  Future<void> loadMenuItems() async {
    _isLoading.value = true;
    try {
      // Load menu items from repository
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    } catch (e) {
      Get.snackbar('Error', 'Failed to load menu items');
    } finally {
      _isLoading.value = false;
    }
  }
}

// lib/features/store/controllers/add_menu_item_controller.dart
class AddMenuItemController extends GetxController {
  final MenuRepository menuRepository;

  AddMenuItemController(this.menuRepository);

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  Future<bool> createMenuItem(Map<String, dynamic> data) async {
    try {
      _isLoading.value = true;

      final result = await menuRepository.createMenuItem(data);

      if (result.isSuccess) {
        Get.snackbar('Success', 'Menu item created successfully');
        return true;
      } else {
        Get.snackbar('Error', result.message ?? 'Failed to create menu item');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}

// lib/features/store/controllers/store_orders_controller.dart
class StoreOrdersController extends GetxController {
  final OrderRepository orderRepository;

  StoreOrdersController(this.orderRepository);

  final RxBool _isLoading = false.obs;
  final RxList _orders = [].obs;

  bool get isLoading => _isLoading.value;
  List get orders => _orders;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    _isLoading.value = true;
    try {
      final result = await orderRepository.getOrdersByStore();

      if (result.isSuccess && result.data != null) {
        _orders.value = result.data!.data;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders');
    } finally {
      _isLoading.value = false;
    }
  }
}

// lib/features/store/controllers/store_analytics_controller.dart
class StoreAnalyticsController extends GetxController {
  final StoreRepository storeRepository;
  final OrderRepository orderRepository;

  StoreAnalyticsController({
    required this.storeRepository,
    required this.orderRepository,
  });

  final RxBool _isLoading = false.obs;
  final RxMap _analytics = {}.obs;

  bool get isLoading => _isLoading.value;
  Map get analytics => _analytics;

  @override
  void onInit() {
    super.onInit();
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    _isLoading.value = true;
    try {
      // Load analytics data
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    } catch (e) {
      Get.snackbar('Error', 'Failed to load analytics');
    } finally {
      _isLoading.value = false;
    }
  }
}

// lib/features/store/controllers/store_settings_controller.dart
class StoreSettingsController extends GetxController {
  final StoreRepository storeRepository;

  StoreSettingsController(this.storeRepository);

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  Future<void> updateStoreSettings(Map<String, dynamic> settings) async {
    try {
      _isLoading.value = true;
      // Update store settings
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      Get.snackbar('Success', 'Settings updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update settings');
    } finally {
      _isLoading.value = false;
    }
  }
}

// lib/features/store/controllers/store_profile_controller.dart
class StoreProfileController extends GetxController {
  final StoreRepository storeRepository;

  StoreProfileController(this.storeRepository);

  final RxBool _isLoading = false.obs;
  final RxMap _profile = {}.obs;

  bool get isLoading => _isLoading.value;
  Map get profile => _profile;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    _isLoading.value = true;
    try {
      // Load store profile
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      _isLoading.value = true;
      // Update store profile
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      Get.snackbar('Success', 'Profile updated successfully');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
