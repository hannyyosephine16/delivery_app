import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/Services/driver_service.dart';

/// Class data lokasi untuk menyimpan informasi lokasi pengiriman
class DeliveryLocation {
  final String address;
  final double latitude;
  final double longitude;
  final String? name;
  final String? placeId;

  DeliveryLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
    this.name,
    this.placeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'placeId': placeId,
    };
  }

  factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
    return DeliveryLocation(
      address: json['address'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      name: json['name'],
      placeId: json['placeId'],
    );
  }
}

class LocationService {
  // Singleton instance
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Timer for periodic location updates
  Timer? _locationUpdateTimer;

  // Current position
  Position? _currentPosition;

  // Status flags
  bool _isTracking = false;
  bool _isPermissionGranted = false;

  // For logging and debugging
  final bool _enableLogging = true;

  // Getters
  bool get isTracking => _isTracking;
  Position? get currentPosition => _currentPosition;

  // Konstanta untuk lokasi default dan kunci penyimpanan
  static const double defaultLat = 2.383333; // Institut Teknologi Del
  static const double defaultLng = 99.066667; // Institut Teknologi Del
  static const String defaultAddress = "Institut Teknologi Del, Laguboti, Toba";
  static const String _savedLocationsKey = 'saved_delivery_locations';
  static const String _lastLocationKey = 'last_delivery_location';

  // Initialize location service
  Future<bool> initialize() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _log('Location services are disabled');
      return false;
    }

    // Check location permission status
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _log('Location permissions denied');
        _isPermissionGranted = false;
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _log('Location permissions permanently denied');
      _isPermissionGranted = false;
      return false;
    }

    // Also check permission_handler for more granular control
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      _isPermissionGranted = status.isGranted;
    } else {
      _isPermissionGranted = true;
    }

    _log('Location service initialized, permission: $_isPermissionGranted');
    return _isPermissionGranted;
  }

  // Start tracking location at set intervals
  Future<bool> startTracking() async {
    if (_isTracking) {
      _log('Already tracking location');
      return true;
    }

    // Check for permissions
    if (!_isPermissionGranted) {
      bool initialized = await initialize();
      if (!initialized) {
        _log('Failed to initialize location service');
        return false;
      }
    }

    // Get current position first
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Send initial position to backend
      await _sendLocationUpdate();

      // Setup periodic location updates (every 10 seconds)
      _locationUpdateTimer =
          Timer.periodic(const Duration(seconds: 10), (_) => _updateLocation());

      _isTracking = true;
      _log('Started location tracking with timer');
      return true;
    } catch (e) {
      _log('Error starting location tracking: $e');
      return false;
    }
  }

  // Stop tracking location
  void stopTracking() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;
    _isTracking = false;
    _log('Location tracking stopped');
  }

  // Update location once (called from timer)
  Future<void> _updateLocation() async {
    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Update stored position
      _currentPosition = position;

      // Send to backend
      await _sendLocationUpdate();
    } catch (e) {
      _log('Error updating location: $e');
    }
  }

  // Send location update to backend
  Future<void> _sendLocationUpdate() async {
    if (_currentPosition == null) {
      _log('No position available to send');
      return;
    }

    try {
      await DriverService.updateDriverLocation({
        'latitude': _currentPosition!.latitude,
        'longitude': _currentPosition!.longitude,
      });

      _log(
          'Location sent to backend: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
    } catch (e) {
      _log('Error sending location to backend: $e');
    }
  }

  // Force a location update immediately (can be called manually)
  Future<bool> forceLocationUpdate() async {
    try {
      await _updateLocation();
      return true;
    } catch (e) {
      _log('Error forcing location update: $e');
      return false;
    }
  }

  // Show location permission dialog
  Future<void> showLocationPermissionDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Izin Lokasi Diperlukan'),
          content: const Text(
              'Untuk mengaktifkan status driver, aplikasi memerlukan akses lokasi. '
              'Mohon berikan izin lokasi di pengaturan perangkat Anda.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Buka Pengaturan'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  // Get last known position or current position
  Future<Position?> getLastKnownPosition() async {
    try {
      if (_currentPosition != null) {
        return _currentPosition;
      }

      // Try to get last known position if current isn't available
      Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        _currentPosition = lastKnown;
        return lastKnown;
      }

      // If no last known, get current
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return _currentPosition;
    } catch (e) {
      _log('Error getting position: $e');
      return null;
    }
  }

  // Helper for logging
  void _log(String message) {
    if (_enableLogging) {
      print('LocationService: $message');
    }
  }

  // Dispose resources
  void dispose() {
    stopTracking();
  }

  // =================== DELIVERY LOCATION METHODS ===================

  /// Mendapatkan lokasi pengiriman terakhir yang digunakan
  static Future<DeliveryLocation?> getLastDeliveryLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationJson = prefs.getString(_lastLocationKey);

      if (locationJson != null) {
        return DeliveryLocation.fromJson(jsonDecode(locationJson));
      }

      // Jika tidak ada lokasi tersimpan, kembalikan lokasi default
      return DeliveryLocation(
        address: defaultAddress,
        latitude: defaultLat,
        longitude: defaultLng,
        name: "Institut Teknologi Del",
      );
    } catch (e) {
      _instance._log('Error getting last delivery location: $e');
      return null;
    }
  }

  /// Menyimpan lokasi sebagai lokasi pengiriman terakhir
  static Future<void> saveLastDeliveryLocation(
      DeliveryLocation location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastLocationKey, jsonEncode(location.toJson()));
    } catch (e) {
      _instance._log('Error saving last delivery location: $e');
    }
  }

  /// Mendapatkan daftar lokasi tersimpan
  static Future<List<DeliveryLocation>> getSavedDeliveryLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = prefs.getString(_savedLocationsKey);

      if (locationsJson != null) {
        final List<dynamic> locations = jsonDecode(locationsJson);
        return locations.map((loc) => DeliveryLocation.fromJson(loc)).toList();
      }

      return [];
    } catch (e) {
      _instance._log('Error getting saved delivery locations: $e');
      return [];
    }
  }

  /// Menyimpan lokasi ke daftar favorit
  static Future<void> saveDeliveryLocation(DeliveryLocation location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<DeliveryLocation> savedLocations =
          await getSavedDeliveryLocations();

      // Cek apakah sudah ada (berdasarkan koordinat)
      final exists = savedLocations.any((loc) =>
          loc.latitude == location.latitude &&
          loc.longitude == location.longitude);

      if (!exists) {
        savedLocations.add(location);

        final locationsJson =
            jsonEncode(savedLocations.map((loc) => loc.toJson()).toList());

        await prefs.setString(_savedLocationsKey, locationsJson);
      }
    } catch (e) {
      _instance._log('Error saving delivery location: $e');
    }
  }

  /// Menghapus lokasi tersimpan
  static Future<void> removeDeliveryLocation(DeliveryLocation location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<DeliveryLocation> savedLocations =
          await getSavedDeliveryLocations();

      savedLocations.removeWhere((loc) =>
          loc.latitude == location.latitude &&
          loc.longitude == location.longitude);

      final locationsJson =
          jsonEncode(savedLocations.map((loc) => loc.toJson()).toList());

      await prefs.setString(_savedLocationsKey, locationsJson);
    } catch (e) {
      _instance._log('Error removing delivery location: $e');
    }
  }

  /// Mendapatkan alamat dari koordinat (reverse geocoding)
  static Future<String> getAddressFromCoordinates(
      double lat, double lng) async {
    try {
      // Implementasi sederhana - ini sebaiknya diganti dengan layanan geocoding yang sebenarnya
      // seperti Google Maps Geocoding API, Mapbox Geocoding API, atau layanan lainnya

      // Untuk contoh ini, kita akan mengembalikan placeholder
      // Dalam implementasi nyata, Anda akan memanggil API geocoding di sini
      return "Lokasi di $lat, $lng";
    } catch (e) {
      _instance._log('Error getting address from coordinates: $e');
      return "Lokasi tidak diketahui";
    }
  }

  /// Menghitung jarak antara dua titik (dalam kilometer) menggunakan rumus Haversine
  static double calculateDeliveryDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Radius Bumi dalam kilometer
    const double toRadians = 0.017453292519943295; // π/180

    // Konversi derajat ke radian
    final double lat1Rad = lat1 * toRadians;
    final double lon1Rad = lon1 * toRadians;
    final double lat2Rad = lat2 * toRadians;
    final double lon2Rad = lon2 * toRadians;

    // Perbedaan koordinat dalam radian
    final double dLat = lat2Rad - lat1Rad;
    final double dLon = lon2Rad - lon1Rad;

    // Rumus Haversine
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Jarak dalam kilometer
  }

  /// Mendapatkan lokasi pengiriman dari lokasi saat ini
  static Future<DeliveryLocation?> getDeliveryLocationFromCurrent() async {
    try {
      // Dapatkan posisi saat ini menggunakan metode getLastKnownPosition yang sudah ada
      Position? position = await _instance.getLastKnownPosition();

      if (position == null) {
        return null;
      }

      // Dapatkan alamat dari koordinat
      final address = await getAddressFromCoordinates(
          position.latitude, position.longitude);

      return DeliveryLocation(
        address: address,
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      _instance
          ._log('Error getting delivery location from current position: $e');
      return null;
    }
  }

  /// Mendapatkan lokasi pengiriman dari pencarian
  static Future<DeliveryLocation?> searchDeliveryLocation(String query) async {
    // Implementasi ini akan bergantung pada API geocoding yang Anda gunakan
    // Ini hanya contoh implementasi sederhana
    try {
      // Simulasi hasil pencarian
      // Dalam implementasi nyata, Anda akan memanggil API pencarian lokasi di sini
      if (query.toLowerCase().contains('del')) {
        return DeliveryLocation(
          address: "Institut Teknologi Del, Laguboti, Toba",
          latitude: 2.383333,
          longitude: 99.066667,
          name: "Institut Teknologi Del",
        );
      }

      // Contoh lokasi lainnya
      if (query.toLowerCase().contains('balige')) {
        return DeliveryLocation(
          address: "Balige, Toba, Sumatera Utara",
          latitude: 2.3329,
          longitude: 99.0559,
          name: "Balige",
        );
      }

      return null;
    } catch (e) {
      _instance._log('Error searching delivery location: $e');
      return null;
    }
  }

  /// Tampilkan dialog pilihan lokasi pengiriman
  static Future<DeliveryLocation?> showDeliveryLocationPicker(
      BuildContext context) async {
    // Dapatkan lokasi terakhir
    final lastLocation = await getLastDeliveryLocation();

    // Dapatkan lokasi tersimpan
    final savedLocations = await getSavedDeliveryLocations();

    // Tampilkan dialog dengan daftar lokasi
    return showDialog<DeliveryLocation>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pilih Lokasi Pengiriman'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                // Opsi untuk lokasi saat ini
                ListTile(
                  leading: Icon(Icons.my_location),
                  title: Text('Lokasi Saat Ini'),
                  onTap: () async {
                    final currentLocation =
                        await getDeliveryLocationFromCurrent();
                    Navigator.pop(context, currentLocation);
                  },
                ),

                // Opsi untuk lokasi terakhir jika ada
                if (lastLocation != null)
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('Lokasi Terakhir'),
                    subtitle: Text(lastLocation.address),
                    onTap: () {
                      Navigator.pop(context, lastLocation);
                    },
                  ),

                Divider(),

                // Opsi untuk lokasi tersimpan
                Text('Lokasi Tersimpan',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...savedLocations.map((location) => ListTile(
                      leading: Icon(Icons.star),
                      title: Text(location.name ?? location.address),
                      subtitle: Text(location.address),
                      onTap: () {
                        Navigator.pop(context, location);
                      },
                    )),

                Divider(),

                // Opsi untuk mencari lokasi baru
                ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Cari Lokasi'),
                  onTap: () {
                    Navigator.pop(context);
                    // Arahkan ke halaman pencarian lokasi
                    // Implementasi halaman pencarian lokasi tergantung pada struktur aplikasi Anda
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
