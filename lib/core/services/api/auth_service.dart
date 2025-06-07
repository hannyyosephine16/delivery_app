// lib/core/services/api/auth_service.dart
import 'package:dio/dio.dart';
import 'package:del_pick/core/services/api/api_service.dart';
import 'package:del_pick/core/constants/api_endpoints.dart';

class AuthApiService {
  final ApiService _apiService;

  AuthApiService(this._apiService);

  Future<Response> login(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.login, data: data);
  }

  Future<Response> register(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.register, data: data);
  }

  Future<Response> getProfile() async {
    return await _apiService.get(ApiEndpoints.profile);
  }

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    return await _apiService.put(ApiEndpoints.updateProfile, data: data);
  }

  Future<Response> forgotPassword(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.forgotPassword, data: data);
  }

  Future<Response> resetPassword(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.resetPassword, data: data);
  }

  Future<Response> logout() async {
    return await _apiService.post(ApiEndpoints.logout);
  }
}
