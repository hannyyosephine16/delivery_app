import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_dimensions.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnSecondary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.textOnPrimary,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: AppDimensions.appBarElevation,
        centerTitle: true,
        titleTextStyle: AppTextStyles.appBarTitle,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // Scaffold Theme
      scaffoldBackgroundColor: AppColors.background,

      // Card Theme
      cardTheme: const CardTheme(
        color: AppColors.surface,
        elevation: AppDimensions.cardElevation,
        margin: EdgeInsets.all(AppDimensions.cardMargin),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
            vertical: AppDimensions.paddingMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          ),
          textStyle: AppTextStyles.buttonMedium,
          minimumSize: const Size(0, AppDimensions.buttonHeightLG),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
            vertical: AppDimensions.paddingMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          ),
          textStyle: AppTextStyles.buttonMedium,
          minimumSize: const Size(0, AppDimensions.buttonHeightLG),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLG,
            vertical: AppDimensions.paddingMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          ),
          textStyle: AppTextStyles.buttonMedium,
          minimumSize: const Size(0, AppDimensions.buttonHeightLG),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.all(AppDimensions.textFieldPadding),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.textFieldBorderRadius,
          ),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.textFieldBorderRadius,
          ),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.textFieldBorderRadius,
          ),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.textFieldBorderRadius,
          ),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.textFieldBorderRadius,
          ),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.textFieldLabel,
        hintStyle: AppTextStyles.textFieldHint,
        errorStyle: AppTextStyles.errorText,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTextStyles.navigationLabel,
        unselectedLabelStyle: AppTextStyles.navigationLabel,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Tab Bar Theme
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.tabLabel,
        unselectedLabelStyle: AppTextStyles.tabLabel,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: AppDimensions.tabIndicatorHeight,
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: AppDimensions.fabElevation,
        shape: CircleBorder(),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        labelStyle: AppTextStyles.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.chipPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.chipRadius),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.dialogRadius),
        ),
        titleTextStyle: AppTextStyles.h5,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textOnPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.snackbarRadius),
        ),
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.all(AppDimensions.snackbarMargin),
        // margin: const EdgeInsets.all(AppDimensions.snackbarMargin),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: AppDimensions.dividerThickness,
        space: AppDimensions.dividerHeight,
        indent: AppDimensions.dividerIndent,
        endIndent: AppDimensions.dividerIndent,
      ),

      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.listItemPadding,
        ),
        minVerticalPadding: AppDimensions.paddingSM,
        tileColor: AppColors.surface,
        textColor: AppColors.textPrimary,
        iconColor: AppColors.textSecondary,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return AppColors.border;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.surface;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textOnPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
        ),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
      ),

      // Slider Theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.border,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primaryLight,
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: AppTextStyles.bodySmall,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.border,
        circularTrackColor: AppColors.border,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        displaySmall: AppTextStyles.h3,
        headlineLarge: AppTextStyles.h4,
        headlineMedium: AppTextStyles.h5,
        headlineSmall: AppTextStyles.h6,
        titleLarge: AppTextStyles.h5,
        titleMedium: AppTextStyles.h6,
        titleSmall: AppTextStyles.labelLarge,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnSecondary,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textOnPrimary,
        error: AppColors.error,
        onError: AppColors.textOnPrimary,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardTheme: lightTheme.cardTheme.copyWith(color: AppColors.surfaceDark),
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: AppColors.surfaceDark,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      bottomNavigationBarTheme: lightTheme.bottomNavigationBarTheme.copyWith(
        backgroundColor: AppColors.surfaceDark,
      ),
      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.textFieldBorderRadius,
          ),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.textFieldBorderRadius,
          ),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
      ),
      dialogTheme: lightTheme.dialogTheme.copyWith(
        backgroundColor: AppColors.surfaceDark,
      ),
      listTileTheme: lightTheme.listTileTheme.copyWith(
        tileColor: AppColors.surfaceDark,
        textColor: AppColors.textOnPrimary,
      ),
      dividerTheme: lightTheme.dividerTheme.copyWith(
        color: AppColors.borderDark,
      ),
    );
  }
}
