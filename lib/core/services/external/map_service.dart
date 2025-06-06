import 'dart:async';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart' as getx;
import 'package:delivery_app/core/services/external/location_service.dart';

class MapService extends getx.GetxService {
  final LocationService _locationService = getx.Get.find<LocationService>();

  // Get address from coordinates
  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}';
      }

      return 'Unknown location';
    } catch (e) {
      throw Exception('Failed to get address: $e');
    }
  }

  // Get coordinates from address
  Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations[0];
        return Position(
          latitude: location.latitude,
          longitude: location.longitude,
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

      return null;
    } catch (e) {
      throw Exception('Failed to get coordinates: $e');
    }
  }

  // Calculate distance between two points
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return _locationService.calculateDistance(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Calculate estimated time for delivery
  Duration calculateEstimatedDeliveryTime(double distanceInKm) {
    // Average speed for delivery: 25 km/h
    const averageSpeed = 25.0;
    final timeInHours = distanceInKm / averageSpeed;
    final timeInMinutes = (timeInHours * 60).round();

    // Add buffer time (10-20 minutes)
    final bufferTime = (distanceInKm * 2).round().clamp(10, 20);

    return Duration(minutes: timeInMinutes + bufferTime);
  }

  // Check if location is within delivery radius
  bool isWithinDeliveryRadius(
    double storeLatitude,
    double storeLongitude,
    double customerLatitude,
    double customerLongitude,
    double radiusInKm,
  ) {
    final distance = calculateDistance(
      storeLatitude,
      storeLongitude,
      customerLatitude,
      customerLongitude,
    );

    return distance <= radiusInKm;
  }

  // Get directions between two points (simplified)
  List<Position> getDirections(Position start, Position end) {
    // This is a simplified implementation
    // In a real app, you would use Google Directions API or similar
    return [start, end];
  }

  // Format distance for display
  String formatDistance(double distanceInKm) {
    if (distanceInKm < 1.0) {
      return '${(distanceInKm * 1000).round()} m';
    } else {
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }

  // Format duration for display
  String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  // Get map tile URL for static maps
  String getStaticMapUrl(
    double latitude,
    double longitude, {
    int zoom = 15,
    int width = 400,
    int height = 300,
  }) {
    // This would typically use Google Static Maps API or similar
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=$zoom&size=${width}x$height&key=YOUR_API_KEY';
  }

  // Convert coordinates to map bounds
  Map<String, double> getMapBounds(List<Position> positions) {
    if (positions.isEmpty) {
      return {};
    }

    double minLat = positions.first.latitude;
    double maxLat = positions.first.latitude;
    double minLng = positions.first.longitude;
    double maxLng = positions.first.longitude;

    for (Position position in positions) {
      minLat = math.min(minLat, position.latitude);
      maxLat = math.max(maxLat, position.latitude);
      minLng = math.min(minLng, position.longitude);
      maxLng = math.max(maxLng, position.longitude);
    }

    return {
      'minLatitude': minLat,
      'maxLatitude': maxLat,
      'minLongitude': minLng,
      'maxLongitude': maxLng,
    };
  }
}
