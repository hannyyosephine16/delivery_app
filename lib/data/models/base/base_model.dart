abstract class BaseModel {
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  @override
  String toString();
}

class ApiResponseModel<T> {
  final int statusCode;
  final String message;
  final T? data;
  final String? errors;
  final bool success;

  ApiResponseModel({
    required this.statusCode,
    required this.message,
    this.data,
    this.errors,
    bool? success,
  }) : success = success ?? (statusCode >= 200 && statusCode < 300);

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponseModel<T>(
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message'] as String,
      data:
          json['data'] != null && fromJsonT != null
              ? fromJsonT(json['data'])
              : json['data'] as T?,
      errors: json['errors'] as String?,
      success: json['success'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data,
      'errors': errors,
      'success': success,
    };
  }

  bool get isSuccess => success && statusCode >= 200 && statusCode < 300;
  bool get isError => !isSuccess;

  @override
  String toString() {
    return 'ApiResponseModel{statusCode: $statusCode, message: $message, success: $success}';
  }
}

class PaginatedResponse<T> {
  final List<T> data;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int limit;

  PaginatedResponse({
    required this.data,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      data:
          (json['data'] as List?)
              ?.map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalItems: json['totalItems'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      currentPage: json['currentPage'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'totalItems': totalItems,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'limit': limit,
    };
  }

  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;
  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;

  @override
  String toString() {
    return 'PaginatedResponse{totalItems: $totalItems, currentPage: $currentPage, totalPages: $totalPages}';
  }
}
