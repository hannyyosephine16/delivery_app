// lib/data/models/order/order_model.dart - Fixed null safety
import 'package:del_pick/data/models/auth/user_model.dart';
import 'package:del_pick/data/models/store/store_model.dart';
import 'order_item_model.dart';

class OrderModel {
  final int id;
  final String code;
  final String deliveryAddress;
  final double subtotal;
  final double serviceCharge;
  final double total;
  final String orderStatus;
  final String? deliveryStatus;
  final DateTime orderDate;
  final String? notes;
  final int customerId;
  final int? driverId;
  final int storeId;
  final DateTime? estimatedDeliveryTime;
  final List<OrderItemModel>? items;
  final StoreModel? store; // Made nullable to fix the error
  final UserModel? customer;
  final UserModel? driver;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.code,
    required this.deliveryAddress,
    required this.subtotal,
    required this.serviceCharge,
    required this.total,
    required this.orderStatus,
    this.deliveryStatus,
    required this.orderDate,
    this.notes,
    required this.customerId,
    this.driverId,
    required this.storeId,
    this.estimatedDeliveryTime,
    this.items,
    this.store, // Made nullable
    this.customer,
    this.driver,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      code: json['code'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      serviceCharge: (json['serviceCharge'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      orderStatus:
          json['order_status'] as String? ?? json['orderStatus'] as String,
      deliveryStatus:
          json['delivery_status'] as String? ??
          json['deliveryStatus'] as String?,
      orderDate: DateTime.parse(json['orderDate'] as String),
      notes: json['notes'] as String?,
      customerId: json['customerId'] as int,
      driverId: json['driverId'] as int?,
      storeId: json['storeId'] as int,
      estimatedDeliveryTime:
          json['estimatedDeliveryTime'] != null
              ? DateTime.parse(json['estimatedDeliveryTime'] as String)
              : null,
      items:
          json['items'] != null
              ? (json['items'] as List)
                  .map(
                    (item) =>
                        OrderItemModel.fromJson(item as Map<String, dynamic>),
                  )
                  .toList()
              : null,
      store:
          json['store'] != null
              ? StoreModel.fromJson(json['store'] as Map<String, dynamic>)
              : null,
      customer:
          json['customer'] != null
              ? UserModel.fromJson(json['customer'] as Map<String, dynamic>)
              : null,
      driver:
          json['driver'] != null
              ? UserModel.fromJson(json['driver'] as Map<String, dynamic>)
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
      'code': code,
      'deliveryAddress': deliveryAddress,
      'subtotal': subtotal,
      'serviceCharge': serviceCharge,
      'total': total,
      'order_status': orderStatus,
      'delivery_status': deliveryStatus,
      'orderDate': orderDate.toIso8601String(),
      'notes': notes,
      'customerId': customerId,
      'driverId': driverId,
      'storeId': storeId,
      'estimatedDeliveryTime': estimatedDeliveryTime?.toIso8601String(),
      'items': items?.map((item) => item.toJson()).toList(),
      'store': store?.toJson(),
      'customer': customer?.toJson(),
      'driver': driver?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  OrderModel copyWith({
    int? id,
    String? code,
    String? deliveryAddress,
    double? subtotal,
    double? serviceCharge,
    double? total,
    String? orderStatus,
    String? deliveryStatus,
    DateTime? orderDate,
    String? notes,
    int? customerId,
    int? driverId,
    int? storeId,
    DateTime? estimatedDeliveryTime,
    List<OrderItemModel>? items,
    StoreModel? store,
    UserModel? customer,
    UserModel? driver,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      code: code ?? this.code,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      subtotal: subtotal ?? this.subtotal,
      serviceCharge: serviceCharge ?? this.serviceCharge,
      total: total ?? this.total,
      orderStatus: orderStatus ?? this.orderStatus,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      orderDate: orderDate ?? this.orderDate,
      notes: notes ?? this.notes,
      customerId: customerId ?? this.customerId,
      driverId: driverId ?? this.driverId,
      storeId: storeId ?? this.storeId,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      items: items ?? this.items,
      store: store ?? this.store,
      customer: customer ?? this.customer,
      driver: driver ?? this.driver,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Status checks
  bool get isPending => orderStatus == 'pending';
  bool get isApproved => orderStatus == 'approved';
  bool get isPreparing => orderStatus == 'preparing';
  bool get isOnDelivery => orderStatus == 'on_delivery';
  bool get isDelivered => orderStatus == 'delivered';
  bool get isCancelled => orderStatus == 'cancelled';

  bool get isActive => isPending || isApproved || isPreparing || isOnDelivery;
  bool get isCompleted => isDelivered || isCancelled;
  bool get canCancel => isPending || isApproved;
  bool get canTrack => isPreparing || isOnDelivery;
  bool get canReview => isDelivered;

  // Formatted values
  String get formattedSubtotal =>
      'Rp ${subtotal.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

  String get formattedServiceCharge =>
      'Rp ${serviceCharge.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

  String get formattedTotal =>
      'Rp ${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

  String get formattedOrderDate {
    return '${orderDate.day}/${orderDate.month}/${orderDate.year} ${orderDate.hour}:${orderDate.minute.toString().padLeft(2, '0')}';
  }

  String get statusDisplayName {
    switch (orderStatus) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'approved':
        return 'Dikonfirmasi';
      case 'preparing':
        return 'Sedang Disiapkan';
      case 'on_delivery':
        return 'Dalam Pengiriman';
      case 'delivered':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return orderStatus;
    }
  }

  int get totalItems =>
      items?.fold(0, (sum, item) => sum! + item.quantity) ?? 0;

  // Fixed: Added null check for store
  String get storeName => store?.name ?? 'Unknown Store';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'OrderModel{id: $id, code: $code, status: $orderStatus, total: $total}';
  }
}
