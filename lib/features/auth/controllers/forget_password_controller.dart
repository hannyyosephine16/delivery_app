import 'package:get/get.dart';
import 'package:delivery_app/data/repositories/auth_repository.dart';

class ForgetPasswordController extends GetxController {
  final AuthRepository _authRepository;

  ForgetPasswordController(this._authRepository);

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  Future<bool> forgotPassword(String email) async {
    try {
      _isLoading.value = true;

      final result = await _authRepository.forgotPassword(email);

      if (result.isSuccess) {
        Get.snackbar('Success', 'Password reset email sent');
        return true;
      } else {
        Get.snackbar('Error', result.message ?? 'Failed to send reset email');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
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
        Get.snackbar('Success', 'Password reset successfully');
        Get.offAllNamed('/login');
        return true;
      } else {
        Get.snackbar('Error', result.message ?? 'Password reset failed');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
