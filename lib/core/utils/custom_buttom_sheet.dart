import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:del_pick/app/themes/app_colors.dart';
import 'package:del_pick/app/themes/app_text_styles.dart';
import 'package:del_pick/app/themes/app_dimensions.dart';

class CustomBottomSheet {
  /// Show basic bottom sheet
  static Future<T?> show<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    Color? backgroundColor,
    double? height,
  }) {
    return Get.bottomSheet<T>(
      Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXL),
          ),
        ),
        child: child,
      ),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
    );
  }

  /// Show bottom sheet with header
  static Future<T?> showWithHeader<T>({
    required String title,
    required Widget child,
    List<Widget>? actions,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    VoidCallback? onClose,
  }) {
    return show<T>(
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLG),
            child: Row(
              children: [
                Expanded(child: Text(title, style: AppTextStyles.h5)),
                if (actions != null) ...actions,
                if (onClose != null)
                  IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
              ],
            ),
          ),

          const Divider(height: 1),

          // Content
          Flexible(child: child),
        ],
      ),
    );
  }

  /// Show confirmation bottom sheet
  static Future<bool?> showConfirmation({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show<bool>(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Text(title, style: AppTextStyles.h5, textAlign: TextAlign.center),

            const SizedBox(height: AppDimensions.spacingLG),

            // Message
            Text(
              message,
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.spacingXXL),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back(result: false);
                      onCancel?.call();
                    },
                    child: Text(cancelText ?? 'Cancel'),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingLG),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(result: true);
                      onConfirm?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor ?? AppColors.primary,
                    ),
                    child: Text(confirmText ?? 'Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show options bottom sheet
  static Future<T?> showOptions<T>({
    required String title,
    required List<BottomSheetOption<T>> options,
    bool showCancel = true,
  }) {
    return showWithHeader<T>(
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...options.map(
            (option) => ListTile(
              leading: option.icon != null ? Icon(option.icon) : null,
              title: Text(option.title),
              subtitle: option.subtitle != null ? Text(option.subtitle!) : null,
              onTap: () => Get.back(result: option.value),
              enabled: option.enabled,
            ),
          ),
          if (showCancel) ...[
            const Divider(),
            ListTile(
              title: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onTap: () => Get.back(),
            ),
          ],
        ],
      ),
    );
  }

  /// Show image picker bottom sheet
  static Future<ImageSource?> showImagePicker() {
    return showOptions<ImageSource>(
      title: 'Select Image Source',
      options: [
        BottomSheetOption(
          title: 'Camera',
          icon: Icons.camera_alt,
          value: ImageSource.camera,
        ),
        BottomSheetOption(
          title: 'Gallery',
          icon: Icons.photo_library,
          value: ImageSource.gallery,
        ),
      ],
    );
  }

  /// Show filter bottom sheet
  static Future<Map<String, dynamic>?> showFilter({
    required List<FilterOption> filters,
    Map<String, dynamic>? currentFilters,
  }) {
    final filterController = FilterController(filters, currentFilters);

    return showWithHeader<Map<String, dynamic>>(
      title: 'Filters',
      isScrollControlled: true,
      actions: [
        TextButton(
          onPressed: () {
            filterController.clearAll();
          },
          child: const Text('Clear All'),
        ),
      ],
      child: GetBuilder<FilterController>(
        init: filterController,
        builder: (controller) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.filters.length,
                itemBuilder: (context, index) {
                  final filter = controller.filters[index];
                  return _buildFilterItem(filter, controller);
                },
              ),
            ),

            // Apply button
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(result: controller.getFilters());
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFilterItem(
    FilterOption filter,
    FilterController controller,
  ) {
    switch (filter.type) {
      case FilterType.toggle:
        return SwitchListTile(
          title: Text(filter.title),
          value: controller.getValue(filter.key) ?? false,
          onChanged: (value) => controller.setValue(filter.key, value),
        );

      case FilterType.slider:
        return ListTile(
          title: Text(filter.title),
          subtitle: Slider(
            min: filter.min ?? 0,
            max: filter.max ?? 100,
            value:
                (controller.getValue(filter.key) ?? filter.min ?? 0).toDouble(),
            onChanged: (value) => controller.setValue(filter.key, value),
          ),
        );

      case FilterType.dropdown:
        return ListTile(
          title: Text(filter.title),
          subtitle: DropdownButton<String>(
            isExpanded: true,
            value: controller.getValue(filter.key),
            items: filter.options
                ?.map(
                  (option) =>
                      DropdownMenuItem(value: option, child: Text(option)),
                )
                .toList(),
            onChanged: (value) => controller.setValue(filter.key, value),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

/// Bottom sheet option model
class BottomSheetOption<T> {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final T value;
  final bool enabled;

  BottomSheetOption({
    required this.title,
    this.subtitle,
    this.icon,
    required this.value,
    this.enabled = true,
  });
}

/// Image source enum
enum ImageSource { camera, gallery }

/// Filter option model
class FilterOption {
  final String key;
  final String title;
  final FilterType type;
  final List<String>? options;
  final double? min;
  final double? max;
  final dynamic defaultValue;

  FilterOption({
    required this.key,
    required this.title,
    required this.type,
    this.options,
    this.min,
    this.max,
    this.defaultValue,
  });
}

/// Filter type enum
enum FilterType { toggle, slider, dropdown }

/// Filter controller
class FilterController extends GetxController {
  final List<FilterOption> filters;
  final Map<String, dynamic> _values = {};

  FilterController(this.filters, Map<String, dynamic>? initialValues) {
    if (initialValues != null) {
      _values.addAll(initialValues);
    }
  }

  dynamic getValue(String key) => _values[key];

  void setValue(String key, dynamic value) {
    _values[key] = value;
    update();
  }

  void clearAll() {
    _values.clear();
    update();
  }

  Map<String, dynamic> getFilters() => Map.from(_values);
}
