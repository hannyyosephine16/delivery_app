import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' as getx;
import 'package:delivery_app/app/config/app_config.dart';
import 'package:delivery_app/core/services/local/storage_service.dart';
import 'package:delivery_app/core/constants/storage_constants.dart';

class LocationService extends getx.GetxService {
  final StorageService _storageService = getx.Get.find<StorageService>();

  final getx.Rx<Position?> _currentPosition = getx.Rx<Position?>(null);
  StreamSubscription<Position>? _positionStreamSubscription;

  Position? get currentPosition => _currentPosition.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadLastKnownLocation();
  }

  @override
  void onClose() {
    stopLocationUpdates();
    super.onClose();
  }

  Future<void> _loadLastKnownLocation() async {
    final lat = _storageService.readDouble(StorageConstants.lastKnownLatitude);
    final lng = _storageService.readDouble(StorageConstants.lastKnownLongitude);

    if (lat != null && lng != null) {
      _currentPosition.value = Position(
        latitude: lat,
        longitude: lng,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }
  }

  Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    await _storageService.writeBool(
      StorageConstants.locationPermissionGranted,
      true,
    );
    return true;
  }

  Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await checkPermission();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      _currentPosition.value = position;
      await _saveLastKnownLocation(position);

      return position;
    } catch (e) {
      return null;
    }
  }

  Future<void> startLocationUpdates() async {
    final hasPermission = await checkPermission();
    if (!hasPermission) return;

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _currentPosition.value = position;
      _saveLastKnownLocation(position);
    });
  }

  void stopLocationUpdates() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  Future<void> _saveLastKnownLocation(Position position) async {
    await _storageService.writeDouble(
      StorageConstants.lastKnownLatitude,
      position.latitude,
    );
    await _storageService.writeDouble(
      StorageConstants.lastKnownLongitude,
      position.longitude,
    );
  }

  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
          startLatitude,
          startLongitude,
          endLatitude,
          endLongitude,
        ) /
        1000; // Convert to kilometers
  }

  bool isWithinDeliveryRadius(
    double storeLatitude,
    double storeLongitude,
    double customerLatitude,
    double customerLongitude,
  ) {
    final distance = calculateDistance(
      storeLatitude,
      storeLongitude,
      customerLatitude,
      customerLongitude,
    );
    return distance <= AppConfig.maxDeliveryRadius;
  }

  Position get defaultLocation => Position(
        latitude: AppConfig.defaultLatitude,
        longitude: AppConfig.defaultLongitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        speed: 0,
        headingAccuracy: 0,
        speedAccuracy: 0,
      );
}
