// lib/data/models/tracking/location_model.dart - Fixed math imports
import 'dart:math' as math; // Added proper math import

class LocationModel {
  final double latitude;
  final double longitude;
  final String? address;
  final DateTime? timestamp;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
    this.timestamp,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      timestamp:
          json['timestamp'] != null
              ? DateTime.parse(json['timestamp'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    DateTime? timestamp,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Calculate distance to another location in kilometers
  double distanceTo(LocationModel other) {
    const double earthRadius = 6371;

    final double lat1Rad = latitude * (math.pi / 180);
    final double lat2Rad = other.latitude * (math.pi / 180);
    final double deltaLatRad = (other.latitude - latitude) * (math.pi / 180);
    final double deltaLonRad = (other.longitude - longitude) * (math.pi / 180);

    final double a =
        math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLonRad / 2) *
            math.sin(deltaLonRad / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  String get coordinatesString => '$latitude, $longitude';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return 'LocationModel{latitude: $latitude, longitude: $longitude, address: $address}';
  }
}
