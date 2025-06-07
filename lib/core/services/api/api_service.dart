import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:del_pick/app/config/environment_config.dart';
import 'package:del_pick/core/constants/app_constants.dart';
import 'package:del_pick/core/services/local/storage_service.dart';
import 'package:del_pick/core/constants/storage_constants.dart';
import 'package:del_pick/core/interceptors/auth_interceptor.dart';
import 'package:del_pick/core/interceptors/error_interceptor.dart';
import 'package:del_pick/core/interceptors/logging_interceptor.dart';
import 'package:del_pick/core/interceptors/connectivity_interceptor.dart';

class ApiService extends getx.GetxService {
  late Dio _dio;
  final StorageService _storageService = getx.Get.find<StorageService>();

  Dio get dio => _dio;

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvironmentConfig.baseUrl,
        connectTimeout: Duration(seconds: AppConstants.connectionTimeout),
        receiveTimeout: Duration(seconds: AppConstants.apiTimeout),
        sendTimeout: Duration(seconds: AppConstants.apiTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status! < 500,
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Clear existing interceptors
    _dio.interceptors.clear();

    // Add interceptors in order
    if (EnvironmentConfig.enableLogging) {
      _dio.interceptors.add(LoggingInterceptor());
    }

    _dio.interceptors.add(ConnectivityInterceptor());
    _dio.interceptors.add(AuthInterceptor(_storageService));
    _dio.interceptors.add(ErrorInterceptor());
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Upload file
  Future<Response> uploadFile(
    String path,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(file.path, filename: fileName),
        if (data != null) ...data,
      });

      final response = await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Upload multiple files
  Future<Response> uploadFiles(
    String path,
    List<File> files, {
    String fieldName = 'files',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      Map<String, dynamic> formDataMap = {};

      for (int i = 0; i < files.length; i++) {
        String fileName = files[i].path.split('/').last;
        formDataMap['$fieldName[$i]'] = await MultipartFile.fromFile(
          files[i].path,
          filename: fileName,
        );
      }

      if (data != null) {
        formDataMap.addAll(data);
      }

      FormData formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Download file
  Future<Response> downloadFile(
    String path,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Set authentication token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Clear authentication token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Add custom header
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  // Remove custom header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  // Clear all custom headers
  void clearHeaders() {
    _dio.options.headers.clear();
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
  }

  // Update base URL (for environment switching)
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  // Update timeout settings
  void updateTimeout({
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) {
    if (connectTimeout != null) {
      _dio.options.connectTimeout = connectTimeout;
    }
    if (receiveTimeout != null) {
      _dio.options.receiveTimeout = receiveTimeout;
    }
    if (sendTimeout != null) {
      _dio.options.sendTimeout = sendTimeout;
    }
  }

  // Create cancel token
  CancelToken createCancelToken() {
    return CancelToken();
  }

  // Cancel request
  void cancelRequests(CancelToken cancelToken, [String? reason]) {
    cancelToken.cancel(reason);
  }

  // Check if request was cancelled
  bool isRequestCancelled(dynamic error) {
    return error is DioException && error.type == DioExceptionType.cancel;
  }

  // Retry request
  Future<Response> retryRequest(RequestOptions requestOptions) async {
    try {
      final response = await _dio.fetch(requestOptions);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get current auth token
  String? getAuthToken() {
    final authHeader = _dio.options.headers['Authorization'] as String?;
    if (authHeader != null && authHeader.startsWith('Bearer ')) {
      return authHeader.substring(7);
    }
    return null;
  }

  // Refresh configuration
  void refreshConfiguration() {
    _initializeDio();
  }
}
