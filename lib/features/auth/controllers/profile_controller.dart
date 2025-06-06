import 'package:get/get.dart';
import 'package:delivery_app/data/repositories/auth_repository.dart';
import 'package:delivery_app/data/models/auth/user_model.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository;

  ProfileController(this._authRepository);

  final RxBool _isLoading = false.obs;
  final Rx<UserModel?> _user = Rx<UserModel?>(null);

  bool get isLoading => _isLoading.value;
  UserModel? get user => _user.value;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      _isLoading.value = true;

      final result = await _authRepository.getProfile();

      if (result.isSuccess && result.data != null) {
        _user.value = result.data;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile');
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
        _user.value = result.data;
        Get.snackbar('Success', 'Profile updated successfully');
        return true;
      } else {
        Get.snackbar('Error', result.message ?? 'Update failed');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred during update');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
