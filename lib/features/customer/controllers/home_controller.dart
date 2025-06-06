// lib/features/customer/controllers/home_controller.dart

import 'package:get/get.dart';
import 'package:delivery_app/data/repositories/store_repository.dart';
import 'package:delivery_app/data/repositories/order_repository.dart';
import 'package:delivery_app/data/models/store/store_model.dart';
import 'package:delivery_app/data/models/order/order_model.dart';
import 'package:delivery_app/core/services/external/location_service.dart';
import 'package:delivery_app/core/errors/error_handler.dart';

class HomeController extends GetxController {
  final StoreRepository _storeRepository;
  final OrderRepository _orderRepository;
  final LocationService _locationService;

  HomeController({
    required StoreRepository storeRepository,
    required OrderRepository orderRepository,
    required LocationService locationService,
  }) : _storeRepository = storeRepository,
       _orderRepository = orderRepository,
       _locationService = locationService;

  // Observable state
  final RxBool _isLoading = false.obs;
  final RxList<StoreModel> _nearbyStores = <StoreModel>[].obs;
  final RxList<OrderModel> _recentOrders = <OrderModel>[].obs;
  final RxString _greeting = ''.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _hasError = false.obs;
  final RxBool _hasLocation = false.obs;
  final RxString _currentAddress = 'Getting location...'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<StoreModel> get nearbyStores => _nearbyStores;
  List<OrderModel> get recentOrders => _recentOrders;
  String get greeting => _greeting.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;
  bool get hasLocation => _hasLocation.value;
  String get currentAddress => _currentAddress.value;
  bool get hasStores => _nearbyStores.isNotEmpty;
  bool get hasOrders => _recentOrders.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _setGreeting();
    _getCurrentLocation();
    loadHomeData();
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      _greeting.value = 'Good Morning';
    } else if (hour < 17) {
      _greeting.value = 'Good Afternoon';
    } else {
      _greeting.value = 'Good Evening';
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        _hasLocation.value = true;
        // You might want to implement reverse geocoding here
        _currentAddress.value = 'Institut Teknologi Del';
      } else {
        _hasLocation.value = false;
        _currentAddress.value = 'Location not available';
      }
    } catch (e) {
      _hasLocation.value = false;
      _currentAddress.value = 'Location error';
    }
  }

  Future<void> loadHomeData() async {
    _isLoading.value = true;
    _hasError.value = false;
    _errorMessage.value = '';

    try {
      await Future.wait([_loadNearbyStores(), _loadRecentOrders()]);
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to load data';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadNearbyStores() async {
    try {
      final position = await _locationService.getCurrentLocation();

      if (position != null) {
        final result = await _storeRepository.getNearbyStores(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        if (result.isSuccess && result.data != null) {
          // Limit to 5 stores for home screen
          _nearbyStores.value = result.data!.take(5).toList();
        }
      } else {
        // Fallback to get all stores
        final result = await _storeRepository.getAllStores();
        if (result.isSuccess && result.data != null) {
          _nearbyStores.value = result.data!.take(5).toList();
        }
      }
    } catch (e) {
      // Handle error silently for now
    }
  }

  Future<void> _loadRecentOrders() async {
    try {
      final result = await _orderRepository.getOrdersByUser(
        params: {'limit': 3, 'page': 1},
      );

      if (result.isSuccess && result.data != null) {
        _recentOrders.value = result.data!.data;
      }
    } catch (e) {
      // Handle error silently for now
    }
  }

  Future<void> refreshData() async {
    await loadHomeData();
  }

  void navigateToStores() {
    Get.toNamed('/store_list');
  }

  void navigateToOrders() {
    Get.toNamed('/order_history');
  }

  void navigateToStoreDetail(int storeId) {
    Get.toNamed('/store_detail', arguments: {'storeId': storeId});
  }

  void navigateToOrderDetail(int orderId) {
    Get.toNamed('/order_detail', arguments: {'orderId': orderId});
  }

  void navigateToCart() {
    Get.toNamed('/cart');
  }

  void navigateToProfile() {
    Get.toNamed('/profile');
  }
}
