import 'package:del_pick/core/services/local/storage_service.dart';
import 'package:del_pick/core/constants/storage_constants.dart';
import 'package:del_pick/data/models/auth/user_model.dart';

class AuthLocalDataSource {
  final StorageService _storageService;

  AuthLocalDataSource(this._storageService);

  Future<void> saveAuthToken(String token) async {
    await _storageService.writeString(StorageConstants.authToken, token);
    await _storageService.writeBool(StorageConstants.isLoggedIn, true);
    await _storageService.writeDateTime(
      StorageConstants.lastLoginTime,
      DateTime.now(),
    );
  }

  Future<String?> getAuthToken() async {
    return _storageService.readString(StorageConstants.authToken);
  }

  Future<void> saveUser(UserModel user) async {
    await _storageService.writeJson(StorageConstants.userId, user.toJson());
    await _storageService.writeString(StorageConstants.userRole, user.role);
    await _storageService.writeString(StorageConstants.userEmail, user.email);
    await _storageService.writeString(StorageConstants.userName, user.name);
    if (user.phone != null) {
      await _storageService.writeString(
        StorageConstants.userPhone,
        user.phone!,
      );
    }
    if (user.avatar != null) {
      await _storageService.writeString(
        StorageConstants.userAvatar,
        user.avatar!,
      );
    }
  }

  Future<UserModel?> getUser() async {
    final userData = _storageService.readJson(StorageConstants.userId);
    if (userData != null) {
      try {
        return UserModel.fromJson(userData);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storageService.writeString(
      StorageConstants.refreshToken,
      refreshToken,
    );
  }

  Future<String?> getRefreshToken() async {
    return _storageService.readString(StorageConstants.refreshToken);
  }

  Future<bool> isLoggedIn() async {
    return _storageService.readBoolWithDefault(
      StorageConstants.isLoggedIn,
      false,
    );
  }

  Future<DateTime?> getLastLoginTime() async {
    return _storageService.readDateTime(StorageConstants.lastLoginTime);
  }

  Future<void> clearAuthData() async {
    await _storageService.remove(StorageConstants.authToken);
    await _storageService.remove(StorageConstants.refreshToken);
    await _storageService.remove(StorageConstants.userId);
    await _storageService.remove(StorageConstants.userRole);
    await _storageService.remove(StorageConstants.userEmail);
    await _storageService.remove(StorageConstants.userName);
    await _storageService.remove(StorageConstants.userPhone);
    await _storageService.remove(StorageConstants.userAvatar);
    await _storageService.writeBool(StorageConstants.isLoggedIn, false);
    await _storageService.remove(StorageConstants.lastLoginTime);
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phone,
    String? avatar,
  }) async {
    final currentUser = await getUser();
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        name: name ?? currentUser.name,
        email: email ?? currentUser.email,
        phone: phone ?? currentUser.phone,
        avatar: avatar ?? currentUser.avatar,
      );
      await saveUser(updatedUser);
    }
  }
}
