// lib/services/order_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'core/api_constants.dart';
import 'core/token_service.dart';
import 'image_service.dart';

class OrderService {
  // Place a new order
  static Future<Map<String, dynamic>> placeOrder(Map<String, dynamic> orderData) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData['data'];
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Order placement failed');
      }
    } catch (e) {
      print('Error placing order: $e');
      throw Exception('Failed to place order: $e');
    }
  }

  // Get order details by order ID
  static Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final String? token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/orders/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Process images in order data
        if (jsonData['data'] != null) {
          // Process store image if present
          if (jsonData['data']['store'] != null && jsonData['data']['store']['image'] != null) {
            jsonData['data']['store']['image'] = ImageService.getImageUrl(jsonData['data']['store']['image']);
          }

          // Process images in order items if present
          if (jsonData['data']['items'] != null && jsonData['data']['items'] is List) {
            for (var item in jsonData['data']['items']) {
              if (item['imageUrl'] != null) {
                item['imageUrl'] = ImageService.getImageUrl(item['imageUrl']);
              }
            }
          }
        }

        return jsonData['data'];
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load order');
      }
    } catch (e) {
      print('Error fetching order: $e');
      throw Exception('Failed to load order: $e');
    }
  }

  // Get all orders for the logged-in customer
  static Future<Map<String, dynamic>> getCustomerOrders() async {
    try {
      final String? token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/orders/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Process images in order data
        if (jsonData['data'] != null && jsonData['data']['orders'] is List) {
          for (var order in jsonData['data']['orders']) {
            // Process store image if present
            if (order['store'] != null && order['store']['image'] != null) {
              order['store']['image'] = ImageService.getImageUrl(order['store']['image']);
            }

            // Process images in order items if present
            if (order['items'] != null && order['items'] is List) {
              for (var item in order['items']) {
                if (item['imageUrl'] != null) {
                  item['imageUrl'] = ImageService.getImageUrl(item['imageUrl']);
                }
              }
            }
          }
        }

        return jsonData['data'];
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load customer orders');
      }
    } catch (e) {
      print('Error fetching customer orders: $e');
      throw Exception('Failed to load customer orders: $e');
    }
  }

  // Get all orders for the store owned by the logged-in user
  static Future<Map<String, dynamic>> getStoreOrders() async {
    try {
      final String? token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/orders/store'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Process images in order data as needed
        if (jsonData['data'] != null && jsonData['data']['orders'] is List) {
          for (var order in jsonData['data']['orders']) {
            // Process store image if present
            if (order['store'] != null && order['store']['image'] != null) {
              order['store']['image'] = ImageService.getImageUrl(order['store']['image']);
            }

            // Process images in order items if present
            if (order['items'] != null && order['items'] is List) {
              for (var item in order['items']) {
                if (item['imageUrl'] != null) {
                  item['imageUrl'] = ImageService.getImageUrl(item['imageUrl']);
                }
              }
            }
          }
        }

        return jsonData['data'];
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load store orders');
      }
    } catch (e) {
      print('Error fetching store orders: $e');
      throw Exception('Failed to load store orders: $e');
    }
  }

  // Process order by store (approve or reject)
  static Future<Map<String, dynamic>> processOrderByStore(String orderId, String action) async {
    try {
      final String? token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      if (action != 'approve' && action != 'reject') {
        throw Exception('Invalid action. Must be "approve" or "reject"');
      }

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/orders/$orderId/process'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'action': action,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData['data'];
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to process order');
      }
    } catch (e) {
      print('Error processing order: $e');
      throw Exception('Failed to process order: $e');
    }
  }

  // Cancel an order
  static Future<bool> cancelOrder(String orderId, String reason) async {
    try {
      final String? token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/orders/$orderId/cancel'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'reason': reason,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to cancel order');
      }
    } catch (e) {
      print('Error cancelling order: $e');
      throw Exception('Failed to cancel order: $e');
    }
  }

  // Create a review for store and/or driver
  static Future<bool> reviewOrder(String orderId, {int? storeRating, String? storeComment, int? driverRating, String? driverComment}) async {
    try {
      final String? token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final Map<String, dynamic> requestBody = {
        'orderId': orderId,
      };

      if (storeRating != null) {
        requestBody['store'] = {
          'rating': storeRating,
          'comment': storeComment
        };
      }

      if (driverRating != null) {
        requestBody['driver'] = {
          'rating': driverRating,
          'comment': driverComment
        };
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/orders/review'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to submit review');
      }
    } catch (e) {
      print('Error submitting review: $e');
      throw Exception('Failed to submit review: $e');
    }
  }

  // Update order status
  static Future<Map<String, dynamic>> updateOrderStatus(String orderId, String status) async {
    try {
      final String? token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/orders/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': orderId,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData['data'];
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update order status');
      }
    } catch (e) {
      print('Error updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }

  // Calculate estimated delivery time based on distance
  static int calculateEstimatedDeliveryTime(double distanceInKm) {
    // Using the same logic as the backend
    final double averageSpeed = 30; // km/h
    final double estimatedTime = (distanceInKm / averageSpeed) * 60; // Convert to minutes
    return estimatedTime.round();
  }

  // Get store by user ID (can be useful for frontend validation)
  static Future<Map<String, dynamic>> getStoreByUserId(String userId) async {
    try {
      final String? token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/stores/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Process store image if present
        if (jsonData['data'] != null && jsonData['data']['image'] != null) {
          jsonData['data']['image'] = ImageService.getImageUrl(jsonData['data']['image']);
        }

        return jsonData['data'];
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get store information');
      }
    } catch (e) {
      print('Error getting store by user ID: $e');
      throw Exception('Failed to get store information: $e');
    }
  }

  /// Membuat pesanan baru oleh customer
  static Future<Map<String, dynamic>> createCustomerOrder({
    required List<dynamic> cartItems,
    required int storeId,
    required String deliveryAddress,
    String? notes,
    double? latitude,
    double? longitude,
  })
  async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Transform cart items ke format yang diharapkan backend: {itemId, quantity}
      final List<Map<String, dynamic>> transformedItems = [];
      for (var item in cartItems) {
        transformedItems.add({
          'itemId': item.id,
          'quantity': item.quantity,
        });
      }

      // Persiapkan body request
      final requestBody = {
        'storeId': storeId,
        'items': transformedItems,
        'deliveryAddress': deliveryAddress,
        'notes': notes,
      };

      // Tambahkan koordinat jika tersedia
      if (latitude != null && longitude != null) {
        requestBody['latitude'] = latitude;
        requestBody['longitude'] = longitude;
      }

      // Lakukan request ke API
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      // Proses response
      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['data'] != null) {
          // Coba dapatkan detail order yang lengkap
          try {
            final String orderId = jsonData['data']['id'].toString();
            final orderDetails = await getOrderDetail(orderId);
            return orderDetails;
          } catch (e) {
            print('Error getting complete order details: $e');
            // Kembalikan data order dasar jika gagal mendapatkan detail
            return jsonData['data'];
          }
        }
        return jsonData['data'] ?? {};
      } else {
        _handleErrorResponse(response);
        return {};
      }
    } catch (e) {
      print('Error creating order: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  /// Mendapatkan menu items dari store tertentu
  static Future<List<dynamic>> getStoreMenuItems(String storeId) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/menu-items/store/$storeId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        List<dynamic> menuItems = [];

        if (jsonData['data'] != null && jsonData['data']['menuItems'] != null) {
          final List itemsJson = jsonData['data']['menuItems'];

          for (var json in itemsJson) {
            // Proses URL gambar jika ada
            if (json['imageUrl'] != null) {
              json['imageUrl'] = ImageService.getImageUrl(json['imageUrl']);
            }

            menuItems.add(json);
          }
        }

        return menuItems;
      } else {
        _handleErrorResponse(response);
        return [];
      }
    } catch (e) {
      print('Error fetching store menu items: $e');
      throw Exception('Failed to load store menu items: $e');
    }
  }

  /// Mendapatkan daftar toko yang tersedia
  static Future<List<dynamic>> getAvailableStores() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/stores'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        List<dynamic> stores = [];

        if (jsonData['data'] != null && jsonData['data']['stores'] != null) {
          final List storesJson = jsonData['data']['stores'];

          for (var json in storesJson) {
            // Proses URL gambar jika ada
            if (json['imageUrl'] != null || json['image'] != null) {
              String imageUrl = json['imageUrl'] ?? json['image'] ?? '';
              if (imageUrl.isNotEmpty) {
                json['imageUrl'] = ImageService.getImageUrl(imageUrl);
              }
            }

            stores.add(json);
          }
        }

        return stores;
      } else {
        _handleErrorResponse(response);
        return [];
      }
    } catch (e) {
      print('Error fetching available stores: $e');
      throw Exception('Failed to load available stores: $e');
    }
  }

  /// Mendapatkan detail toko
  static Future<Map<String, dynamic>> getStoreDetail(String storeId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/stores/$storeId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['data'] != null) {
          // Proses URL gambar jika ada
          if (jsonData['data']['imageUrl'] != null || jsonData['data']['image'] != null) {
            String imageUrl = jsonData['data']['imageUrl'] ?? jsonData['data']['image'] ?? '';
            if (imageUrl.isNotEmpty) {
              jsonData['data']['imageUrl'] = ImageService.getImageUrl(imageUrl);
            }
          }

          return jsonData['data'];
        }
        return {};
      } else {
        _handleErrorResponse(response);
        return {};
      }
    } catch (e) {
      print('Error fetching store detail: $e');
      throw Exception('Failed to load store detail: $e');
    }
  }

  /// Hitung biaya pengiriman berdasarkan jarak
  static double calculateDeliveryFee(double distanceInKm) {
    // Hitung biaya dengan mengalikan jarak dengan 2500
    double fee = distanceInKm * 2500;

    // Bulatkan ke 1000 terdekat untuk memudahkan pembayaran tunai
    return (fee / 1000).ceil() * 1000;
  }

  /// Kirim review untuk pesanan
  static Future<bool> submitOrderReview({
    required String orderId,
    required double storeRating,
    String? storeComment,
    double? driverRating,
    String? driverComment,
  }) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Persiapkan data review
      final Map<String, dynamic> reviewData = {
        'orderId': orderId,
      };

      // Tambahkan review toko jika ada
      if (storeRating > 0) {
        reviewData['store'] = {
          'rating': storeRating,
          'comment': storeComment ?? '',
        };
      }

      // Tambahkan review driver jika ada
      if (driverRating != null && driverRating > 0) {
        reviewData['driver'] = {
          'rating': driverRating,
          'comment': driverComment ?? '',
        };
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/orders/review'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(reviewData),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        _handleErrorResponse(response);
        return false;
      }
    } catch (e) {
      print('Error submitting review: $e');
      throw Exception('Failed to submit review: $e');
    }
  }

  /// Cek apakah pesanan sudah di-review
  static Future<bool> hasOrderBeenReviewed(String orderId) async {
    try {
      final orderDetails = await getOrderDetail(orderId);

      // Cek apakah ada review
      bool hasReviews = false;

      if (orderDetails['orderReviews'] != null &&
          orderDetails['orderReviews'] is List &&
          (orderDetails['orderReviews'] as List).isNotEmpty) {
        hasReviews = true;
      }

      if (orderDetails['driverReviews'] != null &&
          orderDetails['driverReviews'] is List &&
          (orderDetails['driverReviews'] as List).isNotEmpty) {
        hasReviews = true;
      }

      return hasReviews;
    } catch (e) {
      print('Error checking if order has been reviewed: $e');
      // Default ke false jika error
      return false;
    }
  }

  static Future<Map<String, dynamic>> getOrderDetail(String orderId) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/orders/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Process images in the response if needed
        if (jsonData['data'] != null) {
          _processOrderImages(jsonData['data']);
        }

        return jsonData['data'] ?? {};
      } else {
        _handleErrorResponse(response);
        return {};
      }
    } catch (e) {
      print('Error fetching order detail: $e');
      throw Exception('Failed to get order detail: $e');
    }
  }

  /// Helper method untuk memproses gambar dalam data order
  static void _processOrderImages(Map<String, dynamic> order) {
    // Process store image if present
    if (order['store'] != null) {
      if (order['store']['imageUrl'] != null) {
        order['store']['imageUrl'] = ImageService.getImageUrl(order['store']['imageUrl']);
      }
      if (order['store']['image'] != null) {
        order['store']['image'] = ImageService.getImageUrl(order['store']['image']);
      }
    }

    // Process customer avatar if present
    if (order['customer'] != null && order['customer']['avatar'] != null) {
      order['customer']['avatar'] = ImageService.getImageUrl(order['customer']['avatar']);
    }

    // Process driver avatar if present
    if (order['driver'] != null && order['driver']['avatar'] != null) {
      order['driver']['avatar'] = ImageService.getImageUrl(order['driver']['avatar']);
    }

    // Process order items if present
    if (order['items'] != null && order['items'] is List) {
      for (var item in order['items']) {
        if (item['imageUrl'] != null) {
          item['imageUrl'] = ImageService.getImageUrl(item['imageUrl']);
        }
      }
    }

    // Process order reviews if present
    if (order['orderReviews'] != null && order['orderReviews'] is List) {
      for (var review in order['orderReviews']) {
        if (review['user'] != null && review['user']['avatar'] != null) {
          review['user']['avatar'] = ImageService.getImageUrl(review['user']['avatar']);
        }
      }
    }

    // Process driver reviews if present
    if (order['driverReviews'] != null && order['driverReviews'] is List) {
      for (var review in order['driverReviews']) {
        if (review['user'] != null && review['user']['avatar'] != null) {
          review['user']['avatar'] = ImageService.getImageUrl(review['user']['avatar']);
        }
      }
    }
  }

  /// Helper method untuk menangani response error
  static void _handleErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Request failed with status ${response.statusCode}');
    } catch (e) {
      if (e is Exception && e.toString().contains('message')) {
        rethrow;
      }
      throw Exception('Request failed with status ${response.statusCode}: ${response.body}');
    }
  }
}