// lib/core/services/external/socket_service.dart - Fixed imports
import 'dart:async';
import 'package:get/get.dart' as getx;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:del_pick/app/config/environment_config.dart';
import 'package:del_pick/core/services/local/storage_service.dart';
import 'package:del_pick/core/constants/storage_constants.dart';

class SocketService extends getx.GetxService {
  IO.Socket? _socket;
  final StorageService _storageService = getx.Get.find<StorageService>();

  final getx.RxBool _isConnected = false.obs; // Fixed: Use getx.RxBool
  bool get isConnected => _isConnected.value;

  // Stream controllers for different event types
  final StreamController<Map<String, dynamic>> _orderUpdatesController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _driverLocationController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _driverRequestController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get orderUpdatesStream =>
      _orderUpdatesController.stream;
  Stream<Map<String, dynamic>> get driverLocationStream =>
      _driverLocationController.stream;
  Stream<Map<String, dynamic>> get driverRequestStream =>
      _driverRequestController.stream;

  @override
  void onInit() {
    super.onInit();
    _initSocket();
  }

  @override
  void onClose() {
    _disconnect();
    _orderUpdatesController.close();
    _driverLocationController.close();
    _driverRequestController.close();
    super.onClose();
  }

  void _initSocket() {
    final token = _storageService.readString(StorageConstants.authToken);

    _socket = IO.io(
      EnvironmentConfig.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableAutoConnect()
          .build(),
    );

    _setupEventListeners();
  }

  void _setupEventListeners() {
    _socket?.onConnect((_) {
      _isConnected.value = true;
      print('Socket connected');
    });

    _socket?.onDisconnect((_) {
      _isConnected.value = false;
      print('Socket disconnected');
    });

    _socket?.onConnectError((error) {
      print('Socket connection error: $error');
    });

    // Order events
    _socket?.on('order_updated', (data) {
      _orderUpdatesController.add(Map<String, dynamic>.from(data));
    });

    _socket?.on('order_status_changed', (data) {
      _orderUpdatesController.add(Map<String, dynamic>.from(data));
    });

    // Driver location events
    _socket?.on('driver_location_updated', (data) {
      _driverLocationController.add(Map<String, dynamic>.from(data));
    });

    // Driver request events
    _socket?.on('new_driver_request', (data) {
      _driverRequestController.add(Map<String, dynamic>.from(data));
    });

    _socket?.on('driver_request_accepted', (data) {
      _driverRequestController.add(Map<String, dynamic>.from(data));
    });

    _socket?.on('driver_request_rejected', (data) {
      _driverRequestController.add(Map<String, dynamic>.from(data));
    });
  }

  void connect() {
    if (_socket?.connected != true) {
      _socket?.connect();
    }
  }

  void _disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
  }

  // Emit events
  void joinOrderRoom(int orderId) {
    _socket?.emit('join_order', {'orderId': orderId});
  }

  void leaveOrderRoom(int orderId) {
    _socket?.emit('leave_order', {'orderId': orderId});
  }

  void joinDriverRoom(int driverId) {
    _socket?.emit('join_driver', {'driverId': driverId});
  }

  void leaveDriverRoom(int driverId) {
    _socket?.emit('leave_driver', {'driverId': driverId});
  }

  void updateDriverLocation(double latitude, double longitude) {
    _socket?.emit('update_location', {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  void driverStatusChanged(String status) {
    _socket?.emit('driver_status_changed', {'status': status});
  }

  // Reconnect with new token
  void reconnectWithToken(String token) {
    _disconnect();
    _socket = IO.io(
      EnvironmentConfig.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableAutoConnect()
          .build(),
    );
    _setupEventListeners();
  }
}
