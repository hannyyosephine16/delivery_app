class MenuItemModel {
  final int id;
  final String name;
  final double price;
  final String? description;
  final String? imageUrl;
  final int storeId;
  final int? quantity;
  final String? category;
  final bool isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl,
    required this.storeId,
    this.quantity,
    this.category,
    this.isAvailable = true,
    this.createdAt,
    this.updatedAt,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      storeId: json['storeId'] as int,
      quantity: json['quantity'] as int?,
      category: json['category'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
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
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'storeId': storeId,
      'quantity': quantity,
      'category': category,
      'isAvailable': isAvailable,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  MenuItemModel copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    int? storeId,
    int? quantity,
    String? category,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      storeId: storeId ?? this.storeId,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedPrice =>
      'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

  bool get isInStock => quantity == null || quantity! > 0;
  bool get canOrder => isAvailable && isInStock;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItemModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MenuItemModel{id: $id, name: $name, price: $price, storeId: $storeId}';
  }
}
