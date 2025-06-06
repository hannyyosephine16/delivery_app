import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/services/local/storage_service.dart';
import 'package:delivery_app/core/constants/storage_constants.dart';

class ThemeController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxBool _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() {
    _isDarkMode.value = _storage.readBoolWithDefault(
      StorageConstants.isDarkMode,
      false,
    );
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _storage.writeBool(StorageConstants.isDarkMode, _isDarkMode.value);
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
