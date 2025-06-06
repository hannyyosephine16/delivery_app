import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_app/data/models/order/cart_item_model.dart';
import 'package:delivery_app/data/models/menu/menu_item_model.dart';
import 'package:delivery_app/data/models/store/store_model.dart';
import 'package:delivery_app/core/services/local/storage_service.dart';
import 'package:delivery_app/core/constants/storage_constants.dart';
import 'package:delivery_app/core/constants/app_constants.dart';

class CartController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Observable state
  final RxList<CartItemModel> _cartItems = <CartItemModel>[].obs;
  final RxInt _currentStoreId = 0.obs;
  final RxString _currentStoreName = ''.obs;
  final RxDouble _subtotal = 0.0.obs;
  final RxDouble _serviceCharge = 0.0.obs;
  final RxDouble _total = 0.0.obs;

  // Getters
  List<CartItemModel> get cartItems => _cartItems;
  int get currentStoreId => _currentStoreId.value;
  String get currentStoreName => _currentStoreName.value;
  double get subtotal => _subtotal.value;
  double get serviceCharge => _serviceCharge.value;
  double get total => _total.value;
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _cartItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
  }

  void _loadCartFromStorage() {
    try {
      final cartData = _storageService.readJsonList(StorageConstants.cartItems);
      final storeId = _storageService.readInt(StorageConstants.cartStoreId);
      final storeName = _storageService.readString('cart_store_name') ?? '';

      if (cartData != null && storeId != null) {
        _cartItems.value =
            cartData.map((json) => CartItemModel.fromJson(json)).toList();
        _currentStoreId.value = storeId;
        _currentStoreName.value = storeName;
        _calculateTotals();
      }
    } catch (e) {
      // If error loading, start with empty cart
      _clearCart();
    }
  }

  void _saveCartToStorage() {
    try {
      final cartData = _cartItems.map((item) => item.toJson()).toList();
      _storageService.writeJsonList(StorageConstants.cartItems, cartData);
      _storageService.writeInt(
        StorageConstants.cartStoreId,
        _currentStoreId.value,
      );
      _storageService.writeString('cart_store_name', _currentStoreName.value);
      _storageService.writeDouble(StorageConstants.cartTotal, _total.value);
      _storageService.writeDateTime(
        StorageConstants.cartUpdatedAt,
        DateTime.now(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to save cart');
    }
  }

  void _calculateTotals() {
    _subtotal.value = _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    _serviceCharge.value = _subtotal.value * AppConstants.serviceChargeRate;
    _total.value = _subtotal.value + _serviceCharge.value;
  }

  Future<bool> addToCart(
    MenuItemModel menuItem,
    StoreModel store, {
    int quantity = 1,
    String? notes,
  }) async {
    try {
      // Check if trying to add from different store
      if (_cartItems.isNotEmpty && _currentStoreId.value != store.id) {
        final shouldClear = await _showStoreConflictDialog(store.name);
        if (shouldClear) {
          _clearCart();
        } else {
          return false;
        }
      }

      // Set current store if cart is empty
      if (_cartItems.isEmpty) {
        _currentStoreId.value = store.id;
        _currentStoreName.value = store.name;
      }

      // Check if item already exists
      final existingIndex = _cartItems.indexWhere(
        (item) => item.menuItemId == menuItem.id,
      );

      if (existingIndex != -1) {
        // Update existing item
        final existingItem = _cartItems[existingIndex];
        _cartItems[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
          notes: notes ?? existingItem.notes,
        );
      } else {
        // Add new item
        final cartItem = CartItemModel.fromMenuItem(
          menuItemId: menuItem.id,
          storeId: store.id,
          name: menuItem.name,
          price: menuItem.price,
          quantity: quantity,
          imageUrl: menuItem.imageUrl,
          notes: notes,
        );
        _cartItems.add(cartItem);
      }

      _calculateTotals();
      _saveCartToStorage();

      Get.snackbar(
        'Success',
        '${menuItem.name} added to cart',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  void updateQuantity(int menuItemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(menuItemId);
      return;
    }

    final index = _cartItems.indexWhere(
      (item) => item.menuItemId == menuItemId,
    );

    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      _calculateTotals();
      _saveCartToStorage();
    }
  }

  void removeFromCart(int menuItemId) {
    _cartItems.removeWhere((item) => item.menuItemId == menuItemId);

    if (_cartItems.isEmpty) {
      _currentStoreId.value = 0;
      _currentStoreName.value = '';
    }

    _calculateTotals();
    _saveCartToStorage();

    Get.snackbar(
      'Removed',
      'Item removed from cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _clearCart() {
    _cartItems.clear();
    _currentStoreId.value = 0;
    _currentStoreName.value = '';
    _subtotal.value = 0.0;
    _serviceCharge.value = 0.0;
    _total.value = 0.0;

    _storageService.remove(StorageConstants.cartItems);
    _storageService.remove(StorageConstants.cartStoreId);
    _storageService.remove('cart_store_name');
    _storageService.remove(StorageConstants.cartTotal);
    _storageService.remove(StorageConstants.cartUpdatedAt);
  }

  void clearCart() {
    _clearCart();
    Get.snackbar(
      'Cart Cleared',
      'All items removed from cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<bool> _showStoreConflictDialog(String newStoreName) async {
    return await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Different Store'),
            content: Text(
              'Your cart contains items from $_currentStoreName. '
              'Adding items from $newStoreName will clear your current cart. '
              'Do you want to continue?',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Clear Cart'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void proceedToCheckout() {
    if (_cartItems.isEmpty) {
      Get.snackbar(
        'Empty Cart',
        'Please add items to cart before checkout',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.toNamed(
      '/checkout',
      arguments: {
        'cartItems': _cartItems,
        'storeId': _currentStoreId.value,
        'storeName': _currentStoreName.value,
        'subtotal': _subtotal.value,
        'serviceCharge': _serviceCharge.value,
        'total': _total.value,
      },
    );
  }

  // Helper methods for formatting
  String get formattedSubtotal => 'Rp ${_subtotal.value.toStringAsFixed(0)}';
  String get formattedServiceCharge =>
      'Rp ${_serviceCharge.value.toStringAsFixed(0)}';
  String get formattedTotal => 'Rp ${_total.value.toStringAsFixed(0)}';
}
