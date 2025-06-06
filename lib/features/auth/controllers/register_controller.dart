import 'package:get/get.dart';
import 'package:delivery_app/data/repositories/auth_repository.dart';
import 'package:delivery_app/core/constants/app_constants.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepository;

  RegisterController(this._authRepository);

  final RxBool _isLoading = false.obs;
  final RxString _selectedRole = AppConstants.roleCustomer.obs;

  bool get isLoading => _isLoading.value;
  String get selectedRole => _selectedRole.value;

  void setRole(String role) {
    _selectedRole.value = role;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      _isLoading.value = true;

      final result = await _authRepository.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: _selectedRole.value,
      );

      if (result.isSuccess) {
        Get.snackbar('Success', 'Registration successful');
        return true;
      } else {
        Get.snackbar('Error', result.message ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred during registration');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
