import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_app/app/config/app_config.dart';
import 'package:delivery_app/app/themes/app_theme.dart';
import 'package:delivery_app/app/routes/app_pages.dart';
import 'package:delivery_app/app/bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration
  await AppConfig.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DelPick',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Routes
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      // Initial Binding
      initialBinding: InitialBinding(),

      // Locale
      locale: const Locale('id', 'ID'),
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}
