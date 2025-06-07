import 'package:flutter/material.dart';
import 'package:del_pick/app/themes/app_colors.dart';
import 'package:del_pick/app/themes/app_text_styles.dart';
import 'package:del_pick/app/themes/app_dimensions.dart';

enum ButtonType { primary, secondary, outlined, text, icon }

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Widget? child;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final bool isExpanded;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double? elevation;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    this.text,
    this.icon,
    this.child,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.isExpanded = false,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.elevation,
    this.textStyle,
  });

  // Named constructors for common button types
  const CustomButton.primary({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.isExpanded = false,
  })  : type = ButtonType.primary,
        child = null,
        backgroundColor = null,
        foregroundColor = null,
        borderColor = null,
        borderRadius = null,
        padding = null,
        mainAxisAlignment = MainAxisAlignment.center,
        crossAxisAlignment = CrossAxisAlignment.center,
        elevation = null,
        textStyle = null;

  const CustomButton.secondary({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.isExpanded = false,
  })  : type = ButtonType.secondary,
        child = null,
        backgroundColor = null,
        foregroundColor = null,
        borderColor = null,
        borderRadius = null,
        padding = null,
        mainAxisAlignment = MainAxisAlignment.center,
        crossAxisAlignment = CrossAxisAlignment.center,
        elevation = null,
        textStyle = null;

  const CustomButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.isExpanded = false,
  })  : type = ButtonType.outlined,
        child = null,
        backgroundColor = null,
        foregroundColor = null,
        borderColor = null,
        borderRadius = null,
        padding = null,
        mainAxisAlignment = MainAxisAlignment.center,
        crossAxisAlignment = CrossAxisAlignment.center,
        elevation = null,
        textStyle = null;

  const CustomButton.text({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.isExpanded = false,
  })  : type = ButtonType.text,
        child = null,
        backgroundColor = null,
        foregroundColor = null,
        borderColor = null,
        borderRadius = null,
        padding = null,
        mainAxisAlignment = MainAxisAlignment.center,
        crossAxisAlignment = CrossAxisAlignment.center,
        elevation = null,
        textStyle = null;

  const CustomButton.icon({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.elevation,
  })  : type = ButtonType.icon,
        text = null,
        child = null,
        borderColor = null,
        borderRadius = null,
        padding = null,
        isExpanded = false,
        mainAxisAlignment = MainAxisAlignment.center,
        crossAxisAlignment = CrossAxisAlignment.center,
        textStyle = null;

  @override
  Widget build(BuildContext context) {
    if (type == ButtonType.icon) {
      return _buildIconButton();
    }

    return _buildButton();
  }

  Widget _buildButton() {
    Widget buttonChild = _buildButtonContent();

    if (isExpanded) {
      buttonChild = SizedBox(width: double.infinity, child: buttonChild);
    } else if (width != null) {
      buttonChild = SizedBox(width: width, child: buttonChild);
    }

    return SizedBox(height: height ?? _getButtonHeight(), child: buttonChild);
  }

  Widget _buildButtonContent() {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: _getOnPressed(),
          style: _getElevatedButtonStyle(),
          child: _getButtonChild(),
        );
      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: _getOnPressed(),
          style: _getSecondaryButtonStyle(),
          child: _getButtonChild(),
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: _getOnPressed(),
          style: _getOutlinedButtonStyle(),
          child: _getButtonChild(),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: _getOnPressed(),
          style: _getTextButtonStyle(),
          child: _getButtonChild(),
        );
      default:
        return ElevatedButton(
          onPressed: _getOnPressed(),
          style: _getElevatedButtonStyle(),
          child: _getButtonChild(),
        );
    }
  }

  Widget _buildIconButton() {
    return SizedBox(
      width: width ?? _getIconButtonSize(),
      height: height ?? _getIconButtonSize(),
      child: IconButton(
        onPressed: _getOnPressed(),
        icon: isLoading
            ? SizedBox(
                width: _getIconSize(),
                height: _getIconSize(),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? AppColors.primary,
                  ),
                ),
              )
            : Icon(icon, size: _getIconSize(), color: foregroundColor),
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppDimensions.radiusLG,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getButtonChild() {
    if (child != null) {
      return child!;
    }

    if (isLoading) {
      return SizedBox(
        width: _getLoadingIndicatorSize(),
        height: _getLoadingIndicatorSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getLoadingIndicatorColor(),
          ),
        ),
      );
    }

    if (icon != null && text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: AppDimensions.spacingSM),
          Text(text!, style: textStyle ?? _getTextStyle()),
        ],
      );
    }

    if (icon != null) {
      return Icon(icon, size: _getIconSize());
    }

    return Text(text ?? '', style: textStyle ?? _getTextStyle());
  }

  VoidCallback? _getOnPressed() {
    if (!isEnabled || isLoading) {
      return null;
    }
    return onPressed;
  }

  ButtonStyle _getElevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.textOnPrimary,
      elevation: elevation ?? 2,
      padding: padding ?? _getButtonPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDimensions.radiusLG,
        ),
      ),
      textStyle: _getTextStyle(),
    );
  }

  ButtonStyle _getSecondaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.secondary,
      foregroundColor: foregroundColor ?? AppColors.textOnSecondary,
      elevation: elevation ?? 2,
      padding: padding ?? _getButtonPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDimensions.radiusLG,
        ),
      ),
      textStyle: _getTextStyle(),
    );
  }

  ButtonStyle _getOutlinedButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: foregroundColor ?? AppColors.primary,
      side: BorderSide(
        color: borderColor ?? AppColors.primary,
        width: AppDimensions.borderWidth,
      ),
      padding: padding ?? _getButtonPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDimensions.radiusLG,
        ),
      ),
      textStyle: _getTextStyle(),
    );
  }

  ButtonStyle _getTextButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: foregroundColor ?? AppColors.primary,
      padding: padding ?? _getButtonPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDimensions.radiusLG,
        ),
      ),
      textStyle: _getTextStyle(),
    );
  }

  EdgeInsetsGeometry _getButtonPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMD,
          vertical: AppDimensions.paddingSM,
        );
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLG,
          vertical: AppDimensions.paddingMD,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXL,
          vertical: AppDimensions.paddingLG,
        );
    }
  }

  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return AppDimensions.buttonHeightSM;
      case ButtonSize.medium:
        return AppDimensions.buttonHeightMD;
      case ButtonSize.large:
        return AppDimensions.buttonHeightLG;
    }
  }

  double _getIconButtonSize() {
    switch (size) {
      case ButtonSize.small:
        return AppDimensions.buttonHeightSM;
      case ButtonSize.medium:
        return AppDimensions.buttonHeightMD;
      case ButtonSize.large:
        return AppDimensions.buttonHeightLG;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return AppDimensions.iconSM;
      case ButtonSize.medium:
        return AppDimensions.iconMD;
      case ButtonSize.large:
        return AppDimensions.iconLG;
    }
  }

  double _getLoadingIndicatorSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  Color _getLoadingIndicatorColor() {
    switch (type) {
      case ButtonType.primary:
        return foregroundColor ?? AppColors.textOnPrimary;
      case ButtonType.secondary:
        return foregroundColor ?? AppColors.textOnSecondary;
      case ButtonType.outlined:
      case ButtonType.text:
        return foregroundColor ?? AppColors.primary;
      case ButtonType.icon:
        return foregroundColor ?? AppColors.primary;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTextStyles.buttonSmall;
      case ButtonSize.medium:
        return AppTextStyles.buttonMedium;
      case ButtonSize.large:
        return AppTextStyles.buttonLarge;
    }
  }
}
