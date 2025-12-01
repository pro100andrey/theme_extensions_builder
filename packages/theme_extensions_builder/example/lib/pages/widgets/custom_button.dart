import 'package:flutter/material.dart';

import '../../theme/extensions/widgets/button_theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final buttonTheme = context.buttonTheme;
    final isEnabled = onPressed != null && !isLoading;

    final padding = switch (size) {
      ButtonSize.small => buttonTheme.smallPadding,
      ButtonSize.medium => buttonTheme.mediumPadding,
      ButtonSize.large => buttonTheme.largePadding,
    };

    final height = switch (size) {
      ButtonSize.small => buttonTheme.smallHeight,
      ButtonSize.medium => buttonTheme.mediumHeight,
      ButtonSize.large => buttonTheme.largeHeight,
    };

    final backgroundColor = switch (variant) {
      ButtonVariant.primary => buttonTheme.primaryColor,
      ButtonVariant.secondary => buttonTheme.secondaryColor,
      ButtonVariant.outlined => Colors.transparent,
      ButtonVariant.text => Colors.transparent,
    };

    final foregroundColor = switch (variant) {
      ButtonVariant.primary || ButtonVariant.secondary => buttonTheme.textColor,
      ButtonVariant.outlined || ButtonVariant.text => buttonTheme.primaryColor,
    };

    final border = switch (variant) {
      ButtonVariant.outlined => BorderSide(
        color: buttonTheme.outlinedBorderColor,
        width: buttonTheme.borderWidth,
      ),
      _ => BorderSide.none,
    };

    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          backgroundColor: isEnabled
              ? backgroundColor
              : buttonTheme.disabledColor,
          foregroundColor: foregroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: buttonTheme.borderRadius,
            side: border,
          ),
          elevation: variant == ButtonVariant.text ? 0 : buttonTheme.elevation,
          disabledBackgroundColor: buttonTheme.disabledColor,
          disabledForegroundColor: buttonTheme.textColor.withAlpha(128),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    SizedBox(width: buttonTheme.iconSpacing),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}
