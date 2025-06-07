import 'package:del_pick/data/models/tracking/location_model.dart';

class TrackingInfoModel {
  final int orderId;
  final String status;
  final LocationModel? storeLocation;
  final LocationModel? driverLocation;
  final String deliveryAddress;
  final DateTime? estimatedDeliveryTime;
  final DriverTrackingInfo? driver;
  final String? message;

  TrackingInfoModel({
    required this.orderId,
    required this.status,
    this.storeLocation,
    this.driverLocation,
    required this.deliveryAddress,
    this.estimatedDeliveryTime,
    this.driver,
    this.message,
  });

  factory TrackingInfoModel.fromJson(Map<String, dynamic> json) {
    return TrackingInfoModel(
      orderId: json['orderId'] as int,
      status: json['status'] as String,
      storeLocation:
          json['storeLocation'] != null
              ? LocationModel.fromJson(
                json['storeLocation'] as Map<String, dynamic>,
              )
              : null,
      driverLocation:
          json['driverLocation'] != null
              ? LocationModel.fromJson(
                json['driverLocation'] as Map<String, dynamic>,
              )
              : null,
      deliveryAddress: json['deliveryAddress'] as String,
      estimatedDeliveryTime:
          json['estimatedDeliveryTime'] != null
              ? DateTime.parse(json['estimatedDeliveryTime'] as String)
              : null,
      driver:
          json['driver'] != null
              ? DriverTrackingInfo.fromJson(
                json['driver'] as Map<String, dynamic>,
              )
              : null,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'status': status,
      'storeLocation': storeLocation?.toJson(),
      'driverLocation': driverLocation?.toJson(),
      'deliveryAddress': deliveryAddress,
      'estimatedDeliveryTime': estimatedDeliveryTime?.toIso8601String(),
      'driver': driver?.toJson(),
      'message': message,
    };
  }

  TrackingInfoModel copyWith({
    int? orderId,
    String? status,
    LocationModel? storeLocation,
    LocationModel? driverLocation,
    String? deliveryAddress,
    DateTime? estimatedDeliveryTime,
    DriverTrackingInfo? driver,
    String? message,
  }) {
    return TrackingInfoModel(
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      storeLocation: storeLocation ?? this.storeLocation,
      driverLocation: driverLocation ?? this.driverLocation,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      driver: driver ?? this.driver,
      message: message ?? this.message,
    );
  }

  bool get hasDriver => driver != null;
  bool get hasDriverLocation => driverLocation != null;
  bool get hasStoreLocation => storeLocation != null;

  String get statusDisplayName {
    switch (status) {
      case 'preparing':
        return 'Sedang Disiapkan';
      case 'on_the_way':
        return 'Dalam Perjalanan';
      case 'delivered':
        return 'Terkirim';
      default:
        return status;
    }
  }

  String get estimatedTimeString {
    if (estimatedDeliveryTime == null) return '';
    return '${estimatedDeliveryTime!.hour}:${estimatedDeliveryTime!.minute.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'TrackingInfoModel{orderId: $orderId, status: $status, hasDriver: $hasDriver}';
  }
}

class DriverTrackingInfo {
  final int id;
  final String name;
  final String? phone;
  final String? vehicleType;
  final String? vehicleNumber;
  final double? rating;

  DriverTrackingInfo({
    required this.id,
    required this.name,
    this.phone,
    this.vehicleType,
    this.vehicleNumber,
    this.rating,
  });

  factory DriverTrackingInfo.fromJson(Map<String, dynamic> json) {
    return DriverTrackingInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      vehicleType: json['vehicleType'] as String?,
      vehicleNumber: json['vehicleNumber'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'rating': rating,
    };
  }

  String get displayRating => rating?.toStringAsFixed(1) ?? '0.0';

  @override
  String toString() {
    return 'DriverTrackingInfo{id: $id, name: $name, vehicle: $vehicleNumber}';
  }
}
