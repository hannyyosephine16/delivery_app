import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final RxBool _isConnected = true.obs;
  bool get isConnected => _isConnected.value;

  final Rx<ConnectivityResult> _connectionType = ConnectivityResult.wifi.obs;
  ConnectivityResult get connectionType => _connectionType.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _checkInitialConnection();
    _startListening();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> _checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _startListening() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Check if any of the results indicate a connection
    final isConnected =
        results.any((result) => result != ConnectivityResult.none);
    _isConnected.value = isConnected;

    // Set the primary connection type (prefer wifi, then mobile)
    if (results.contains(ConnectivityResult.wifi)) {
      _connectionType.value = ConnectivityResult.wifi;
    } else if (results.contains(ConnectivityResult.mobile)) {
      _connectionType.value = ConnectivityResult.mobile;
    } else if (results.contains(ConnectivityResult.ethernet)) {
      _connectionType.value = ConnectivityResult.ethernet;
    } else {
      _connectionType.value = ConnectivityResult.none;
    }

    // Optional: Print connection status for debugging
    print('Connection status: ${isConnected ? 'Connected' : 'Disconnected'}');
    print('Connection type: ${_connectionType.value}');
  }

  // Additional helper methods
  bool get isWifiConnected => _connectionType.value == ConnectivityResult.wifi;
  bool get isMobileConnected =>
      _connectionType.value == ConnectivityResult.mobile;
  bool get isEthernetConnected =>
      _connectionType.value == ConnectivityResult.ethernet;

  // Get readable connection type string
  String get connectionTypeString {
    switch (_connectionType.value) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
      default:
        return 'No Connection';
    }
  }

  // Force check connectivity (useful for pull-to-refresh scenarios)
  Future<void> forceCheckConnectivity() async {
    await _checkInitialConnection();
  }
}
