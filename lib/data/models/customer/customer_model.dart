import 'package:delivery_app/data/models/auth/user_model.dart';

class CustomerModel {
  final int id;
  final int userId;
  final String? address;
  final UserModel? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomerModel({
    required this.id,
    required this.userId,
    this.address,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      address: json['address'] as String?,
      user:
          json['user'] != null
              ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
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
      'userId': userId,
      'address': address,
      'user': user?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  CustomerModel copyWith({
    int? id,
    int? userId,
    String? address,
    UserModel? user,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get name => user?.name ?? '';
  String get email => user?.email ?? '';
  String get phone => user?.phone ?? '';
  String? get avatar => user?.avatar;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CustomerModel{id: $id, userId: $userId, name: $name}';
  }
}
