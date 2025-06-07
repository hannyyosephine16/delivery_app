import 'package:get/get.dart';
import 'package:del_pick/data/repositories/auth_repository.dart';
import 'package:del_pick/app/routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;

  LoginController(this._authRepository);

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading.value = true;

      final result = await _authRepository.login(
        email: email,
        password: password,
      );

      if (result.isSuccess) {
        Get.snackbar('Success', 'Login successful');
        // Navigation will be handled by AuthController
        return true;
      } else {
        Get.snackbar('Error', result.message ?? 'Login failed');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred during login');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
