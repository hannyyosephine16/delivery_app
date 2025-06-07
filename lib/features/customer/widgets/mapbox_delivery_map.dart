// lib/features/customer/widgets/mapbox_delivery_map.dart
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:del_pick/app/themes/app_colors.dart';
class MapboxDeliveryMap extends StatefulWidget {
  final double storeLatitude;
  final double storeLongitude;
  final double customerLatitude;
  final double customerLongitude;
  final double? driverLatitude;
  final double? driverLongitude;
  final Function(double lat, double lng)? onMapTap;

  const MapboxDeliveryMap({
    super.key,
    required this.storeLatitude,
    required this.storeLongitude,
    required this.customerLatitude,
    required this.customerLongitude,
    this.driverLatitude,
    this.driverLongitude,
    this.onMapTap,
  });

  @override
  State<MapboxDeliveryMap> createState() => _MapboxDeliveryMapState();
}

class _MapboxDeliveryMapState extends State<MapboxDeliveryMap> {
  MapboxMap? _mapboxMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MapWidget(
          key: const ValueKey("mapWidget"),
          onMapCreated: _onMapCreated,
        ),
      ),
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _setupMap();
    _setupMapTapListener();
  }

  void _setupMapTapListener() {
    if (widget.onMapTap != null && _mapboxMap != null) {
      // Use the new Interactions API for map taps
      _mapboxMap!.addInteraction(
        TapInteraction.onMap((context) {
          final coordinates = context.point.coordinates;
          final lat = coordinates.lat.toDouble();
          final lng = coordinates.lng.toDouble();
          widget.onMapTap!(lat, lng);
        }),
      );
    }
  }

  Future<void> _setupMap() async {
    if (_mapboxMap == null) return;

    try {
      // Set initial camera position
      final centerLat = (widget.storeLatitude + widget.customerLatitude) / 2;
      final centerLng = (widget.storeLongitude + widget.customerLongitude) / 2;

      await _mapboxMap!.setCamera(
        CameraOptions(
          center: Point(coordinates: Position(centerLng, centerLat)),
          zoom: 13.0,
        ),
      );

      // Add markers
      await _addMarkers();

      // Fit bounds to show all markers
      await _fitBoundsToMarkers();
    } catch (e) {
      print('Error setting up map: $e');
    }
  }

  Future<void> _addMarkers() async {
    if (_mapboxMap == null) return;

    try {
      // Store marker (hijau)
      final storeManager =
          await _mapboxMap!.annotations.createPointAnnotationManager();
      await storeManager.create(
        PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(widget.storeLongitude, widget.storeLatitude),
          ),
          iconImage: "store-marker",
          iconSize: 1.5,
        ),
      );

      // Customer marker (biru)
      final customerManager =
          await _mapboxMap!.annotations.createPointAnnotationManager();
      await customerManager.create(
        PointAnnotationOptions(
          geometry: Point(
            coordinates:
                Position(widget.customerLongitude, widget.customerLatitude),
          ),
          iconImage: "customer-marker",
          iconSize: 1.5,
        ),
      );

      // Driver marker (merah) - jika ada
      if (widget.driverLatitude != null && widget.driverLongitude != null) {
        final driverManager =
            await _mapboxMap!.annotations.createPointAnnotationManager();
        await driverManager.create(
          PointAnnotationOptions(
            geometry: Point(
              coordinates:
                  Position(widget.driverLongitude!, widget.driverLatitude!),
            ),
            iconImage: "driver-marker",
            iconSize: 1.5,
          ),
        );
      }
    } catch (e) {
      print('Error adding markers: $e');
    }
  }

  Future<void> _fitBoundsToMarkers() async {
    if (_mapboxMap == null) return;

    try {
      final coordinates = [
        Position(widget.storeLongitude, widget.storeLatitude),
        Position(widget.customerLongitude, widget.customerLatitude),
      ];

      if (widget.driverLatitude != null && widget.driverLongitude != null) {
        coordinates
            .add(Position(widget.driverLongitude!, widget.driverLatitude!));
      }

      // Calculate bounds
      double minLat = coordinates
          .map((p) => p.lat.toDouble())
          .reduce((a, b) => a < b ? a : b);
      double maxLat = coordinates
          .map((p) => p.lat.toDouble())
          .reduce((a, b) => a > b ? a : b);
      double minLng = coordinates
          .map((p) => p.lng.toDouble())
          .reduce((a, b) => a < b ? a : b);
      double maxLng = coordinates
          .map((p) => p.lng.toDouble())
          .reduce((a, b) => a > b ? a : b);

      // Add padding
      const padding = 0.005;
      minLat -= padding;
      maxLat += padding;
      minLng -= padding;
      maxLng += padding;

      // Create bounds
      final bounds = CoordinateBounds(
        southwest: Point(coordinates: Position(minLng, minLat)),
        northeast: Point(coordinates: Position(maxLng, maxLat)),
        infiniteBounds: false,
      );

      // Fit camera to bounds
      await _mapboxMap!.setBounds(
        CameraBoundsOptions(
          bounds: bounds,
          maxZoom: 15.0,
          minZoom: 10.0,
        ),
      );
    } catch (e) {
      print('Error fitting bounds: $e');
    }
  }

  Future<void> updateDriverLocation(double latitude, double longitude) async {
    // Update driver marker position
    // Implementation for real-time driver position updates
    if (_mapboxMap != null) {
      try {
        // Remove existing driver marker and add new one
        // This is a simplified approach - in production you'd want to update the existing marker
        await _addMarkers();
      } catch (e) {
        print('Error updating driver location: $e');
      }
    }
  }
}

// Widget untuk menampilkan info delivery
class DeliveryMapInfo extends StatelessWidget {
  final String storeName;
  final String customerAddress;
  final String? estimatedTime;
  final double? distance;

  const DeliveryMapInfo({
    super.key,
    required this.storeName,
    required this.customerAddress,
    this.estimatedTime,
    this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store info
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  storeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Customer info
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  customerAddress,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          if (distance != null || estimatedTime != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (distance != null)
                  Column(
                    children: [
                      const Icon(Icons.straighten,
                          size: 20, color: AppColors.primary),
                      const SizedBox(height: 4),
                      Text(
                        '${distance!.toStringAsFixed(1)} km',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                if (estimatedTime != null)
                  Column(
                    children: [
                      const Icon(Icons.access_time,
                          size: 20, color: AppColors.primary),
                      const SizedBox(height: 4),
                      Text(
                        estimatedTime!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
