import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final RxBool _isConnected = true.obs;
  bool get isConnected => _isConnected.value;

  final RxList<ConnectivityResult> _connectionTypes =
      <ConnectivityResult>[].obs;
  List<ConnectivityResult> get connectionTypes => _connectionTypes.value;

  // Get the primary connection type (first non-none result)
  ConnectivityResult get primaryConnectionType {
    return _connectionTypes.firstWhere(
      (result) => result != ConnectivityResult.none,
      orElse: () => ConnectivityResult.none,
    );
  }

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
    // Update the connection types list
    _connectionTypes.value = results;

    // Check if any result indicates a connection (not none)
    final isConnected =
        results.any((result) => result != ConnectivityResult.none);
    _isConnected.value = isConnected;

    // Optional: Print connection status for debugging
    print('Connection status: ${isConnected ? 'Connected' : 'Disconnected'}');
    print('Connection types: ${results.join(", ")}');
    print('Primary connection type: ${primaryConnectionType}');
  }

  // Helper methods for checking specific connection types
  bool get isWifiConnected =>
      _connectionTypes.contains(ConnectivityResult.wifi);
  bool get isMobileConnected =>
      _connectionTypes.contains(ConnectivityResult.mobile);
  bool get isEthernetConnected =>
      _connectionTypes.contains(ConnectivityResult.ethernet);
  bool get isVpnConnected => _connectionTypes.contains(ConnectivityResult.vpn);
  bool get isBluetoothConnected =>
      _connectionTypes.contains(ConnectivityResult.bluetooth);

  // Get readable connection type string for primary connection
  String get primaryConnectionTypeString {
    switch (primaryConnectionType) {
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

  // Get all connection types as readable strings
  List<String> get connectionTypeStrings {
    return _connectionTypes.map((result) {
      switch (result) {
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
    }).toList();
  }

  // Get a combined connection string
  String get connectionStatusString {
    if (!isConnected) return 'No Connection';
    if (_connectionTypes.length == 1) return primaryConnectionTypeString;
    return connectionTypeStrings.join(' + ');
  }

  // Force check connectivity (useful for pull-to-refresh scenarios)
  Future<void> forceCheckConnectivity() async {
    await _checkInitialConnection();
  }
}
