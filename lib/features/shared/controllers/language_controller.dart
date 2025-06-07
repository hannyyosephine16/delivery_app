import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:del_pick/core/services/local/storage_service.dart';
import 'package:del_pick/core/constants/storage_constants.dart';

class LanguageController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxString _currentLanguage = 'en'.obs;
  String get currentLanguage => _currentLanguage.value;

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  void _loadLanguage() {
    _currentLanguage.value =
        _storage.readString(StorageConstants.language) ?? 'en';
  }

  void changeLanguage(String languageCode) {
    _currentLanguage.value = languageCode;
    _storage.writeString(StorageConstants.language, languageCode);
    Get.updateLocale(Locale(languageCode));
  }
}
