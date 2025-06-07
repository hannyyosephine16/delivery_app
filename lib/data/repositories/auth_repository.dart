import 'package:del_pick/data/providers/auth_provider.dart';
import 'package:del_pick/data/models/auth/user_model.dart';
import 'package:del_pick/core/utils/result.dart';

class AuthRepository {
  final AuthProvider _authProvider;

  AuthRepository(this._authProvider);

  Future<Result<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authProvider.login(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String role = 'customer',
  }) async {
    try {
      final result = await _authProvider.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role,
      );
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<UserModel>> getProfile() async {
    try {
      final result = await _authProvider.getProfile();
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<UserModel>> updateProfile({
    String? name,
    String? email,
    String? password,
    String? avatar,
  }) async {
    try {
      final result = await _authProvider.updateProfile(
        name: name,
        email: email,
        password: password,
        avatar: avatar,
      );
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> forgotPassword(String email) async {
    try {
      final result = await _authProvider.forgotPassword(email);
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final result = await _authProvider.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> logout() async {
    try {
      final result = await _authProvider.logout();
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}