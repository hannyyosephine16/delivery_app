import 'package:get/get.dart';
import 'package:del_pick/data/repositories/auth_repository.dart';
import 'package:del_pick/data/models/auth/user_model.dart';
import 'package:del_pick/core/constants/app_constants.dart';
import 'package:del_pick/app/routes/app_routes.dart';
import 'package:del_pick/core/services/local/storage_service.dart';
import 'package:del_pick/core/constants/storage_constants.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final StorageService _storageService = Get.find<StorageService>();

  AuthController(this._authRepository);

  // Observable variables
  final RxBool _isLoading = false.obs;
  final RxBool _isLoggedIn = false.obs;
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxString _userRole = ''.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;
  UserModel? get currentUser => _currentUser.value;
  String get userRole => _userRole.value;

  bool get isCustomer => userRole == AppConstants.roleCustomer;
  bool get isDriver => userRole == AppConstants.roleDriver;
  bool get isStore => userRole == AppConstants.roleStore;
  bool get isAdmin => userRole == AppConstants.roleAdmin;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      _isLoading.value = true;

      final isLoggedIn = _storageService.readBoolWithDefault(
        StorageConstants.isLoggedIn,
        false,
      );

      if (isLoggedIn) {
        final token = _storageService.readString(StorageConstants.authToken);
        final role = _storageService.readString(StorageConstants.userRole);

        if (token != null && token.isNotEmpty && role != null) {
          _isLoggedIn.value = true;
          _userRole.value = role;

          // Try to get fresh user data
          await _loadUserProfile();
        } else {
          await _clearAuthData();
        }
      }
    } catch (e) {
      await _clearAuthData();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final result = await _authRepository.getProfile();

      if (result.isSuccess && result.data != null) {
        _currentUser.value = result.data;
        _userRole.value = result.data!.role;
      } else {
        // If profile fetch fails, clear auth data
        await _clearAuthData();
      }
    } catch (e) {
      // If error occurs, try to use cached user data
      final userData = _storageService.readJson(StorageConstants.userId);
      if (userData != null) {
        try {
          _currentUser.value = UserModel.fromJson(userData);
        } catch (e) {
          await _clearAuthData();
        }
      }
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      _isLoading.value = true;

      final result = await _authRepository.login(
        email: email,
        password: password,
      );

      if (result.isSuccess && result.data != null) {
        final data = result.data!;
        final user = UserModel.fromJson(data['user']);

        _currentUser.value = user;
        _userRole.value = user.role;
        _isLoggedIn.value = true;

        // Navigate based on user role
        _navigateBasedOnRole(user.role);

        Get.snackbar(
          'Success',
          'Login successful',
          snackPosition: SnackPosition.TOP,
        );

        return true;
      } else {
        Get.snackbar(
          'Error',
          result.message ?? 'Login failed',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during login',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String role = AppConstants.roleCustomer,
  }) async {
    try {
      _isLoading.value = true;

      final result = await _authRepository.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role,
      );

      if (result.isSuccess && result.data != null) {
        final data = result.data!;
        final user = UserModel.fromJson(data['user']);

        _currentUser.value = user;
        _userRole.value = user.role;
        _isLoggedIn.value = true;

        // Navigate based on user role
        _navigateBasedOnRole(user.role);

        Get.snackbar(
          'Success',
          'Registration successful',
          snackPosition: SnackPosition.TOP,
        );

        return true;
      } else {
        Get.snackbar(
          'Error',
          result.message ?? 'Registration failed',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during registration',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? email,
    String? password,
    String? avatar,
  }) async {
    try {
      _isLoading.value = true;

      final result = await _authRepository.updateProfile(
        name: name,
        email: email,
        password: password,
        avatar: avatar,
      );

      if (result.isSuccess && result.data != null) {
        _currentUser.value = result.data;

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.TOP,
        );

        return true;
      } else {
        Get.snackbar(
          'Error',
          result.message ?? 'Update failed',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during update',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      _isLoading.value = true;

      final result = await _authRepository.forgotPassword(email);

      if (result.isSuccess) {
        Get.snackbar(
          'Success',
          'Password reset email sent',
          snackPosition: SnackPosition.TOP,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          result.message ?? 'Failed to send reset email',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      _isLoading.value = true;

      final result = await _authRepository.resetPassword(
        token: token,
        newPassword: newPassword,
      );

      if (result.isSuccess) {
        Get.snackbar(
          'Success',
          'Password reset successfully',
          snackPosition: SnackPosition.TOP,
        );

        // Navigate to login
        Get.offAllNamed(Routes.LOGIN);
        return true;
      } else {
        Get.snackbar(
          'Error',
          result.message ?? 'Password reset failed',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading.value = true;

      // Call API logout (optional, continue even if it fails)
      await _authRepository.logout();

      // Clear local data
      await _clearAuthData();

      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.TOP,
      );

      // Navigate to login
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      // Still clear local data even if API call fails
      await _clearAuthData();
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _clearAuthData() async {
    _currentUser.value = null;
    _userRole.value = '';
    _isLoggedIn.value = false;

    // Clear storage
    await _storageService.remove(StorageConstants.authToken);
    await _storageService.remove(StorageConstants.refreshToken);
    await _storageService.remove(StorageConstants.userId);
    await _storageService.remove(StorageConstants.userRole);
    await _storageService.remove(StorageConstants.userEmail);
    await _storageService.remove(StorageConstants.userName);
    await _storageService.remove(StorageConstants.userPhone);
    await _storageService.remove(StorageConstants.userAvatar);
    await _storageService.writeBool(StorageConstants.isLoggedIn, false);
  }

  void _navigateBasedOnRole(String role) {
    switch (role) {
      case AppConstants.roleCustomer:
        Get.offAllNamed(Routes.CUSTOMER_HOME);
        break;
      case AppConstants.roleDriver:
        Get.offAllNamed(Routes.DRIVER_HOME);
        break;
      case AppConstants.roleStore:
        Get.offAllNamed(Routes.STORE_DASHBOARD);
        break;
      case AppConstants.roleAdmin:
        Get.offAllNamed(Routes.ADMIN_DASHBOARD);
        break;
      default:
        Get.offAllNamed(Routes.LOGIN);
    }
  }

  // Quick access methods
  String get userName => currentUser?.name ?? '';
  String get userEmail => currentUser?.email ?? '';
  String? get userAvatar => currentUser?.avatar;
  String? get userPhone => currentUser?.phone;

  // Check if user can perform certain actions
  bool canAccessCustomerFeatures() => isCustomer;
  bool canAccessDriverFeatures() => isDriver;
  bool canAccessStoreFeatures() => isStore;
  bool canAccessAdminFeatures() => isAdmin;
}
