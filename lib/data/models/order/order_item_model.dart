class OrderItemModel {
  final int id;
  final int orderId;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String?,
      notes: json['notes'] as String?,
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
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  OrderItemModel copyWith({
    int? id,
    int? orderId,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get totalPrice => price * quantity;

  String get formattedPrice =>
      'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

  String get formattedTotalPrice =>
      'Rp ${totalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'OrderItemModel{id: $id, name: $name, quantity: $quantity, price: $price}';
  }
}
