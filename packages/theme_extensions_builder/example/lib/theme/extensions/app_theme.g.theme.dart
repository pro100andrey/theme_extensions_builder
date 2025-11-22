// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'app_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$AppThemeExtensionMixin on ThemeExtension<AppThemeExtension> {
  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    LayoutMode? layoutMode,
  }) {
    final object = (this as AppThemeExtension);

    return AppThemeExtension(
      primaryColor: primaryColor ?? object.primaryColor,
      backgroundColor: backgroundColor ?? object.backgroundColor,
      layoutMode: layoutMode ?? object.layoutMode,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    final otherValue = other;
    if (otherValue is! AppThemeExtension) {
      return this;
    }

    final value = (this as AppThemeExtension);

    return AppThemeExtension(
      primaryColor: t < 0.5 ? value.primaryColor : otherValue.primaryColor,
      backgroundColor: t < 0.5
          ? value.backgroundColor
          : otherValue.backgroundColor,
      layoutMode: t < 0.5 ? value.layoutMode : otherValue.layoutMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! AppThemeExtension) {
      return false;
    }

    final value = (this as AppThemeExtension);

    return other.primaryColor == value.primaryColor &&
        other.backgroundColor == value.backgroundColor &&
        other.layoutMode == value.layoutMode;
  }

  @override
  int get hashCode {
    final value = (this as AppThemeExtension);

    return Object.hash(
      runtimeType,
      value.primaryColor,
      value.backgroundColor,
      value.layoutMode,
    );
  }
}

extension AppThemeExtensionBuildContext on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
