// lib/Services/cart_manager.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Models/menu_item.dart';
import '../Models/store.dart';

class CartManager with ChangeNotifier {
  List<MenuItem> _cartItems = [];
  StoreModel? _store;
  String? _deliveryAddress;
  double? _latitude;
  double? _longitude;
  String? _notes;

  // Getters
  List<MenuItem> get cartItems => _cartItems;
  StoreModel? get store => _store;
  String? get deliveryAddress => _deliveryAddress;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get notes => _notes;

  // Initialize from shared preferences if available
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString('cart_data');

      if (cartData != null && cartData.isNotEmpty) {
        final Map<String, dynamic> decodedData = jsonDecode(cartData);

        // Restore store data
        if (decodedData.containsKey('store') && decodedData['store'] != null) {
          _store = StoreModel.fromJson(decodedData['store']);
        }

        // Restore cart items
        if (decodedData.containsKey('items') && decodedData['items'] != null) {
          _cartItems = (decodedData['items'] as List)
              .map((item) => MenuItem.fromJson(item))
              .toList();
        }

        // Restore delivery address and coordinates
        _deliveryAddress = decodedData['deliveryAddress'];
        _latitude = decodedData['latitude'];
        _longitude = decodedData['longitude'];
        _notes = decodedData['notes'];
      }
    } catch (e) {
      print('Error initializing cart: $e');
      // Reset cart on error
      _cartItems = [];
      _store = null;
      _deliveryAddress = null;
      _latitude = null;
      _longitude = null;
      _notes = null;
    }
  }

  // Save cart data to shared preferences
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final Map<String, dynamic> cartData = {
        'store': _store?.toJson(),
        'items': _cartItems.map((item) => item.toJson()).toList(),
        'deliveryAddress': _deliveryAddress,
        'latitude': _latitude,
        'longitude': _longitude,
        'notes': _notes,
      };

      await prefs.setString('cart_data', jsonEncode(cartData));
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  // Add item to cart
  void addItem(MenuItem item) {
    // Check if store is set and matches item's store
    if (_store == null) {
      _store = StoreModel(
        id: item.storeId ?? 0,
        name: 'Store',
        address: '',
        openHours: '',
      );
    } else if (_store!.id != item.storeId && item.storeId != null) {
      // Items must be from the same store
      throw Exception('Cannot add items from different stores');
    }

    // Check if item already exists in cart
    final existingItemIndex = _cartItems.indexWhere((cartItem) => cartItem.id == item.id);

    if (existingItemIndex >= 0) {
      // Update quantity of existing item
      _cartItems[existingItemIndex] = _cartItems[existingItemIndex].copyWith(
        quantity: _cartItems[existingItemIndex].quantity + 1,
      );
    } else {
      // Add new item with quantity 1
      _cartItems.add(item.copyWith(quantity: 1));
    }

    notifyListeners();
    _saveCart();
  }

  // Remove item from cart
  void removeItem(int itemId) {
    _cartItems.removeWhere((item) => item.id == itemId);

    // If cart is empty, also clear store
    if (_cartItems.isEmpty) {
      _store = null;
    }

    notifyListeners();
    _saveCart();
  }

  // Update item quantity
  void updateItemQuantity(int itemId, int quantity) {
    final index = _cartItems.indexWhere((item) => item.id == itemId);

    if (index >= 0) {
      if (quantity <= 0) {
        // Remove item if quantity is 0 or less
        _cartItems.removeAt(index);
      } else {
        // Update quantity
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      }

      notifyListeners();
      _saveCart();
    }
  }

  // Set store for cart
  void setStore(StoreModel store) {
    // Only allow changing store if cart is empty
    if (_cartItems.isNotEmpty && _store != null && _store!.id != store.id) {
      throw Exception('Cannot change store while cart has items');
    }

    _store = store;
    notifyListeners();
    _saveCart();
  }

  // Set delivery address
  void setDeliveryAddress(String address, {double? latitude, double? longitude}) {
    _deliveryAddress = address;
    _latitude = latitude;
    _longitude = longitude;
    notifyListeners();
    _saveCart();
  }

  // Set notes
  void setNotes(String notes) {
    _notes = notes;
    notifyListeners();
    _saveCart();
  }

  // Calculate cart subtotal
  double get subtotal {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Get total item count
  int get itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Clear cart
  void clearCart() {
    _cartItems = [];
    _store = null;
    _deliveryAddress = null;
    _latitude = null;
    _longitude = null;
    _notes = null;
    notifyListeners();
    _saveCart();
  }
}