import 'package:del_pick/data/models/order/order_model.dart';
import 'package:del_pick/data/models/driver/driver_model.dart';

class DriverRequestModel {
  final int id;
  final int orderId;
  final int driverId;
  final String status;
  final OrderModel? order;
  final DriverModel? driver;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DriverRequestModel({
    required this.id,
    required this.orderId,
    required this.driverId,
    required this.status,
    this.order,
    this.driver,
    this.createdAt,
    this.updatedAt,
  });

  factory DriverRequestModel.fromJson(Map<String, dynamic> json) {
    return DriverRequestModel(
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      driverId: json['driverId'] as int,
      status: json['status'] as String,
      order:
          json['order'] != null
              ? OrderModel.fromJson(json['order'] as Map<String, dynamic>)
              : null,
      driver:
          json['driver'] != null
              ? DriverModel.fromJson(json['driver'] as Map<String, dynamic>)
              : null,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'driverId': driverId,
      'status': status,
      'order': order?.toJson(),
      'driver': driver?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  DriverRequestModel copyWith({
    int? id,
    int? orderId,
    int? driverId,
    String? status,
    OrderModel? order,
    DriverModel? driver,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DriverRequestModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      driverId: driverId ?? this.driverId,
      status: status ?? this.status,
      order: order ?? this.order,
      driver: driver ?? this.driver,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Status checks
  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
  bool get isExpired => status == 'expired';
  bool get isCompleted => status == 'completed';

  bool get isActive => isPending || isAccepted;
  bool get canRespond => isPending;
  bool get canAccept => isPending;
  bool get canReject => isPending;

  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'Menunggu Respons';
      case 'accepted':
        return 'Diterima';
      case 'rejected':
        return 'Ditolak';
      case 'expired':
        return 'Kedaluwarsa';
      case 'completed':
        return 'Selesai';
      default:
        return status;
    }
  }

  String get orderCode => order?.code ?? '';
  String get storeName => order?.store?.name ?? '';
  String get customerName => order?.customer?.name ?? '';
  double get orderTotal => order?.total ?? 0.0;

  String get formattedCreatedAt {
    if (createdAt == null) return '';
    return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year} ${createdAt!.hour}:${createdAt!.minute.toString().padLeft(2, '0')}';
  }

  Duration? get timeElapsed {
    if (createdAt == null) return null;
    return DateTime.now().difference(createdAt!);
  }

  String get timeElapsedString {
    final elapsed = timeElapsed;
    if (elapsed == null) return '';

    if (elapsed.inMinutes < 1) {
      return 'Baru saja';
    } else if (elapsed.inMinutes < 60) {
      return '${elapsed.inMinutes} menit yang lalu';
    } else if (elapsed.inHours < 24) {
      return '${elapsed.inHours} jam yang lalu';
    } else {
      return '${elapsed.inDays} hari yang lalu';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverRequestModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DriverRequestModel{id: $id, orderId: $orderId, driverId: $driverId, status: $status}';
  }
}
