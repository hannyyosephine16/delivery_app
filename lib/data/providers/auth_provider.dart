import 'package:del_pick/data/datasources/remote/auth_remote_datasource.dart';
import 'package:del_pick/data/datasources/local/auth_local_datasource.dart';
import 'package:del_pick/data/models/auth/user_model.dart';
import 'package:del_pick/core/utils/result.dart';

class AuthProvider {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthProvider({required this.remoteDataSource, required this.localDataSource});

  Future<Result<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save auth data locally
      if (result['token'] != null) {
        await localDataSource.saveAuthToken(result['token']);
        await localDataSource.saveUser(UserModel.fromJson(result['user']));
      }

      return Result.success(result);
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
      final result = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role,
      );

      // Save auth data locally
      if (result['token'] != null) {
        await localDataSource.saveAuthToken(result['token']);
        await localDataSource.saveUser(UserModel.fromJson(result['user']));
      }

      return Result.success(result);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<UserModel>> getProfile() async {
    try {
      final result = await remoteDataSource.getProfile();
      final user = UserModel.fromJson(result);

      // Update local cache
      await localDataSource.saveUser(user);

      return Result.success(user);
    } catch (e) {
      // Try to get from local cache if network fails
      try {
        final localUser = await localDataSource.getUser();
        if (localUser != null) {
          return Result.success(localUser);
        }
      } catch (_) {}

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
      final result = await remoteDataSource.updateProfile(
        name: name,
        email: email,
        password: password,
        avatar: avatar,
      );

      final user = UserModel.fromJson(result);

      // Update local cache
      await localDataSource.saveUser(user);

      return Result.success(user);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> logout() async {
    try {
      await remoteDataSource.logout();

      // Clear local data
      await localDataSource.clearAuthData();

      return Result.success(null);
    } catch (e) {
      // Clear local data even if remote call fails
      await localDataSource.clearAuthData();
      return Result.failure(e.toString());
    }
  }
}
